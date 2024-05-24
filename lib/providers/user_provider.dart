import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserServiceProvider with ChangeNotifier {
  // list of users
  late CollectionReference users;
  late FirebaseFirestore firestore;
  List<UserModel> _users = [];

  UserServiceProvider() {
    firestore = FirebaseFirestore.instance;
    users = firestore.collection('users');
  }

  // get all users except the current user
  Future<List<UserModel>> getUsers(String currentUserId) async {
    QuerySnapshot userDocs = await users.get();
    _users = userDocs.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .where((user) => user.uid != currentUserId)
        .toList();
    return _users;
  }
}
