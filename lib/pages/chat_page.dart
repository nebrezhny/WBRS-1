// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/auth/somebody_profile.dart';
import 'package:wbrs/pages/meetings.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/service/notifications.dart';
import 'package:wbrs/widgets/message_tile.dart';
import 'package:wbrs/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_meet.dart';

class UserInfo {
  String name;
  String age;
  String city;
  String image_url;
  String group;
  String uid;
  DocumentSnapshot userInfo;

  UserInfo(this.name, this.age, this.city, this.image_url, this.group, this.uid,
      this.userInfo);
}

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final List users;
  final bool is_user_join;
  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.users,
      required this.is_user_join});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  Stream? users_in_meet;
  List userWOutN = [];

  TextEditingController messageController = TextEditingController();
  bool isMeAdmin = false;

  List<UserInfo> user_info = [];
  bool is_user_join = false;
  bool isMeKicked = false;
  late DocumentSnapshot meet;
  bool isNotificationOff = false;
  Map meetInfo = {};

  isMeAdminCheck() async {
    String myId = firebaseAuth.currentUser!.uid;
    meetInfo = meet.data() as Map;
    setState(() {
      isMeAdmin = meetInfo['admin'] == myId;
      if (meetInfo.containsKey('kicked')) {
        isMeKicked = meetInfo['kicked'].contains(myId);
      }
    });
  }

  getMeet() async {
    meet =
        await firebaseFirestore.collection('meets').doc(widget.groupId).get();
    isMeAdminCheck();
  }

  checkNotification() async {
    isNotificationOff = userWOutN.contains(firebaseAuth.currentUser!.uid);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMeet();
    getUsers();
    is_user_join = widget.is_user_join;

    getAndSetMessages();

    getToken();
  }

  getToken() async {
    firebaseMessaging.getNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    addNotification() async {
      List users = widget.users;
      users.removeWhere((element) => element == firebaseAuth.currentUser!.uid);
      Map notification = {
        'isChat': false,
        'chatId': widget.groupId,
        'groupName': widget.groupName,
        'users': widget.users,
        'isUserJoin': widget.is_user_join,
        'message': messageController.text,
      };
      String token = "";

      for (int i = 0; i < users.length; i++) {
        if (userWOutN.contains(users[i])) return;
        var doc =
            await firebaseFirestore.collection('TOKENS').doc(users[i]).get();
        token = doc.get('token');
        NotificationsService().sendPushMessageGroup(
            token, notification, widget.groupName, 1, widget.groupId);
      }
    }

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: []),
          child: Image.asset(
            "assets/fon.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            toolbarTextStyle: const TextStyle(color: Colors.black),
            title: Text(widget.groupName),
            actions: [
              is_user_join
                  ? IconButton(
                      onPressed: () {
                        List users = widget.users;
                        users.remove(firebaseAuth.currentUser!.uid);
                        firebaseFirestore
                            .collection('meets')
                            .doc(widget.groupId)
                            .update({'users': users});
                        nextScreen(context, const MeetingPage());
                      },
                      icon: const Icon(Icons.output_sharp))
                  : const SizedBox(),
              IconButton(
                  onPressed: () {
                    switchNotification();
                  },
                  icon: isNotificationOff
                      ? const Icon(Icons.notifications_on_outlined)
                      : const Icon(Icons.notifications_off_outlined)),
              isMeAdmin
                  ? IconButton(
                      onPressed: () {
                        nextScreen(context, EditMeet(meet: meet));
                      },
                      icon: const Icon(Icons.edit_calendar_outlined))
                  : const SizedBox(),
              is_user_join
                  ? IconButton(
                      onPressed: () async {
                        for (int i = 0; i < widget.users.length; i++) {
                          DocumentSnapshot doc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(widget.users[i])
                              .get();
                          try {
                            UserInfo some_user_info = UserInfo(
                                doc.get('fullName'),
                                doc.get('age').toString(),
                                doc.get('city'),
                                doc.get('profilePic'),
                                doc.get('группа'),
                                doc.get('uid'),
                                doc);
                            user_info.add(some_user_info);
                          } on Exception catch (e) {
                            showSnackbar(context, Colors.red, e);
                          }
                        }
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (ctx, StateSetter setState) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration:
                                          const BoxDecoration(boxShadow: []),
                                      child: Image.asset(
                                        "assets/fon.jpg",
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        scale: 0.6,
                                      ),
                                    ),
                                    Scaffold(
                                      backgroundColor: Colors.transparent,
                                      appBar: AppBar(
                                        backgroundColor: Colors.orangeAccent,
                                        title:
                                            const Text('Список пользователей'),
                                      ),
                                      body: Column(
                                        children: [
                                          Container(
                                            height: 330,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 15),
                                            child: listUsers(ctx, setState),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                getOutFromChat();
                                              },
                                              child: const Text(
                                                'Выйти из встречи',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                            });
                      },
                      icon: const Icon(Icons.people))
                  : const SizedBox()
            ],
            backgroundColor: Colors.orangeAccent,
          ),
          body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              nextScreenReplace(context, const MeetingPage());
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(boxShadow: []),
                  child: Image.asset(
                    "assets/fon.jpg",
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    scale: 0.6,
                  ),
                ),
                chatMessages(),
                const Padding(padding: EdgeInsets.only(bottom: 50.0)),

                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            )),
                            GestureDetector(
                              onTap: () {
                                addNotification();
                                sendMessage();
                              },
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            )
                          ])
                        : isMeKicked
                            ? Expanded(
                                child: TextFormField(
                                controller: messageController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Вы были исключены из встречи",
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ))
                            : Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: messageController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText:
                                          "Вы не являетесь участником встречи",
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  )),
                                  TextButton(
                                      onPressed: () {
                                        joinUser(firebaseAuth.currentUser!.uid,
                                            widget.groupId);
                                        setState(() {
                                          is_user_join = true;
                                        });
                                        messageController.text =
                                            "${firebaseAuth.currentUser!.displayName} присоединился ко встрече";
                                        addNotification();
                                        getAndSetMessages();
                                        messageController.text = "";
                                      },
                                      child: const Text(
                                        'Присоедениться',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ))
                                ],
                              ),
                  ),
                )
                // chat messages here
              ],
            ),
          ),
        ),
      ],
    );
  }

  switchNotification() async {
    String myUID = firebaseAuth.currentUser!.uid;
    setState(() {
      if (isNotificationOff) {
        userWOutN.remove(myUID);
      } else {
        userWOutN.add(myUID);
      }
    });

    await firebaseFirestore
        .collection('meets')
        .doc(widget.groupId)
        .update({'usersWithoutNotification': userWOutN});
    checkNotification();
  }

  getOutFromChat() async {
    var chat = firebaseFirestore.collection('meets').doc(widget.groupId);

    String myId = firebaseAuth.currentUser!.uid;

    var chatDoc = await chat.get();
    List users = chatDoc.get('users');
    users.remove(myId);

    chat.update({'users': users});

    var messages = await chat.collection('messages').get();

    for (var element in messages.docs) {
      firebaseFirestore
          .collection('users')
          .doc(myId)
          .collection('removed_meets')
          .doc(widget.groupId)
          .collection('messages')
          .doc(element.id)
          .set(element.data());
    }

    nextScreenReplace(context, const MeetingPage());
  }

  getAndSetMessages() async {
    if (is_user_join) {
      chats = await DatabaseService().getGroupMessages(widget.groupId);
    } else {
      chats = firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('removed_meets')
          .doc(widget.groupId)
          .collection('messages')
          .orderBy('time')
          .snapshots();
    }
    setState(() {});
  }

  getUsers() async {
    DocumentReference meet =
        firebaseFirestore.collection('meets').doc(widget.groupId);
    users_in_meet = meet.snapshots();
    DocumentSnapshot data = await meet.get();
    Map mapData = data.data() as Map;
    userWOutN = mapData['usersWithoutNotification'] ?? [];
    checkNotification();
    setState(() {});
  }

  getUserInfo(String id) async {}

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
                    chatId: widget.groupId,
                    message: snapshot.data.docs[index],
                    sender: snapshot.data.docs[index]['sender'],
                    name: snapshot.data.docs[index]['name'],
                    sentByMe: firebaseAuth.currentUser!.uid ==
                        snapshot.data.docs[index]['sender'],
                    isRead: true,
                    avatar: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data.docs[index]['avatar'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )),
                    isChat: false,
                  );
                },
              )
            : Container();
      },
    );
  }

  listUsers(context, StateSetter setState) {
    List users = widget.users;
    return StreamBuilder(
        stream: users_in_meet,
        builder: (context, AsyncSnapshot snapshot) {
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white60,
                  child: ListTile(
                    onTap: () async {
                      UserInfo user = user_info[index];
                      nextScreen(
                          context,
                          SomebodyProfile(
                              uid: user.uid,
                              photoUrl: user.image_url,
                              name: user.name,
                              userInfo: user.userInfo));
                    },
                    trailing: isMeAdmin &&
                            users[index] != firebaseAuth.currentUser!.uid
                        ? IconButton(
                            onPressed: () async {
                              var doc = await firebaseFirestore
                                  .collection('meets')
                                  .doc(widget.groupId)
                                  .get()
                                  .then((doc) => doc.data());
                              setState(() {
                                List kicked = doc?['kicked'] ?? [];
                                kicked.add(users[index]);
                                users.removeAt(index);
                                user_info.removeAt(index);
                                firebaseFirestore
                                    .collection('meets')
                                    .doc(widget.groupId)
                                    .update({'users': users, 'kicked': kicked});
                              });
                            },
                            icon: const Icon(Icons.delete))
                        : null,
                    title: Text(user_info[index].name),
                    subtitle: Row(
                      children: [
                        int.parse(user_info[index].age) % 10 == 0
                            ? Text('${user_info[index].age} лет')
                            : int.parse(user_info[index].age) % 10 == 1
                                ? Text('${user_info[index].age} год')
                                : int.parse(user_info[index].age) % 10 != 5
                                    ? Text('${user_info[index].age} года')
                                    : Text('${user_info[index].age} лет'),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "Город ${user_info[index].city}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
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
                              child: userImageWithCircle(
                                  user_info[index].image_url,
                                  user_info[index].group,
                                  60.0,
                                  60.0))),
                    ),
                    dense: false,
                  ),
                );
              });
        });
  }

  sendMessage() async {
    DocumentSnapshot doc = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    String name = doc.get('fullName');
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": firebaseAuth.currentUser!.uid,
        "avatar": firebaseAuth.currentUser!.photoURL,
        "group": doc.get('группа'),
        'name': name,
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

  joinUser(String uid, String groupID) {
    widget.users.add(uid);
    firebaseFirestore
        .collection('meets')
        .doc(groupID)
        .update({'users': widget.users});
  }
}
