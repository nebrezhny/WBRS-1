import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/pages/profiles_list.dart';
import 'package:wbrs/widgets/widgets.dart';

import '../helper/global.dart';
import '../helper/helper_function.dart';
import '../pages/chatscreen.dart';

class ChatRoomList extends StatefulWidget {
  final QueryDocumentSnapshot snapshot;
  ChatRoomList({super.key, required this.snapshot});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {

  List chats = [];
  var MyUID = FirebaseAuth.instance.currentUser!.uid;
  late DocumentSnapshot otherUser;

  Future<void> _asyncFunction() async {
    otherUser = await FirebaseFirestore.instance.collection('users').doc(
        widget.snapshot.get('user1')==MyUID
        ?widget.snapshot.get('user2')
        :widget.snapshot.get('user1')
    ).get();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _asyncFunction();
    });
  }

  @override
  Widget build(BuildContext context) {

    String id = '', nick = '', photoUrl = '';

    if (chats.isNotEmpty) {
      return ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)),
        subtitle: widget.snapshot.get("lastMessage") != ""
            ? Container(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${widget.snapshot.get("lastMessageSendByID") == MyUID ? "Вы" : widget.snapshot.get("lastMessageSendBy")}: ${widget.snapshot.get("lastMessage")}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              widget.snapshot.get("lastMessageSendByID") != MyUID
                  ? widget.snapshot.get("unreadMessage") != null
                  ? widget.snapshot.get("unreadMessage") != 0
                  ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: Text(
                  widget.snapshot.get("unreadMessage")
                      .toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      fontFamily: 'Roboto'),
                ),
              )
                  : const SizedBox()
                  : const SizedBox()
                  : const SizedBox(),
            ],
          ),
        )
            : const Text(
          "нет сообщений",
          style: TextStyle(color: Colors.white),
        ),
        title: widget.snapshot.get("user1") == MyUID
            ? Text(
          widget.snapshot.get("lastMessageSendByID").get("user2Nickname"),
          style: const TextStyle(color: Colors.white),
        )
            : Text(
          widget.snapshot.get("lastMessageSendByID").get("user1Nickname"),
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () async {
          if (widget.snapshot.get("user1") == MyUID) {
            nick = widget.snapshot.get("user2Nickname");
            id = widget.snapshot.get("user2");

            photoUrl = widget.snapshot.get("user2_image");
          } else {
            nick = widget.snapshot.get("user1Nickname");
            id = widget.snapshot.get("user1");
            photoUrl = widget.snapshot.get("user1_image");
          }

          setState(() {
            nextScreen(
                context,
                ChatScreen(
                    chatWithUsername: nick,
                    photoUrl: photoUrl,
                    id: id,
                    chatId: widget.snapshot.id));
          });
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: widget.snapshot.get("user1") == MyUID
              ? widget.snapshot.get("user2_image") != ""
              ? makeImageGroup(widget.snapshot.get("user2_image"), id)
              : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, size: 40))
              : widget.snapshot.get("user1_image") != ""
              ? Image.network(
            widget.snapshot.get("user1_image"),
            width: 60,
            height: 100,
            fit: BoxFit.cover,
          )
              : Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.person, size: 40)),
        ),
        tileColor: Colors.white24,
        contentPadding: const EdgeInsets.all(10.0),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height - 160,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SizedBox(
            height: 100,
            child: Column(
              children: [
                const Text(
                  'Нет чатов. ',
                  style: TextStyle(color: Colors.white),
                ),
                Flexible(
                  child: TextButton(
                    onPressed: () async {
                      selectedIndex = 2;
                      var x = await getUserGroup();
                      nextScreen(
                          context,
                          ProfilesList(
                            group: x,
                          ));
                    },
                    child: const Text(
                      'Начать общаться',
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  getGroup (id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      return value.get('группа');
    });
  }

  makeImageGroup(photoUrl, id) {
    return FutureBuilder(future: getGroup(id), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
        print(snapshot.data.toString());
        return userImageWithCircle(
            photoUrl,
            snapshot.data,
            58.0, 58.0
        );
      }else {
        print(snapshot.data);
        return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.person, size: 40));
      }
    });
  }

}
