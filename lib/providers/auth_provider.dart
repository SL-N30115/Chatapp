import 'package:chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServiceProvider with ChangeNotifier {
  late CollectionReference users;
  late FirebaseFirestore firestore;

  AuthServiceProvider() {
    firestore = FirebaseFirestore.instance;
    users = firestore.collection('users');
  }

  // sign in user
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // get user data from firestore and return it
      if (credential.user != null) {
        DocumentSnapshot userDoc = await users.doc(credential.user!.uid).get();
        if (userDoc.exists) {
          return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
        } else {
          throw ("Error Occurs, Please try later");
        }
      } else {
        throw ("Error Occurs, Please try later");
      }
    } on FirebaseAuthException catch (e) {
      throw ("Invalid email or password");
    }
  }

  // write user data to firestore
  Future<bool> signUp(
      UserModel user, String password, String confirmedPassword) async {
    try {
      bool isValid = signUpValidation(user, password, confirmedPassword);

      if (isValid) {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: user.email, password: password);
        await users.doc(credential.user!.uid).set({
          'email': user.email,
          'username': user.username,
          'uid': credential.user!.uid,
        });
        return true;
      }
    } on FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
    return false;
  }

  bool signUpValidation(
      UserModel user, String passworld, String confirmedPassword) {
    if (!isValidEmail(user.email)) {
      throw ('Invalid email address');
    }

    if (user.username.isEmpty || user.username.length < 3) {
      throw ('Username must be at least 3 characters long');
    }

    if (passworld.isEmpty || passworld.length < 6) {
      throw ('Password must be at least 6 characters long');
    }

    if (passworld != confirmedPassword) {
      throw ('Passwords do not match');
    }

    return true;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return emailRegExp.hasMatch(email);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
