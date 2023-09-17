import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String revieverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.revieverId,
    required this.message,
    required this.timestamp,
  });
  //CONVERT to MAP
  Map<String, dynamic> toMap() {
    return {
      'senderId':senderId,
      'senderEmail':senderEmail,
      'revieverId':revieverId,
      'message':message,
      'timestamp':timestamp,
    };
  }
}
