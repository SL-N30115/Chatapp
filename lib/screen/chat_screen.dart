import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/providers/user_provider.dart';
import 'package:chat_app/widgets/chatBubble.dart';
import 'package:chat_app/widgets/contactItem.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel user;

  ChatRoomScreen({required this.user});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  bool onChatroom = false;
  String targetUserName = '';
  List<UserModel> users = [];
  final TextEditingController inputController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final ScrollController messageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Invoke getUsers after the widget has built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
      // Start listening to messages
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ChatServiceProvider>(context, listen: false)
            .listenToMessages();
      });
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    searchController.dispose();
    messageScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  void onSendMessage() {
    final chatProvider =
        Provider.of<ChatServiceProvider>(context, listen: false);
    chatProvider.sendMessage(
        widget.user.uid, users[0].uid, inputController.text);
    inputController.clear();
  }

  Future<void> getUsers() async {
    final userProvider =
        Provider.of<UserServiceProvider>(context, listen: false);
    var _users = await userProvider.getUsers(widget.user.uid);
    setState(() {
      users = _users;
    });
  }

  Future<void> getChatroom(String targetUserId) async {
    final chatProvider =
        Provider.of<ChatServiceProvider>(context, listen: false);
    var chatroom =
        await chatProvider.getChatroom(widget.user.uid, targetUserId);
    setState(() {
      onChatroom = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserServiceProvider>(context);
    final chatProvider = Provider.of<ChatServiceProvider>(context);
    {
      return Scaffold(
        body: Row(
          children: [
            // Left side - Contacts list
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    // header
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.lightBlue[100],
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://via.placeholder.com/150'),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.username,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.refresh),
                          const Icon(Icons.more_vert),
                        ],
                      ),
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    // Contact list
                    Expanded(child: Consumer<UserServiceProvider>(
                        builder: (context, userProvider, child) {
                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return ContactItem(
                            user: users[index],
                            onTap: () async {
                              getChatroom(users[index].uid);
                              setState(() {
                                targetUserName = users[index].username;
                              });
                            },
                          );
                        },
                      );
                    })),
                  ],
                ),
              ),
            ),
            // Right side - Chat view
            onChatroom
                ? Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // Chat header
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          color: Colors.white,
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/150'),
                              ),
                              const SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(targetUserName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Chat messages
                        Expanded(
                          // dynamic listview builder
                          child: StreamBuilder(
                            stream: chatProvider.getMessageHistoryStream(
                                chatProvider.currentChatroom.chatroomID),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (messageScrollController.hasClients) {
                                  _scrollToBottom();
                                }
                              });
                              final messages =
                                  snapshot.data as List<MessageModel>;
                              return ListView.builder(
                                controller: messageScrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return ChatBubble(
                                    text: messages[index].content,
                                    isSent: messages[index].senderID ==
                                        widget.user.uid,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Message input
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: inputController,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Type your message and press enter...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              IconButton(
                                  onPressed: () async {
                                    onSendMessage();
                                  },
                                  icon:
                                      const Icon(Icons.send, color: Colors.red))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(flex: 5, child: SizedBox())
          ],
        ),
      );
    }
  }
}
