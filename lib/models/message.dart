import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String content;
  String senderID;
  DateTime sentAt;

  MessageModel({
    required this.content,
    required this.senderID,
    required this.sentAt,
  });

  // Factory constructor to create a Message from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      content: json['content'],
      senderID: json['senderID'],
      sentAt: (json['sentAt'] as Timestamp)
          .toDate(), // Assuming sentAt is stored as a Timestamp in Firestore
    );
  }

  // Method to convert a Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'senderID': senderID,
      'sentAt': sentAt,
    };
  }
}
