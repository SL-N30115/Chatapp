import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  late CollectionReference users;
  late FirebaseFirestore firestore;

  AuthProvider() {
    firestore = FirebaseFirestore.instance;
    users = firestore.collection('users');
  }

  void login(String email, String password) {
    // Api / Firebase call
    if (email.isNotEmpty && password.isNotEmpty) {
      notifyListeners();
    }
  }

  // sign in user
  Future<bool> signIn(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await users
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        throw ('Invalid email or password');
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // write user data to firestore
  Future<bool> signUp(User user, String confirmedPassword) async {
    try {
      bool isValid = signUpValidation(user, confirmedPassword);

      if (isValid) {
        QuerySnapshot querySnapshot =
            await users.where('email', isEqualTo: user.email).get();
        if (querySnapshot.docs.isEmpty) {
          await users.add({
            'email': user.email,
            'username': user.username,
            'password': user.password
          });
          return true;
        } else {
          throw ('email already exists');
        }
      }
    } catch (e) {
      throw e.toString();
    }
    return false;
  }

  bool signUpValidation(User user, String confirmedPassword) {
    if (!isValidEmail(user.email)) {
      throw ('Invalid email address');
    }

    if (user.username.isEmpty || user.username.length < 3) {
      throw ('Username must be at least 3 characters long');
    }

    if (user.password.isEmpty || user.password.length < 6) {
      throw ('Password must be at least 6 characters long');
    }

    if (user.password != confirmedPassword) {
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
}
