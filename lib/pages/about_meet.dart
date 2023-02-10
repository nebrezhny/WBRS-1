import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger/pages/chat_page.dart';
import 'package:messenger/pages/chatscreen.dart';

class AboutMeet extends StatefulWidget {
  String id='';
  String name='';
  List users;
  AboutMeet({Key?key, required this.id, required this.users, required this.name}):super(key:key);

  @override
  State<AboutMeet> createState() => _AboutMeetState();
}

class _AboutMeetState extends State<AboutMeet> {
  @override
  Widget build(BuildContext context)  {

    return ChatPage(
      groupId: widget.id,
      groupName: widget.name,
      email: "some",
      users: widget.users,
    );
  }
}
