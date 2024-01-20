// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/pages/about_individual_meet.dart';
import 'package:messenger/pages/about_meet.dart';
import 'package:messenger/pages/create_meet.dart';
import 'package:messenger/widgets/bottom_nav_bar.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:messenger/widgets/widgets.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage({super.key});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  @override
  void initState() {
    super.initState();
    meets = FirebaseFirestore.instance.collection('meets').snapshots();
  }

  TextEditingController city = TextEditingController();

  Stream<QuerySnapshot>? meets;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('meets');

  late int kolvo_users;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.green,
              )
            ]),
            child: Image.asset(
              "assets/fon.jpg",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              scale: 0.6,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                    onPressed: () {
                      nextScreen(context, const CreateMeetPage());
                    },
                    icon: const Icon(Icons.add))
              ],
              title: const Text("Встречи"),
              backgroundColor: Colors.transparent,
            ),
            bottomNavigationBar: const MyBottomNavigationBar(),
            drawer: const MyDrawer(),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.011),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 295,
                          child: TextField(
                            controller: city,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                              alignLabelWithHint: false,
                              border: InputBorder.none,
                              hintText: "Введите ваш город",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (city.text == '') {
                                meets = FirebaseFirestore.instance
                                    .collection('meets')
                                    .snapshots();
                              } else {
                                meets = FirebaseFirestore.instance
                                    .collection('meets')
                                    .where('city', isEqualTo: city.text)
                                    .snapshots();
                              }
                            });
                          },
                          icon: const Icon(Icons.search),
                          iconSize: 25,
                          splashRadius: 1,
                          splashColor: Colors.black,
                        )
                      ],
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: meets,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          return snapshot.hasData
                              ? Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return kartovhkaGroupVstrechi(
                                            context,
                                            snapshot,
                                            index,
                                            FirebaseFirestore.instance
                                                .collection('meets'));
                                      }),
                                )
                              : const Center(child: Text('Встреч нет'));
                        } else {
                          return Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.all(20),
                            child: const CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> GetUsers(String id) async {
    var kolvo_users2 = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('users')
        .snapshots()
        .length;
    return kolvo_users2;
  }

  Widget kartovhkaGroupVstrechi(
      context, AsyncSnapshot snapshot, int index, CollectionReference meets) {
    return snapshot.hasData
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(18))),
            child: GestureDetector(
              onTap: (() async {
                DocumentSnapshot doc = await FirebaseFirestore.instance
                    .collection('meets')
                    .doc(snapshot.data.docs[index].id)
                    .get();
                List users = doc.get('users');

                bool is_user_join = false;

                for (int i = 0; i < users.length; i++) {
                  if (users[i] == FirebaseAuth.instance.currentUser!.uid) {
                    is_user_join = true;
                  }
                }
                var doc12 = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data.docs[index]['admin'])
                    .get();
                if (snapshot.data.docs[index]['type'] == 'групповая') {
                  nextScreen(
                      context,
                      AboutMeet(
                        id: snapshot.data.docs[index].id,
                        users: users,
                        name: snapshot.data.docs[index]['name'],
                        is_user_join: is_user_join,
                      ));
                } else {
                  nextScreen(
                      context,
                      AboutIndividualMeet(
                        snapshot: snapshot,
                        index: index,
                        doc: doc12,
                      ));
                }
              }),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.white),
                width: double.infinity,
                child: ListTile(
                  title: Row(children: [
                    Text(snapshot.data.docs[index]['name']),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(snapshot.data.docs[index]['city']),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child: Text(snapshot.data.docs[index]['datetime'])),
                  ]),
                  subtitle: Row(children: [
                    Text(
                        snapshot.data.docs[index]['recentMessageSender'] + ':'),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                        child:
                            Text(snapshot.data.docs[index]['recentMessage'])),
                  ]),
                ),
              ),
            ),
          )
        : Container();
  }
}
