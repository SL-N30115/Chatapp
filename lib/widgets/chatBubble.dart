import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final DateTime sentAt;

  const ChatBubble(
      {required this.text, required this.sentAt, this.isSent = false});

  @override
  Widget build(BuildContext context) {
    String formattedTime =
        "${sentAt.hour}:${sentAt.minute.toString().padLeft(2, '0')} ${sentAt.hour >= 12 ? 'PM' : 'AM'}";
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isSent ? Colors.red[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, textAlign: TextAlign.center),
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
