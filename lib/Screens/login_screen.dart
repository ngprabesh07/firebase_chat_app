import 'package:firebasechatapp/auth/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  void logIn(String e, String p) async {
    //get the auth services
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.loginUser(e, p);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("error occurs here : ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_outlined,
                    size: 100,
                  ),
                  RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const [
                        TextSpan(
                          text: 'Log-in To  ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'MY-CHAT-APP ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        )
                      ])),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100.0, left: 20, right: 20),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText:
                            'Username', // Label text above the input field
                        hintText:
                            'Enter your username', // Hint text inside the input field
                        prefixIcon: const Icon(Icons
                            .person), // Icon to display before the input field
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            email.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          // Add a border around the input field
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled:
                            true, // Fill the input field with a background color
                        fillColor: Colors
                            .grey[200], // Background color of the input field
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 20, right: 20, bottom: 150),
                    child: TextFormField(
                      controller: password,
                      decoration: InputDecoration(
                        labelText: 'password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      logIn(email.text, password.text);
                      ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      );
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
