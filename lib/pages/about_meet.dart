import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:messenger/pages/chat_page.dart';
import 'package:messenger/pages/chatscreen.dart';

class AboutMeet extends StatefulWidget {
  const AboutMeet({super.key});

  @override
  State<AboutMeet> createState() => _AboutMeetState();
}

class _AboutMeetState extends State<AboutMeet> {
  @override
  Widget build(BuildContext context) {
    return const ChatPage(
      groupId: "dOcW2BqsRL4u9OLW5YDO",
      groupName: "Some",
      email: "some",
    );
  }
}
