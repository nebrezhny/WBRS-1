import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/service/database_service.dart';
import 'package:messenger/widgets/message_tile.dart';
import 'package:messenger/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInfo {
  String name;
  String age;
  String city;
  String image_url;

  UserInfo(this.name, this.age, this.city, this.image_url);
}

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String email;
  final List users;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.email,
      required this.users})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  Stream? users_in_meet;

  TextEditingController messageController = TextEditingController();
  String admin = "";

  List<UserInfo> user_info = [];

  @override
  void initState() {
    super.initState();
    getAndSetMessages();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarTextStyle: const TextStyle(color: Colors.black),
        title: Text(widget.groupName),
        actions: [
          IconButton(
              onPressed: () async {
                for (int i = 0; i < widget.users.length; i++) {
                  DocumentSnapshot doc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.users[i])
                      .get();
                  try {
                    UserInfo some_user_info = UserInfo(
                        doc.get('fullName'),
                        doc.get('age').toString(),
                        doc.get('city'),
                        doc.get('profilePic'));
                    user_info.add(some_user_info);
                  } on Exception catch (e) {
                    showSnackbar(context, Colors.red, e);
                  }
                }
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.orangeAccent,
                          title: const Text('Список пользователей'),
                        ),
                        body: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: listUsers(),
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.people))
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: Stack(
        children: [
          chatMessages(),
          const Padding(padding: EdgeInsets.only(bottom: 50.0)),

          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Отправить сообщение...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ]),
            ),
          )
          // chat messages here
        ],
      ),
    );
  }

  getAndSetMessages() async {
    chats = await DatabaseService().getGroupMessages(widget.groupId);
    setState(() {});
  }

  getUsers() async {
    users_in_meet = await FirebaseFirestore.instance
        .collection('meets')
        .doc(widget.groupId)
        .snapshots();
    setState(() {});
  }

  getUserInfo(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe:
                          widget.email == snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  listUsers() {
    return StreamBuilder(
        stream: users_in_meet,
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Center(child: Text(user_info[index].age)),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user_info[index].name),
                      ],
                    ),
                    trailing: Text(user_info[index].city),
                    dense: false,
                  ),
                );
              });
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.email,
        "time": DateTime.now(),
      };

      DatabaseService().sendMessageGroup(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  Future<bool> onBackPress() {
    return Future.value(false);
  }
}
