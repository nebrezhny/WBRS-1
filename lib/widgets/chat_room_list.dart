import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/widgets/widgets.dart';

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

   _asyncFunction() async {
     await FirebaseFirestore.instance.collection('users').doc(
         widget.snapshot.get('user1')==MyUID
             ?widget.snapshot.get('user2')
             :widget.snapshot.get('user1')
     ).get().then((value) {
       otherUser = value;
     });
  }

  @override
  void initState() {
    super.initState();

    _asyncFunction();
  }

  @override
  Widget build(BuildContext context) {

    String id = '', nick = '', photoUrl = '';

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(
        widget.snapshot.get('user1')==MyUID
            ?widget.snapshot.get('user2')
            :widget.snapshot.get('user1')).get(),
      builder: (context, snapshot) {

        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else {
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
                      "${widget.snapshot.get("lastMessageSendByID") == MyUID
                          ? "Вы"
                          : widget.snapshot.get("lastMessageSendBy")}: ${widget
                          .snapshot.get("lastMessage")}",
                      maxLines: 2,
                      style: const TextStyle(

                          color: Colors.white),
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
              widget.snapshot.get("user2Nickname"),
              style: const TextStyle(color: Colors.white),
            )
                : Text(
              widget.snapshot.get("user1Nickname"),
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
                  ? userImageWithCircle(
                  widget.snapshot.get("user2_image"), snapshot.data?.get('группа'),
                  60.0, 60.0)
                  : userImageWithCircle(
                  '', snapshot.data?.get('группа'),
                  60.0, 60.0)
                  : widget.snapshot.get("user1_image") != ""
                  ? userImageWithCircle(
                  widget.snapshot.get("user1_image"), snapshot.data?.get('группа'),
                  60.0, 60.0)
                  : userImageWithCircle(
                  '', snapshot.data?.get('группа'),
                  60.0, 60.0),
            ),
            tileColor: Colors.white24,
            contentPadding: const EdgeInsets.all(10.0),
          );
        }
      }
    );
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
