// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/pages/about_app.dart';
import 'package:messenger/pages/auth/writing_data_user.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/pages/meetings.dart';
import 'package:messenger/pages/shop.dart';
import 'package:messenger/pages/test/kvadrat.dart';
import 'package:messenger/widgets/widgets.dart';

import '../pages/auth/login_page.dart';
import '../pages/profile_page.dart';
import '../pages/profiles_list.dart';
import '../service/auth_service.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = FirebaseAuth.instance.currentUser!.displayName.toString();
  String email = FirebaseAuth.instance.currentUser!.email.toString();

  FirebaseAuth auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;
  AuthService authService = AuthService();

  Stream? groups;
  String groupName = "";
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: double.infinity,
          width: 300,
          fit: BoxFit.cover,
        ),
        Drawer(
            backgroundColor: Colors.transparent,

            // child: ListView.builder(
            //   itemBuilder: (BuildContext context,int index){
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 50),
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedIndex = 0;
                    });
                    await FirebaseFirestore.instance
                        .collection("users")
                        .where("fullName",
                            isEqualTo: FirebaseAuth
                                .instance.currentUser!.displayName
                                .toString())
                        .get()
                        .then((QuerySnapshot snapshot) {
                      GlobalAge =
                          snapshot.docs[0].get("age".toString()).toString();
                      GlobalAbout =
                          snapshot.docs[0].get("about".toString()).toString();
                      GlobalCity = snapshot.docs[0]["city"].toString();
                      GlobalHobbi = snapshot.docs[0]["hobbi"];
                      GlobalRost = snapshot.docs[0]["rost"];
                      GlobalDeti = snapshot.docs[0]["deti"];
                      Group = snapshot.docs[0]["группа"];
                      GlobalPol = snapshot.docs[0]["пол"];
                    });
                    nextScreen(
                        context,
                        ProfilePage(
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                          userName: FirebaseAuth
                              .instance.currentUser!.displayName
                              .toString(),
                          about: GlobalAbout.toString(),
                          age: GlobalAge.toString(),
                          rost: GlobalRost.toString(),
                          hobbi: GlobalHobbi.toString(),
                          city: GlobalCity.toString(),
                          deti: GlobalDeti,
                          pol: GlobalPol.toString(),
                        ));
                  },
                  child: Column(
                    children: [
                      Column(
                        children: [
                          FirebaseAuth.instance.currentUser!.photoURL == "" ||
                                  FirebaseAuth.instance.currentUser!.photoURL ==
                                      null
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 150,
                                  color: Colors.white,
                                )
                              : Column(children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        FirebaseAuth
                                            .instance.currentUser!.photoURL
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height: 100.0,
                                        width: 100.0,
                                      )),
                                ]),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            userName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  height: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.question_answer,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    "Пройти тест",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    //nextScreenReplace(context, const AboutUserWriting());
                    nextScreen(context, AboutUserWriting());
                  },
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                    nextScreenReplace(context, const HomePage());
                    //   setState(() {
                    //     _selectedIndex=index;
                    //   });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.messenger_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    "Чаты",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    setState(() {
                      selectedIndex = 0;
                      print(selectedIndex);
                    });
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get();
                    Images = doc.get('images');
                    CountImages = Images.length;

                    await FirebaseFirestore.instance
                        .collection("users")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      GlobalAge =
                          snapshot.docs[0].get("age".toString()).toString();
                      GlobalAbout =
                          snapshot.docs[0].get("about".toString()).toString();
                      GlobalCity = snapshot.docs[0]["city"].toString();
                      GlobalHobbi = snapshot.docs[0]["hobbi"];
                      GlobalRost = snapshot.docs[0]["rost"];
                      GlobalDeti = snapshot.docs[0]["deti"];
                      Group = snapshot.docs[0]["группа"];
                      GlobalPol = snapshot.docs[0]["пол"];
                    });

                    nextScreen(
                        context,
                        ProfilePage(
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                          userName: FirebaseAuth
                              .instance.currentUser!.displayName
                              .toString(),
                          about: GlobalAbout.toString(),
                          age: GlobalAge.toString(),
                          rost: GlobalRost.toString(),
                          hobbi: GlobalHobbi.toString(),
                          city: GlobalCity.toString(),
                          deti: GlobalDeti,
                          pol: GlobalPol.toString(),
                        ));
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    "Профиль",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    setState(() {
                      selectedIndex = 2;
                    });
                    await FirebaseFirestore.instance
                        .collection("users")
                        .where("fullName", isEqualTo: userName)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      GlobalAge =
                          snapshot.docs[0].get("age".toString()).toString();
                      GlobalAbout =
                          snapshot.docs[0].get("about".toString()).toString();
                      GlobalPol = snapshot.docs[0]["пол"].toString();
                      Group = snapshot.docs[0]["группа"];
                    });
                    nextScreenReplace(context, ProfilesList());
                    print(email + userName);
                  },
                  leading: const Icon(
                    Icons.people,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  title: const Text(
                    "Список пользователей",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(context, MyApp());
                  },
                  title: const Text("Магазин",
                      style: TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.shopping_basket,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(context, const MeetingPage());
                  },
                  title: const Text("Встречи",
                      style: TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.person_pin_circle,
                    color: Colors.grey,
                    size: 30,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                ListTile(
                  onTap: () {
                    nextScreenReplace(context, const About_App());
                  },
                  title: const Text("О приложении",
                      style: TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.info,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                ListTile(
                  onTap: () async {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Выйти"),
                            content: const Text("Вы уверены что хотите выйти?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    "Выйти",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
            //   }
            // )
            ),
      ],
    );
  }
}
