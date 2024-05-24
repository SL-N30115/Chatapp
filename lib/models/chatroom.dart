import 'message.dart';

class ChatRoomModel {
  String chatroomID;
  List<String> participants;
  List<MessageModel> messages;

  ChatRoomModel({
    required this.chatroomID,
    required this.participants,
    required this.messages,
  });

  // Factory constructor to create a ChatRoom from JSON
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatroomID: json['chatroomID'],
      participants: List<String>.from(json['participants']),
      messages: (json['messages'] as List<dynamic>)
          .map((messageJson) =>
              MessageModel.fromJson(messageJson as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert a ChatRoom to JSON
  Map<String, dynamic> toJson() {
    return {
      'chatroomID': chatroomID,
      'participants': participants,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
