// ignore_for_file: implementation_imports, must_be_immutable, non_constant_identifier_names

import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger/pages/chat_page.dart';

class AboutMeet extends StatefulWidget {
  String id = '';
  String name = '';
  List users;
  bool is_user_join = false;
  AboutMeet(
      {Key? key,
      required this.id,
      required this.users,
      required this.name,
      required this.is_user_join})
      : super(key: key);

  @override
  State<AboutMeet> createState() => _AboutMeetState();
}

class _AboutMeetState extends State<AboutMeet> {
  @override
  Widget build(BuildContext context) {
    return ChatPage(
      groupId: widget.id,
      groupName: widget.name,
      email: "some",
      users: widget.users,
      is_user_join: widget.is_user_join,
    );
  }
}
