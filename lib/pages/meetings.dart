import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/pages/about_meet.dart';
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
    meets = FirebaseFirestore.instance.collection('meets').snapshots();
  }

  Stream<QuerySnapshot>? meets;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('meets');
  TextEditingController name_meet = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date_and_time = TextEditingController();

  late int kolvo_users;

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
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: Scaffold(
                                appBar: AppBar(
                                  title: const Text("Создание новой встречи"),
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                body: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: name_meet,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  'Введите название встречи',
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5)),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextField(
                                          controller: city,
                                          decoration: const InputDecoration(
                                              hintText: 'Введите город встречи',
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5)),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        TextField(
                                          maxLength: 30,
                                          controller: description,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  'Введите краткое описание встречи',
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          enableInteractiveSelection: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9.:/ ]')),
                                          ],
                                          controller: date_and_time,
                                          keyboardType: TextInputType.datetime,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  'Введите дату и время встречи',
                                              border: InputBorder.none,
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 5)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              if (name_meet.text == '') {
                                                showSnackbar(
                                                    context,
                                                    Colors.red,
                                                    'Введите название!');
                                              }
                                              if (city.text == '') {
                                                showSnackbar(
                                                    context,
                                                    Colors.red,
                                                    'Введите город!');
                                              } else {
                                                collectionReference.add({
                                                  'name': name_meet.text,
                                                  'city': city.text,
                                                  'description':
                                                      description.text,
                                                  'datetime':
                                                      date_and_time.text,
                                                  'admin': FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  'users': [
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                  ],
                                                  'type': "группа",
                                                  'recentMessage': '',
                                                  'recentMessageSender': '',
                                                });
                                                Navigator.pop(context);
                                              }

                                              setState(() {
                                                name_meet.clear();
                                                city.clear();
                                                description.clear();
                                                date_and_time.clear();
                                              });
                                            },
                                            child: const Text(
                                              "Сохранить",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.orangeAccent),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
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
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: SingleChildScrollView(
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
                                if (city == '') {
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
                              print(city.text);
                            },
                            icon: const Icon(Icons.search),
                            iconSize: 25,
                            splashRadius: 1,
                            splashColor: Colors.black,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 1000,
                        child: StreamBuilder<Object>(
                            stream: meets,
                            builder: (context, AsyncSnapshot snapshot) {
                              return snapshot.hasData
                                  ? ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return kartovhkaVstrechi(
                                            context,
                                            snapshot,
                                            index,
                                            FirebaseFirestore.instance
                                                .collection('meets'));
                                      })
                                  : Container();
                            }))
                  ],
                ),
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

  Widget kartovhkaVstrechi(
      context, AsyncSnapshot snapshot, int index, CollectionReference meets) {
    return snapshot.hasData
        ? Container(
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
                nextScreen(
                    context,
                    AboutMeet(
                      id: snapshot.data.docs[index].id,
                      users: users,
                      name: snapshot.data.docs[index]['name'],
                      is_user_join: is_user_join,
                    ));
              }),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Colors.white),
                margin: const EdgeInsets.all(12),
                height: 70,
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
                    Text(snapshot.data.docs[index]['datetime']),
                  ]),
                  subtitle: Row(children: [
                    Text(
                        snapshot.data.docs[index]['recentMessageSender'] + ':'),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(snapshot.data.docs[index]['recentMessage']),
                  ]),
                ),
              ),
            ),
          )
        : Container();
  }
}
