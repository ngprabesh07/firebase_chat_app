import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthService extends ChangeNotifier {
  //instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //instance if cloud_firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //log in user
  Future<UserCredential> loginUser(String email, String password) async {
    debugPrint("USER : ${email.toString()}");
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email.toString(), password: password.toString());
      debugPrint("UserCredential $userCredential");
      //after login create a document for the user in the users collection
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("ERROR : ${e.toString()}");
      debugPrint("ERROR : ${password.toString()}");
      throw Exception("ERROR  ${e.toString()}");
    }
  }

  //log out
  Future<void> SignOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
