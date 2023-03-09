// ignore_for_file: must_be_immutable, unnecessary_string_escapes, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/pages/chatscreen.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/service/database_service.dart';
import 'package:messenger/widgets/widgets.dart';

import '../../widgets/bottom_nav_bar.dart';

class SomebodyProfile extends StatefulWidget {
  String uid;
  String photoUrl;
  String name;
  DocumentSnapshot userInfo;
  SomebodyProfile(
      {Key? key,
      required this.uid,
      required this.photoUrl,
      required this.name,
      required this.userInfo})
      : super(key: key);

  @override
  State<SomebodyProfile> createState() => _SomebodyProfileState();
}

class _SomebodyProfileState extends State<SomebodyProfile> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  bool isLoading = true;
  getChatRoomIdByUsernames(String a, String b) {
    if (a.isNotEmpty && b.isNotEmpty) {
      if (a.substring(0, 1).codeUnitAt(0) <= b.substring(0, 1).codeUnitAt(0)) {
        return "$a\_$b";
      } else {
        return "$b\_$a";
      }
    } else {
      return "abrakadabra";
    }
  }

  upgradeUserVisiters(String uid) async {
    setState(() {
      isLoading = false;
    });
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('visiters')
        .doc(myUid)
        .get();

    var MyUserInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!doc.exists) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('visiters')
          .doc(myUid)
          .set({
        "uid": myUid,
        "photoUrl": FirebaseAuth.instance.currentUser!.photoURL,
        "lastVisitTs": DateTime.now(),
        "fullName": FirebaseAuth.instance.currentUser!.displayName,
        "age": MyUserInfo.get('age'),
        "city": MyUserInfo.get('city')
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('visiters')
          .doc(myUid)
          .update({
        "photoUrl": FirebaseAuth.instance.currentUser!.photoURL,
        "lastVisitTs": DateTime.now(),
        "fullName": FirebaseAuth.instance.currentUser!.displayName,
        "age": MyUserInfo.get('age'),
        "city": MyUserInfo.get('city')
      });
    }
  }

  List images = [];

  getUserInfo() async {
    images = widget.userInfo.get('images');
  }

  @override
  void initState() {
    super.initState();

    getUserInfo();
    upgradeUserVisiters(widget.uid);
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool HaveOrNot = false;

    // Future NicknameOfUid(String uid) async {
    //   dynamic nickname;
    //   await FirebaseFirestore.instance.collection("users").doc(uid).get().then((doc) {
    //     nickname=doc['fullName'];
    //     photoUrl=doc['profilePic'];
    //
    //   });
    //   nickName=nickname;
    //   return nickname;
    //
    // }

    BuildSomebodyProfile() {
      return Stack(
        children: [
          Image.asset(
            "assets/fon.jpg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            bottomNavigationBar: const MyBottomNavigationBar(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Text(
                  widget.name,
                  style: const TextStyle(color: Colors.white),
                )),
            body: isLoading
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 17),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (widget.photoUrl == "")
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.asset(
                                      "assets/profile.png",
                                      fit: BoxFit.cover,
                                      height: 150.0,
                                      width: 150.0,
                                    ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: Image.network(
                                      widget.photoUrl.toString(),
                                      fit: BoxFit.cover,
                                      height: 150.0,
                                      width: 150.0,
                                    )),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            images.isEmpty
                                ? const Text(
                                    "Нет фотографий",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext BuildContext,
                                          int index) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  bottomLeft:
                                                      Radius.circular(15))),
                                          height: 300,
                                          child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    insetPadding:
                                                        const EdgeInsets.all(2),
                                                    title: Container(
                                                      decoration:
                                                          const BoxDecoration(),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Image.network(
                                                        widget.userInfo.get(
                                                            'images')[index],
                                                      ),
                                                    ),
                                                  ),
                                                  context: context,
                                                );
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                width: 100,
                                                child: Image.network(
                                                    widget.userInfo
                                                        .get('images')[index],
                                                    fit: BoxFit.cover),
                                              )),
                                        );
                                      },
                                      itemCount: images.length,
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          String chatID = '';
                                          Map<String, dynamic> chatRoomInfoMap =
                                              {
                                            "user1": FirebaseAuth
                                                .instance.currentUser!.uid
                                                .toString(),
                                            "user2": widget.uid,
                                            "user1Nickname": FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .displayName,
                                            "user2Nickname": widget.name,
                                            "user1_image": FirebaseAuth
                                                .instance.currentUser!.photoURL,
                                            "user2_image": widget.photoUrl,
                                            "lastMessage": "",
                                            "unreadMessage": 0,
                                            "chatId": getChatRoomIdByUsernames(
                                                FirebaseAuth.instance
                                                    .currentUser!.displayName
                                                    .toString(),
                                                widget.name)
                                          };
                                          // await FirebaseFirestore.instance.collection("chats").where("chatId", isEqualTo: getChatRoomIdByUsernames(FirebaseAuth.instance.currentUser!.displayName.toString(), fullName))==null
                                          // ?DatabaseService().createChatRoom(getChatRoomIdByUsernames(FirebaseAuth.instance.currentUser!.displayName.toString(), fullName),chatRoomInfoMap)
                                          // :nextScreen(context, HomePage());
                                          await FirebaseFirestore.instance
                                              .collection("chats")
                                              .where("user1",
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where("user2",
                                                  isEqualTo: widget.uid)
                                              .get()
                                              .then((QuerySnapshot snapshot) {
                                            if (snapshot.docs.isEmpty) {
                                            } else {
                                              HaveOrNot = true;
                                              chatID = snapshot.docs[0].id;
                                            }
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("chats")
                                              .where("user2",
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .where("user1",
                                                  isEqualTo: widget.uid)
                                              .get()
                                              .then((QuerySnapshot snapshot) {
                                            if (snapshot.docs.isEmpty) {
                                            } else {
                                              HaveOrNot = true;
                                              chatID = snapshot.docs[0].id;
                                            }
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("chats")
                                              .where("chatId",
                                                  isEqualTo:
                                                      getChatRoomIdByUsernames(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .displayName
                                                              .toString(),
                                                          widget.name))
                                              .get()
                                              .then((QuerySnapshot snapshot) {
                                            if (snapshot.docs.isEmpty) {
                                            } else {
                                              HaveOrNot = true;
                                            }
                                            if (HaveOrNot == false) {
                                              DatabaseService().createChatRoom(
                                                  getChatRoomIdByUsernames(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .displayName
                                                          .toString(),
                                                      widget.name),
                                                  chatRoomInfoMap);
                                              DatabaseService().addChat(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  getChatRoomIdByUsernames(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .displayName
                                                          .toString(),
                                                      widget.name));
                                              DatabaseService()
                                                  .addChatSecondUser(
                                                      widget.uid,
                                                      getChatRoomIdByUsernames(
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .displayName
                                                              .toString(),
                                                          widget.name));
                                              nextScreen(
                                                  context, const HomePage());
                                            } else {
                                              nextScreenReplace(
                                                  context,
                                                  ChatScreen(
                                                    chatId: chatID,
                                                    chatWithUsername:
                                                        widget.name,
                                                    id: FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    name: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .displayName
                                                        .toString(),
                                                    photoUrl: widget.photoUrl,
                                                  ));
                                            }
                                          });
                                          setState(() {
                                            selectedIndex = 1;
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.messenger_outline,
                                          color: Colors.orange,
                                          size: 35,
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        showSnackbar(context, Colors.green,
                                            "Спасибо за отклик! Мы уже рассматриваем заявку.");
                                      },
                                      icon: const Icon(
                                        Icons.info,
                                        size: 35,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Возраст: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('age').toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 21),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Рост: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('rost'),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 21),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Хобби: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.userInfo.get('hobbi') != ""
                                            ? widget.userInfo.get('hobbi')
                                            : "не заполнено",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 21),
                                        softWrap: true,
                                        maxLines: 10,
                                        overflow: TextOverflow.fade,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Дети: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('deti')
                                          ? "есть"
                                          : "нет",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 21),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("О себе",
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textAlign: TextAlign.left),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 20.0)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            widget.userInfo.get('about'),
                                            style: const TextStyle(
                                                fontSize: 21,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator.adaptive(),
          ),
        ],
      );
    }

    return BuildSomebodyProfile();

    //);
  }
}
