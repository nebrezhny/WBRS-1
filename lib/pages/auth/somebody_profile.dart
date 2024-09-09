// ignore_for_file: must_be_immutable, unnecessary_string_escapes, non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/chatscreen.dart';
import 'package:wbrs/pages/home_page.dart';
import 'package:wbrs/pages/shop.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/widgets/widgets.dart';

import '../../widgets/bottom_nav_bar.dart';

class SomebodyProfile extends StatefulWidget {
  String uid;
  String photoUrl;
  String name;
  DocumentSnapshot userInfo;
  SomebodyProfile(
      {super.key,
      required this.uid,
      required this.photoUrl,
      required this.name,
      required this.userInfo});

  @override
  State<SomebodyProfile> createState() => _SomebodyProfileState();
}

class _SomebodyProfileState extends State<SomebodyProfile> {
  FirebaseFirestore db = FirebaseFirestore.instance;
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

    var doc = await db
        .collection('users')
        .doc(uid)
        .collection('visiters')
        .doc(myUid)
        .get();

    var MyUserInfo = await db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if(!MyUserInfo.data()!['isUnVisible']){
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
          "group": MyUserInfo.get('группа'),
          "city": MyUserInfo.get('city')
        });
      } else {
        db
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
  }

  List images = [];

  getImages() async {
    var res = await db
        .collection('users')
        .doc(widget.uid)
        .collection('images')
        .get();
    images = res.docs.map((e) => e.get('url')).toList();
    setState(() {
      images.sort(
            (a, b) {
          return a.toString().contains('avatar')
              ? -1
              : b.toString().contains('avatar')
              ? 1
              : 0;
        },
      );
    });

    print(images);
  }

  @override
  void initState() {
    upgradeUserVisiters(widget.uid);
    setState(() {
      isLoading = true;
    });
    getImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool HaveOrNot = false;

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
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        showSnackbar(context, Colors.green,
                            "Спасибо за отклик! Мы уже рассматриваем заявку.");
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info,
                            size: 30,
                            color: Colors.red,
                          ),
                          Text(
                            ' Пожаловаться',
                            style: TextStyle(color: Colors.redAccent),
                          )
                        ],
                      ),
                    ),
                  ],
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
                            GestureDetector(
                              onTap: () {
                                if(widget.userInfo
                                    .get('profilePic')!='') {
                                  int index = 0;
                                  for (var element in images) {
                                    if (element == widget.userInfo
                                        .get('profilePic')) {
                                      index = images.indexOf(element);
                                    }
                                  }
                                  openImage(index, images);
                                }
                              },
                              child: userImageWithCircle(
                                  (widget.userInfo.get('profilePic') != "")
                                      ?widget.userInfo.get('profilePic')
                                      :"", widget.userInfo.get('группа'), 100.0, 100.0),
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  String chatID = '';
                                  Map<String, dynamic> chatRoomInfoMap = {
                                    "user1": FirebaseAuth
                                        .instance.currentUser!.uid
                                        .toString(),
                                    "user2": widget.uid,
                                    "user1Nickname": FirebaseAuth
                                        .instance.currentUser!.displayName,
                                    "user2Nickname": widget.name,
                                    "user1_image": FirebaseAuth
                                        .instance.currentUser!.photoURL,
                                    "user2_image": widget.photoUrl,
                                    "lastMessage": "",
                                    "lastMessageSendBy": "",
                                    "lastMessageSendTs": DateTime.now(),
                                    "unreadMessage": 0,
                                    "chatId": getChatRoomIdByUsernames(
                                        FirebaseAuth.instance.currentUser!
                                            .displayName
                                            .toString(),
                                        widget.name)
                                  };
                                  await FirebaseFirestore.instance
                                      .collection("chats")
                                      .where("user1",
                                      isEqualTo: FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .where("user2", isEqualTo: widget.uid)
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
                                          .instance.currentUser!.uid)
                                      .where("user1", isEqualTo: widget.uid)
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
                                              FirebaseAuth.instance
                                                  .currentUser!.displayName
                                                  .toString(),
                                              widget.name),
                                          chatRoomInfoMap);
                                      DatabaseService().addChat(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          getChatRoomIdByUsernames(
                                              FirebaseAuth.instance
                                                  .currentUser!.displayName
                                                  .toString(),
                                              widget.name));
                                      DatabaseService().addChatSecondUser(
                                          widget.uid,
                                          getChatRoomIdByUsernames(
                                              FirebaseAuth.instance
                                                  .currentUser!.displayName
                                                  .toString(),
                                              widget.name));
                                      nextScreenReplace(context, const ShopPage());
                                    } else {
                                      nextScreenReplace(context, const ShopPage());
                                    }
                                  });
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.card_giftcard,
                                      size: 30,
                                      color: Colors.orangeAccent,
                                    ),
                                    Text(
                                      'Подарить подарок',
                                      style: TextStyle(color: Colors.orangeAccent),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0)),
                            images.isEmpty
                                ? const Text(
                                    "Нет фотографий",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 140,
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
                                          width: 140,
                                          child: InkWell(
                                            radius: 15,
                                              onTap: () {
                                                openImage(index, images);
                                              },
                                              child: Container(
                                                decoration:const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                                ),
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                child: CachedNetworkImage(
                                                    imageUrl: images[index],
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
                                TextButton(
                                    onPressed: () async {
                                      String chatID = '';
                                      Map<String, dynamic> chatRoomInfoMap = {
                                        "user1": FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString(),
                                        "user2": widget.uid,
                                        "user1Nickname": FirebaseAuth
                                            .instance.currentUser!.displayName,
                                        "user2Nickname": widget.name,
                                        "user1_image": FirebaseAuth
                                            .instance.currentUser!.photoURL,
                                        "user2_image": widget.photoUrl,
                                        "lastMessage": "",
                                        "lastMessageSendBy": "",
                                        "lastMessageSendTs": DateTime.now(),
                                        "unreadMessage": 0,
                                        "chatId": getChatRoomIdByUsernames(
                                            FirebaseAuth.instance.currentUser!
                                                .displayName
                                                .toString(),
                                            widget.name)
                                      };
                                      await FirebaseFirestore.instance
                                          .collection("chats")
                                          .where("user1",
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .where("user2", isEqualTo: widget.uid)
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
                                                  .instance.currentUser!.uid)
                                          .where("user1", isEqualTo: widget.uid)
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
                                                  FirebaseAuth.instance
                                                      .currentUser!.displayName
                                                      .toString(),
                                                  widget.name),
                                              chatRoomInfoMap);
                                          DatabaseService().addChat(
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              getChatRoomIdByUsernames(
                                                  FirebaseAuth.instance
                                                      .currentUser!.displayName
                                                      .toString(),
                                                  widget.name));
                                          DatabaseService().addChatSecondUser(
                                              widget.uid,
                                              getChatRoomIdByUsernames(
                                                  FirebaseAuth.instance
                                                      .currentUser!.displayName
                                                      .toString(),
                                                  widget.name));
                                          nextScreen(context, const HomePage());
                                        } else {
                                          nextScreenReplace(
                                              context,
                                              ChatScreen(
                                                chatId: chatID,
                                                chatWithUsername: widget.name,
                                                id: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                photoUrl: widget.photoUrl,
                                              ));
                                        }
                                      });
                                      setState(() {
                                        selectedIndex = 1;
                                      });
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.messenger_outline,
                                          color: Colors.orange,
                                          size: 30,
                                        ),
                                      ],
                                    ))
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
                                          fontSize: 18,

                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('age').toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('rost'),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      textAlign: TextAlign.left,
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.userInfo.get('hobbi') != ""
                                            ? widget.userInfo.get('hobbi')
                                            : "не заполнено",
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('deti')
                                          ? "есть"
                                          : "нет",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
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
                                      "Группа: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Flexible(
                                      child: Text(
                                        widget.userInfo.get('группа'),
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 17),
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
                                      "Города: ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      widget.userInfo.get('city'),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 17),
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textAlign: TextAlign.left),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 18.0)),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            widget.userInfo.get('about'),
                                            style: const TextStyle(
                                                fontSize: 17,
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
  openImage(index, urls) {
    showDialog(
      builder: (context) => AlertDialog(
        iconPadding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.8),
        iconColor: Colors.white,
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(image: CachedNetworkImageProvider(
              urls[index],
            ), fit: BoxFit.fitWidth),
          ),
          height: MediaQuery.of(context).size.height/1.5,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {
                if(index!=0){
                  Navigator.pop(context);
                  openImage(index-1, urls);
                }
              }, icon: Icon(Icons.arrow_back_ios, color: index==0?Colors.grey:Colors.white,)),
              IconButton(onPressed: () {
                if(index!=urls.length-1){
                  Navigator.pop(context);
                  openImage(index+1, urls);
                }
              }, icon: Icon(Icons.arrow_forward_ios, color: index==urls.length-1?Colors.grey:Colors.white,)),
            ],
          ),
        ),
      ),
      context: context,
    );
  }
}
