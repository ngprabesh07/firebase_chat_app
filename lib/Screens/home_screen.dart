import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapp/Screens/chat_screen.dart';
import 'package:firebasechatapp/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //firebase auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("My Chat App"),
        actions: [
          Row(
            children: [
              // Round profile icon button
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        title: const Text('Profile Options'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Option 1'),
                              onTap: () {
                                // Handle Option 1
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('dkhfkhd  '),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('Log out'),
                              onTap: () async {
                                // Handle Option 3
                                Navigator.of(context).pop();
                                await provider.SignOut();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')),
              ),
              const SizedBox(
                  width:
                      16), // Add spacing between the icon and the dropdown menu
            ],
          ),
        ],
      ),
      drawer:  Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Center(
                child: Text(
                  _firebaseAuth.currentUser!.email.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Handle Home action
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.precision_manufacturing),
              title: const Text('Avatar'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.notification_add),
              title: const Text('Notifications'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.refresh_outlined),
              title: const Text('Storage and Data'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.language),
              title: const Text('App Language'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: const Text('Invite Friends'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
             ListTile(
              leading: const Icon(Icons.accessibility_new),
              title: const Text('About Us'),
              onTap: () {
                // Handle Settings action
                Navigator.pop(context); // Close the drawer
              },
            ),
            const Divider(), // Add a divider between items
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout action
                Navigator.pop(context); // Close the drawer
                // Add your logout logic here
              },
            ),
          ],
        ),
      ),
      body: _UserLists(),
    );
  }

  Widget _UserLists() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error ");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //display all user except current user
    if (_firebaseAuth.currentUser!.email != data['email']) {
      return ListTile(
        leading:const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://img.freepik.com/free-vector/mysterious-mafia-man-smoking-cigarette_52683-34828.jpg?size=626&ext=jpg&ga=GA1.1.615033183.1694869455&semt=ais'),
        ),
        title: Text(data['email'].toString(),style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
        onTap: () {
          //tap event
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ChatScreen(
                      userEmail: data['email'], userId: data['uid'])));
        },
      );
    } else {
      return const Text(" ");
    }
  }
}
