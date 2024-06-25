// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/about_app.dart';
import 'package:wbrs/pages/admin_panel.dart';
import 'package:wbrs/pages/auth/writing_data_user.dart';
import 'package:wbrs/pages/home_page.dart';
import 'package:wbrs/pages/meetings.dart';
import 'package:wbrs/pages/shop.dart';
import 'package:wbrs/pages/test/red_group.dart';
import 'package:wbrs/pages/visiters.dart';
import 'package:wbrs/widgets/splash.dart';
import 'package:wbrs/widgets/widgets.dart';

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
  var userName;
  var email;
  var currentUser;

  FirebaseAuth auth = FirebaseAuth.instance;
  get uid => auth.currentUser!.uid;
  AuthService authService = AuthService();

  Stream? groups;
  String groupName = "";
  var displayName;

  @override
  void initState() {
    super.initState();
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      displayName = currentUser.displayName;
    }

    FirebaseFirestore.instance
        .collection("users")
        .where("fullName", isEqualTo: displayName)
        .get()
        .then((QuerySnapshot snapshot) {
      setState(() {
        GlobalAge = snapshot.docs[0].get("age".toString()).toString();
        GlobalAbout = snapshot.docs[0].get("about".toString()).toString();
        GlobalCity = snapshot.docs[0]["city"].toString();
        GlobalHobbi = snapshot.docs[0]["hobbi"];
        GlobalRost = snapshot.docs[0]["rost"];
        GlobalDeti = snapshot.docs[0]["deti"];
        Group = snapshot.docs[0]["группа"];
      });
    });
    print(Group);

    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userName = FirebaseAuth.instance.currentUser!.displayName.toString();
      email = FirebaseAuth.instance.currentUser!.email.toString();
    }
  }

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
                    var x = await getUserGroup();

                    var doc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();

                    nextScreen(
                        context,
                        ProfilePage(
                          group: x,
                          email: FirebaseAuth.instance.currentUser!.email
                              .toString(),
                          userName: FirebaseAuth
                              .instance.currentUser!.displayName
                              .toString(),
                          about: doc.get('about'),
                          age: doc.get('age').toString(),
                          rost: doc.get('rost'),
                          hobbi: doc.get('hobbi'),
                          city: doc.get('city'),
                          deti: doc.get('deti'),
                          pol: doc.get('pol'),
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
                              : userImageWithCircle(
                              (FirebaseAuth.instance.currentUser!.photoURL == "" ||
                                  FirebaseAuth.instance.currentUser!.photoURL == null)
                                  ? "assets/profile.png"
                                  : FirebaseAuth.instance.currentUser!.photoURL.toString(), Group),
                          // : ClipRRect(
                          //     borderRadius: BorderRadius.circular(100.0),
                          //     child: Image.network(
                          //       FirebaseAuth.instance.currentUser!.photoURL
                          //           .toString(),
                          //       fit: BoxFit.cover,
                          //       height: 100.0,
                          //       width: 100.0,
                          //     )),
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
                    nextScreen(context, const FirstGroupRed());
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
                    bool isLoading = true;
                    setState(() {
                      selectedIndex = 0;
                      isLoading = true;
                    });
                    nextScreen(context, SplashScreen());
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .get();
                    Images = doc.get('images');
                    CountImages = Images.length;
                    setState(() {
                      isLoading = false;
                    });

                    if (isLoading) {
                      nextScreen(context, SplashScreen());
                    } else {
                      var x = await getUserGroup();

                      var doc = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get();

                      nextScreen(
                          context,
                          ProfilePage(
                            group: x,
                            email: FirebaseAuth.instance.currentUser!.email
                                .toString(),
                            userName: FirebaseAuth
                                .instance.currentUser!.displayName
                                .toString(),
                            about: doc.get('about'),
                            age: doc.get('age').toString(),
                            rost: doc.get('rost'),
                            hobbi: doc.get('hobbi'),
                            city: doc.get('city'),
                            deti: doc.get('deti'),
                            pol: doc.get('pol'),
                          ));
                    }
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
                  onTap: () {
                    var visiters = FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('visiters')
                        .snapshots();
                    nextScreen(
                        context,
                        MyVisitersPage(
                          visiters: visiters,
                        ));
                  },
                  title: const Text("Гости",
                      style: TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.transfer_within_a_station,
                    color: Colors.grey,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                ListTile(
                  onTap: () async {
                    bool isLoading = true;
                    setState(() {
                      selectedIndex = 2;
                    });
                    nextScreen(context, SplashScreen());

                    setState(() {
                      isLoading = false;
                    });
                    if (isLoading) {
                      nextScreen(context, SplashScreen());
                    } else {
                      var x = await getUserGroup();
                      nextScreenReplace(
                          context,
                          ProfilesList(
                            group: x,
                          ));
                    }
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
                    nextScreenReplace(context, const ShopPage());
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
                    setState(() {
                      selectedIndex = 3;
                    });
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
                  onTap: () {
                    nextScreenReplace(context, const AdminPanelPage());
                  },
                  title: const Text("Админ панель",
                      style: TextStyle(color: Colors.white)),
                  leading: const Icon(
                    Icons.admin_panel_settings_outlined,
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
