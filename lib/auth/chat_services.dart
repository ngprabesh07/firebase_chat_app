import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/message.dart';

class ChatService extends ChangeNotifier {
  //get the instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String recieverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //CREATE A NEW MESSAGE
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        revieverId: recieverId,
        message: message,
        timestamp: timestamp);

    //CONSTRUCT CHAT ROOM ID FROM CURRENT ID AND RECIVER ID (stored to ensure uniquenesess )
    List<String> ids = [currentUserId, recieverId];
    ids.toList();
    String chatRoomId = ids.join("_");
    //add new message to database

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GET NEW MESSAGE TO DATABASE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending )
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
