// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:messenger/service/database_service.dart';
import 'package:messenger/widgets/message_tile.dart';
import 'package:messenger/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../service/notifications.dart';

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
  final bool is_user_join;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.email,
      required this.users,
      required this.is_user_join})
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
  bool is_user_join = false;

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    getAndSetMessages();
    getUsers();
    is_user_join = widget.is_user_join;

    getToken();
  }

  getToken() async {
    final token = await firebaseMessaging.getInitialMessage();
    print(token);

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    firebaseMessaging.getNotificationSettings();

    print(settings.authorizationStatus);
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
              child: is_user_join
                  ? Row(children: [
                      Expanded(
                          child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Отправить сообщение...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
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
                    ])
                  : Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          controller: messageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Вы не являетесь участником встречи",
                            hintStyle:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )),
                        TextButton(
                            onPressed: () {
                              joinUser(FirebaseAuth.instance.currentUser!.uid,
                                  widget.groupId);
                              setState(() {
                                is_user_join = true;
                              });
                            },
                            child: const Text('Присоедениться'))
                      ],
                    ),
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
                      name: snapshot.data.docs[index]['name'],
                      sentByMe: FirebaseAuth.instance.currentUser!.email ==
                          snapshot.data.docs[index]['sender']);
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
                    onTap: () => nextScreen(context, const MainScreen()),
                    title: Text(user_info[index].name),
                    subtitle: Row(
                      children: [
                        int.parse(user_info[index].age) % 10 == 0
                            ? Text(user_info[index].age + ' лет')
                            : int.parse(user_info[index].age) % 10 == 1
                                ? Text(user_info[index].age + ' год')
                                : int.parse(user_info[index].age) % 10 != 5
                                    ? Text(user_info[index].age + ' года')
                                    : Text(user_info[index].age + ' лет'),
                        const SizedBox(
                          width: 20,
                        ),
                        Text("Город " + user_info[index].city)
                      ],
                    ),
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: user_info[index].image_url == ''
                                ? Image.asset('assets/profile.png')
                                : Image.network(
                                    user_info[index].image_url,
                                    fit: BoxFit.cover,
                                  ),
                          )),
                    ),
                    dense: false,
                  ),
                );
              });
        });
  }

  sendMessage() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String name = doc.get('fullName');
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": FirebaseAuth.instance.currentUser!.email,
        'name': name,
        "time": DateTime.now(),
      };

      DatabaseService().sendMessageGroup(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('ChatList Got a message whilst in the foreground!');
      print('ChatList Message data: ${message.data}');
    });
  }

  Future<bool> onBackPress() {
    return Future.value(false);
  }

  joinUser(String uid, String groupID) {
    widget.users.add(uid);
    FirebaseFirestore.instance
        .collection('meets')
        .doc(groupID)
        .update({'users': widget.users});
  }
}
