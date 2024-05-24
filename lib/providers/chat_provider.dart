import 'package:chat_app/models/chatroom.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatServiceProvider with ChangeNotifier {
  late CollectionReference chatrooms;
  late FirebaseFirestore firestore;
  late ChatRoomModel currentChatroom;
  late List<MessageModel> messages = [];
  late String currentChatRoomID;

  ChatServiceProvider() {
    firestore = FirebaseFirestore.instance;
    chatrooms = firestore.collection('chatrooms');
  }

  // add chatroom, the chatroom id will be currentUser-targetUserid
  Future<ChatRoomModel> addChatroom(
      String currentUserID, String targetUserId) async {
    try {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomID: '$currentUserID-$targetUserId',
        participants: [currentUserID, targetUserId],
        messages: List.empty(),
      );
      currentChatRoomID = '$currentUserID-$targetUserId';
      QuerySnapshot chatroomDocs = await chatrooms.where(FieldPath.documentId,
          whereIn: [
            '$currentUserID-$targetUserId',
            '$targetUserId-$currentUserID'
          ]).get();

      if (chatroomDocs.docs.isNotEmpty) {
        return ChatRoomModel.fromJson(
            chatroomDocs.docs.first.data() as Map<String, dynamic>);
      } else {
        await chatrooms.doc(newChatroom.chatroomID).set(newChatroom.toJson());
        return newChatroom;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<ChatRoomModel> getChatroom(
      String currentUserID, String targetUserId) async {
    try {
      messages = [];
      currentChatroom = ChatRoomModel(
        chatroomID: '',
        participants: [],
        messages: [],
      );
      QuerySnapshot chatroomDocs = await chatrooms.where(FieldPath.documentId,
          whereIn: [
            '$currentUserID-$targetUserId',
            '$targetUserId-$currentUserID'
          ]).get();

      if (chatroomDocs.docs.isNotEmpty) {
        currentChatroom = ChatRoomModel.fromJson(
            chatroomDocs.docs.first.data() as Map<String, dynamic>);
        await getMessageHistory(currentChatroom.chatroomID);
        return currentChatroom;
      } else {
        var currentChatroom = await addChatroom(currentUserID, targetUserId);
        return currentChatroom;
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // get message History by chatroomID
  Future<void> getMessageHistory(String chatroomID) async {
    try {
      QuerySnapshot messageDocs =
          await chatrooms.doc(chatroomID).collection('messages').get();
      messages = messageDocs.docs
          .map((doc) =>
              MessageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw e.toString();
    }
  }

  // get msaage History stream by chatroomID
  Stream<List<MessageModel>> getMessageHistoryStream(String chatroomID) {
    return chatrooms
        .doc(chatroomID)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                MessageModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  void listenToMessages() {
    getMessageHistoryStream(currentChatroom.chatroomID).listen((event) {
      messages = event;
      notifyListeners();
    });
  }

  Future<void> sendMessage(
      String currentUserID, String targetUserId, String message) async {
    try {
      MessageModel newMessage = MessageModel(
        senderID: currentUserID,
        content: message,
        sentAt: DateTime.now(),
      );

      if (currentChatroom.chatroomID.isEmpty) {
        currentChatroom = await getChatroom(currentUserID, targetUserId);
      }

      await chatrooms
          .doc(currentChatroom.chatroomID)
          .collection('messages')
          .add(newMessage.toJson());
      messages.add(newMessage);
    } catch (e) {
      throw e.toString();
    }
  }
}
