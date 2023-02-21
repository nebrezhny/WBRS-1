import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/pages/meetings.dart';
import 'package:messenger/pages/profile_page.dart';
import 'package:messenger/pages/profiles_list.dart';
import 'package:messenger/widgets/widgets.dart';

import '../helper/global.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String userName = FirebaseAuth.instance.currentUser!.displayName.toString();
  void _onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        Images = doc.get('images');
        CountImages = Images.length;

        await FirebaseFirestore.instance
            .collection("users")
            .where("fullName",
                isEqualTo:
                    FirebaseAuth.instance.currentUser!.displayName.toString())
            .get()
            .then((QuerySnapshot snapshot) {
          GlobalAge = snapshot.docs[0].get("age".toString()).toString();
          GlobalAbout = snapshot.docs[0].get("about".toString()).toString();
          GlobalCity = snapshot.docs[0]["city"].toString();
          GlobalHobbi = snapshot.docs[0]["hobbi"];
          GlobalRost = snapshot.docs[0]["rost"];
          GlobalDeti = snapshot.docs[0]["deti"];
          Group = snapshot.docs[0]["группа"];
          GlobalPol = snapshot.docs[0]["пол"];
        });
        // ignore: use_build_context_synchronously
        nextScreen(
            context,
            ProfilePage(
              email: FirebaseAuth.instance.currentUser!.email.toString(),
              userName:
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
              about: GlobalAbout.toString(),
              age: GlobalAge.toString(),
              rost: GlobalRost.toString(),
              hobbi: GlobalHobbi.toString(),
              city: GlobalCity.toString(),
              deti: GlobalDeti,
              pol: GlobalPol.toString(),
            ));
        break;
      case 1:
        nextScreen(context, const HomePage());
        break;
      case 2:
        await FirebaseFirestore.instance
            .collection("users")
            .where("fullName",
                isEqualTo:
                    FirebaseAuth.instance.currentUser!.displayName.toString())
            .get()
            .then((QuerySnapshot snapshot) {
          GlobalAge = snapshot.docs[0].get("age".toString()).toString();
          GlobalAbout = snapshot.docs[0].get("about".toString()).toString();
          GlobalCity = snapshot.docs[0]["city"].toString();
          GlobalHobbi = snapshot.docs[0]["hobbi"];
          GlobalRost = snapshot.docs[0]["rost"];
          GlobalDeti = snapshot.docs[0]["deti"];
          Group = snapshot.docs[0]["группа"];
          GlobalPol = snapshot.docs[0]["пол"];
        });
        nextScreenReplace(context, ProfilesList());
        print(email + userName);

        break;
      case 3:
        nextScreen(context, const MeetingPage());
        break;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      items: const [
        Icon(
          Icons.person,
          size: 30,
        ),
        Icon(
          Icons.message_outlined,
          size: 30,
        ),
        Icon(
          Icons.people,
          size: 30,
        ),
        Icon(
          Icons.access_alarm_sharp,
          size: 30,
        ),
      ],
      index: selectedIndex,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      color: Colors.orangeAccent.shade400,
      buttonBackgroundColor: Colors.orangeAccent.shade100,
      onTap: _onItemTapped,
      height: 60,
    );
  }
}
