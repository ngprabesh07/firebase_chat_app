import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapp/auth/chat_services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userEmail;
  final String userId;
  const ChatScreen({super.key, required this.userEmail, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.userId, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.userEmail),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: _messageList(),
            ),
            //uder input

            // SizedBox(
            // child: _messageInput(),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        controller: _messageController,
                        decoration:const InputDecoration(
                          hintText: 'type message'
                        ),
                      ),
                    ),
                      IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send)),
                  ],
                ),
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  //message list
  Widget _messageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.userId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR AAYO MAKADOCS");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Padding(
              padding:  EdgeInsets.all(78.0),
              child:  SizedBox(
                height: 150,
                width: 150,
                child:  CircularProgressIndicator()),
            );
          }
          return SizedBox(
            child: ListView(
              shrinkWrap: true,
              children:
                  snapshot.data!.docs.map((e) => _buildMessageItem(e)).toList(),
            ),
          );
        });
  }

  //message item
  Widget _buildMessageItem(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;
    //align the message to right and left sender and revieved message
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        alignment: alignment,
        decoration: BoxDecoration(
          color:const  Color.fromARGB(255, 199, 195, 211),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data['message'],style:const TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  //message input
  Widget _messageInput() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          TextFormField(
            controller: _messageController,
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_upward))
        ],
      ),
    );
  }
}
