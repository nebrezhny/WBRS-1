// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/pages/meetings.dart';
import 'package:messenger/pages/profile_page.dart';
import 'package:messenger/pages/profiles_list.dart';
import 'package:messenger/widgets/splash.dart';
import 'package:messenger/widgets/widgets.dart';

import '../helper/global.dart';
import '../helper/helper_function.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String email = currentUser.email;
      String userName = currentUser.displayName;
    }
  }

  var currentUser;

  var email;
  var userName;
  void _onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        bool isLoading = true;
        nextScreen(context, SplashScreen());
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        Images = doc.get('images');
        CountImages = Images.length;

        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .where("fullName",
        //         isEqualTo:
        //             FirebaseAuth.instance.currentUser!.displayName.toString())
        //     .get()
        //     .then((QuerySnapshot snapshot) {
        //   GlobalAge = snapshot.docs[0].get("age".toString()).toString();
        //   GlobalAbout = snapshot.docs[0].get("about".toString()).toString();
        //   GlobalCity = snapshot.docs[0]["city"].toString();
        //   GlobalHobbi = snapshot.docs[0]["hobbi"];
        //   GlobalRost = snapshot.docs[0]["rost"];
        //   GlobalDeti = snapshot.docs[0]["deti"];
        //   Group = snapshot.docs[0]["группа"];
        //   GlobalPol = snapshot.docs[0]["пол"];
        // });
        setState(() {
          isLoading = false;
        });

        if (isLoading == false) {
          var x = await getUserGroup();

          var doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          print(doc.get('about'));

          nextScreen(
              context,
              ProfilePage(
                group: x,
                email: FirebaseAuth.instance.currentUser!.email.toString(),
                userName:
                    FirebaseAuth.instance.currentUser!.displayName.toString(),
                about: doc.get('about'),
                age: doc.get('age').toString(),
                rost: doc.get('rost'),
                hobbi: doc.get('hobbi'),
                city: doc.get('city'),
                deti: doc.get('deti'),
                pol: doc.get('pol'),
                imageSnapshot: getImagesUserStream(),
              ));
        } else {
          nextScreen(context, SplashScreen());
        }
        // ignore: use_build_context_synchronously

        break;
      case 1:
        nextScreen(context, const HomePage());
        break;
      case 2:
        bool isLoading = true;
        nextScreen(context, SplashScreen());
        // await FirebaseFirestore.instance
        //     .collection("users")
        //     .where("fullName",
        //         isEqualTo: FirebaseAuth.instance.currentUser!.displayName)
        //     .get()
        //     .then((QuerySnapshot snapshot) {
        //   GlobalAge = snapshot.docs[0].get("age".toString()).toString();
        //   GlobalAbout = snapshot.docs[0].get("about".toString()).toString();
        //   GlobalCity = snapshot.docs[0]["city"].toString();
        //   GlobalHobbi = snapshot.docs[0]["hobbi"];
        //   GlobalRost = snapshot.docs[0]["rost"];
        //   GlobalDeti = snapshot.docs[0]["deti"];
        //   Group = snapshot.docs[0]["группа"];
        //   GlobalPol = snapshot.docs[0]["пол"];
        // });
        setState(() {
          isLoading = false;
        });

        if (isLoading) {
          nextScreen(context, SplashScreen());
          // ignore: dead_code
        } else {
          var x = await getUserGroup();
          nextScreen(
              context,
              ProfilesList(
                group: x,
              ));
        }

        break;
      case 3:
        nextScreen(context, const MeetingPage());
        break;
    }
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

  getImagesUserStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('images')
        .snapshots();
  }
}
