// ignore_for_file: library_private_types_in_public_api, unnecessary_string_escapes, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/pages/auth/somebody_profile.dart';
import 'package:wbrs/pages/shop.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/service/notifications.dart';
import 'package:wbrs/widgets/message_tile.dart';
import 'package:wbrs/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithUsername, photoUrl, id, chatId;
  const ChatScreen(
      {Key? key,
      required this.chatWithUsername,
      required this.photoUrl,
      required this.id,
      required this.chatId})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String messageId = "";
  Stream? messageStream;
  late String myName, myProfilePic, myUserName, myEmail;
  String? _image;
  TextEditingController messageTextEdittingController = TextEditingController();
  String group = '';

  getMyInfoFromSharedPreference() async {
    myName = HelperFunctions().getDisplayName().toString();
    myProfilePic = HelperFunctions().getUserProfileUrl().toString();
    myUserName = HelperFunctions().getUserName().toString();
    myEmail = HelperFunctions().getUserEmail().toString();

    group = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .get()
        .then((value) {
      return value.get('группа');
    });

    print(group);
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addMessage(bool sendClicked, String type) async {
    if (messageTextEdittingController.text != "") {
      QuerySnapshot querySnap = await FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isEqualTo: widget.chatWithUsername)
          .get();
      String chatWith = querySnap.docs[0]['chatWithId'];
      bool isUserInChat = chatWith == FirebaseAuth.instance.currentUser!.uid;

      isUserInChat
          ? null
          : DatabaseService().updateUnreadMessageCount(widget.chatId);
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "type": type,
        "message": type == "text" ? message : _image,
        "sendBy": FirebaseAuth.instance.currentUser!.displayName,
        "sendByID": FirebaseAuth.instance.currentUser!.uid,
        "ts": lastMessageTs,
        "imgUrl": FirebaseAuth.instance.currentUser!.photoURL,
        "isRead": isUserInChat ? true : false
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }
      DatabaseService()
          .addMessage(widget.chatId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": FirebaseAuth.instance.currentUser!.displayName,
          "lastMessageSendByID": FirebaseAuth.instance.currentUser!.uid,
        };

        DatabaseService()
            .updateLastMessageSend(widget.chatId, lastMessageInfoMap);

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('TOKENS')
          .doc(widget.id)
          .get();
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.id)
          .get();
      String token = doc.get('token');
      String name = snap.get('fullName');

      !isUserInChat
          ? NotificationsService().sendPushMessage(token, message, name, 4,
              FirebaseAuth.instance.currentUser!.photoURL, widget.chatId)
          : null;
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, bool isRead) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(24),
                  bottomRight: sendByMe
                      ? const Radius.circular(0)
                      : const Radius.circular(24),
                  topRight: const Radius.circular(24),
                  bottomLeft: sendByMe
                      ? const Radius.circular(24)
                      : const Radius.circular(0),
                ),
                color: sendByMe ? Colors.orange : Colors.blue.shade400,
              ),
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: sendByMe ? 0 : 24,
                  right: sendByMe ? 24 : 0),
              child: Container(
                constraints:
                    BoxConstraints(minWidth: 50, maxWidth: size.width / 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      maxLines: 100,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data.docs.length != 0
                ? Column(
                    children: [
                      const Text(
                        'Самый простой способ начать общение - это',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                          onPressed: () {
                            nextScreen(context, const ShopPage());
                          },
                          child: const Text(
                            'Подарок',
                            style: TextStyle(color: Colors.green),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.74,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 0, top: 16),
                            itemCount: snapshot.data.docs.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              ds.id;
                              if (ds["sendByID"] !=
                                  FirebaseAuth.instance.currentUser!.uid) {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.chatId)
                                    .collection('chats')
                                    .doc(ds.id)
                                    .update({'isRead': true});
                              }

                              if (ds["message"] == null) {
                                return MessageTile(
                                    chatId: widget.chatId,
                                    sender: ds["sendBy"],
                                    name: ds["sendBy"],
                                    message: ds,
                                    sentByMe: FirebaseAuth
                                            .instance.currentUser!.uid ==
                                        ds["sendByID"],
                                    isRead: ds["isRead"]);
                              } else {
                                var x = ds.data().toString().contains('deleteFor');
                                if (x) {
                                  if(ds["deleteFor"] != FirebaseAuth.instance.currentUser!.uid) {
                                    return MessageTile(
                                        chatId: widget.chatId,
                                        sender: ds["sendBy"],
                                        name: ds["sendBy"],
                                        message: ds,
                                        sentByMe: FirebaseAuth
                                            .instance.currentUser!.uid ==
                                            ds["sendByID"],
                                        isRead: ds["isRead"]);
                                  }else{
                                    return const SizedBox.shrink();
                                  }
                                }
                                else{
                                  return MessageTile(
                                      chatId: widget.chatId,
                                      sender: ds["sendBy"],
                                      name: ds["sendBy"],
                                      message: ds,
                                      sentByMe: FirebaseAuth
                                          .instance.currentUser!.uid ==
                                          ds["sendByID"],
                                      isRead: ds["isRead"]);
                                }
                              }
                            }),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        const Text(
                          'Самый простой способ начать общение - это',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              nextScreen(context, const ShopPage());
                            },
                            child: const Text(
                              'Подарок',
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    ),
                  )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseService().getChatRoomMessages(widget.chatId);
    setState(() {});
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  chatWith_Update(String id) async {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .update({'chatWithId': id});
    DocumentSnapshot chat = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .get();

    var chatSnapshot =
        FirebaseFirestore.instance.collection('chats').doc(widget.chatId);

    String lastMessageSendBy = chat.get('lastMessageSendBy');

    if (lastMessageSendBy != FirebaseAuth.instance.currentUser!.displayName) {
      chatSnapshot.update({
        'unreadMessage': 0,
      });
    }
  }

  Future<bool> outOfChat() async {
    String myId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .update({'chatWithId': ''});

    return true;
  }

  @override
  void initState() {
    doThisOnLaunch();
    chatWith_Update(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon2.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        WillPopScope(
          onWillPop: () {
            return outOfChat();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: FloatingActionButton(
                            onPressed: () async {
                              DocumentSnapshot doc = await FirebaseFirestore
                                  .instance
                                  .collection('users')
                                  .doc(widget.id)
                                  .get();
                              Images = doc.get('images');
                              CountImages = Images.length;
                              nextScreen(
                                  context,
                                  SomebodyProfile(
                                    uid: widget.id,
                                    photoUrl: widget.photoUrl,
                                    name: widget.chatWithUsername,
                                    userInfo: await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.id)
                                        .get(),
                                  ));
                            },
                            child:
                            userImageWithCircle(widget.photoUrl, group, 58.0, 58.0),
                            ),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(widget.chatWithUsername, style: const TextStyle(color: Colors.white)),
                ],
              ),
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.905,
                      child: chatMessages()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container(
                        //   margin: EdgeInsets.symmetric(horizontal: 10),
                        //   height: 70,
                        //   width: 70,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.white, width: 1),
                        //   ),
                        //   child: Stack(
                        //
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Image.asset('assets/fon2.jpg'),
                        //       Align(
                        //         child: Transform.translate(
                        //             offset: Offset(-10, -10),
                        //             child: IconButton(onPressed: (){}, icon: const Icon(Icons.cancel_outlined), color: Colors.white)),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: Container(
                            color: Colors.black.withOpacity(0.8),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextField(
                                  controller: messageTextEdittingController,
                                  onChanged: (value) {},
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "type a message",
                                      hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6))),
                                )),
                                GestureDetector(
                                  onTap: () {
                                    addMessage(true, 'text');
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: messageTextEdittingController.text != "" ? Colors.white : Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  uploadFile(String filePath) async {
    File file = File(filePath);
    var storage = FirebaseStorage.instance;
    String ref = '${widget.id}/${DateTime.now().toString()}.jpg';
    try {
      await storage
          .ref(ref)
          .putFile(file);
    } on FirebaseException catch (e) {}

    String downloadUrl = await storage
        .ref(ref)
        .getDownloadURL();
    return downloadUrl;
  }
}
