import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContactItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const ContactItem({
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: Text(user.username),
      //subtitle: Text(message),
      trailing: const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [],
      ),
    );
  }
}
