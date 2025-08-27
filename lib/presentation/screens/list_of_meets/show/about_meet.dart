// ignore_for_file: implementation_imports, must_be_immutable, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:wbrs/presentation/screens/meet_chat_screen/chat_page.dart';

class AboutMeet extends StatefulWidget {
  String id = '';
  String name = '';
  List users;
  bool is_user_join = false;
  AboutMeet(
      {super.key,
      required this.id,
      required this.users,
      required this.name,
      required this.is_user_join});

  @override
  State<AboutMeet> createState() => _AboutMeetState();
}

class _AboutMeetState extends State<AboutMeet> {
  @override
  Widget build(BuildContext context) {
    return ChatPage(
      groupId: widget.id,
      groupName: widget.name,
      users: widget.users,
      isUserJoin: widget.is_user_join,
    );
  }
}
