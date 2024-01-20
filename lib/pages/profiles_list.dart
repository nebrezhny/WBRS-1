// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/helper/helper_function.dart';
import 'package:messenger/pages/auth/somebody_profile.dart';
import 'package:messenger/service/auth_service.dart';
import 'package:messenger/widgets/drawer.dart';
import 'package:messenger/service/database_service.dart';
import 'package:messenger/widgets/widgets.dart';

import '../widgets/bottom_nav_bar.dart';
import 'filter_pages/filter_page.dart';

// ignore: must_be_immutable
class ProfilesList extends StatefulWidget {
  String group;
  ProfilesList({Key? key, required this.group}) : super(key: key);

  @override
  State<ProfilesList> createState() => _ProfilesListState();
}

class _ProfilesListState extends State<ProfilesList> {
  AuthService authService = AuthService();

  String myUserName = "";

  getGroup() {
    String group = "";
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((data) {
      group = data.get('группа');
    });
    return group;
  }

  getMyInfoFromSharedPreference() async {
    //myName = await SharedPreferenceHelper().getDisplayName();
    //myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = HelperFunctions().getUserName().toString();
    //myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  get user => auth.currentUser;
  get uid => user?.uid;

  late FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  get users => firebaseFirestore.collection("users").snapshots();
  //int age = int.parse(GlobalAge.toString());

  var collection = FirebaseFirestore.instance
          .collection('users')
          .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      // .orderBy('uid')
      // .orderBy('age')
      // .startAt([int.parse(GlobalAge.toString()) - 10])
      // .endAt([int.parse(GlobalAge.toString()) + 10])
      ;

  String? pol;

  @override
  void initState() {
    super.initState();
    Group = widget.group;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          bottomNavigationBar: const MyBottomNavigationBar(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () {
                    Navigator.of(context)
                        .push(createRoute(() => const FilterPage()));
                  },
                );
              }),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              "Пользователи",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
          drawer: const MyDrawer(),
          body: SingleChildScrollView(
              child: Group == "коричнево-красная" ||
                      Group == "коричнево-синяя" ||
                      Group == "коричнево-белая"
                  ? StreamBuilder<QuerySnapshot>(
                      stream: collection
                          //.where("age", isGreaterThan: 10)
                          .where("группа", whereIn: [
                            "красно-синяя",
                            "сине-коричневая",
                            "сине-красная",
                            "сине-белая",
                            "бело-синяя",
                          ])
                          .orderBy('uid')
                          //.orderBy('age', descending: true)
                          // .orderBy('age',descending: true)
                          .snapshots() //.takeWhile((element) => element.docs[0]["age"]>=20)

                      ,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: Text("Пользователи не найдены"));
                        }
                        return createTable(snapshot);
                        // return Table(
                        //   children: [
                        //     TableRow(
                        //       //children: getExpenseItems(snapshot)
                        //       children: createTable()
                        //     )
                        //   ],
                        // );
                        //ListView(children:getExpenseItems(snapshot));
                      })
                  : Group == "красно-коричневая" ||
                          Group == "красно-синяя" ||
                          Group == "красно-белая"
                      ? StreamBuilder<QuerySnapshot>(
                          stream: collection
                              .where("группа", whereIn: <String>[
                                "красно-синяя",
                                "коричнево-синяя",
                                "бело-коричневая",
                                "бело-красная",
                                "коричнево-белая",
                                "коричнево-красная",
                                "бело-синяя"
                              ])
                              //.orderBy('age', descending: true)
                              .orderBy('uid')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: Text("Пользователи не найдены"));
                            }
                            return createTable(snapshot);
                            // return Table(
                            //   children: [
                            //     TableRow(
                            //       //children: getExpenseItems(snapshot)
                            //       children: createTable()
                            //     )
                            //   ],
                            // );
                            //ListView(children:getExpenseItems(snapshot));
                          })
                      : Group == "сине-коричневая" ||
                              Group == "сине-красная" ||
                              Group == "сине-белая"
                          ? StreamBuilder<QuerySnapshot>(
                              stream: collection
                                  .where("группа", whereIn: [
                                    "коричнево-синяя",
                                    "коричнево-красная",
                                    "коричнево-белая",
                                    "бело-синяя"
                                  ])
                                  //.orderBy('age', descending: true)
                                  .orderBy('uid')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: Text("Пользователи не найдены"));
                                }
                                return createTable(snapshot);
                                // return Table(
                                //   children: [
                                //     TableRow(
                                //       //children: getExpenseItems(snapshot)
                                //       children: createTable()
                                //     )
                                //   ],
                                // );
                                //ListView(children:getExpenseItems(snapshot));
                              })
                          : Group == "бело-коричневая" ||
                                  Group == "бело-синяя" ||
                                  Group == "бело-красная"
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: collection
                                      .where("группа", whereIn: [
                                        "красно-синяя",
                                        "бело-красная",
                                        "красно-белая"
                                      ])
                                      .orderBy('uid')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child:
                                              Text("Пользователи не найдены"));
                                    }
                                    return createTable(snapshot);
                                    // return Table(
                                    //   children: [
                                    //     TableRow(
                                    //       //children: getExpenseItems(snapshot)
                                    //       children: createTable()
                                    //     )
                                    //   ],
                                    // );
                                    //ListView(children:getExpenseItems(snapshot));
                                  })
                              : Group == "бело-синяя"
                                  ? StreamBuilder<QuerySnapshot>(
                                      stream: collection
                                          .where("группа", whereIn: [
                                            "коричнево-красная",
                                            "сине-коричневая",
                                            "коричнево-белая",
                                            "красно-синяя",
                                            "красно-коричневая",
                                            "красно-белая"
                                          ])
                                          .orderBy('age', descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child: Text(
                                                  "Пользователи не найдены"));
                                        }
                                        return createTable(snapshot);
                                        // return Table(
                                        //   children: [
                                        //     TableRow(
                                        //       //children: getExpenseItems(snapshot)
                                        //       children: createTable()
                                        //     )
                                        //   ],
                                        // );
                                        //ListView(children:getExpenseItems(snapshot));
                                      })
                                  : const Center(
                                      child: Text("Пользователи не найдены"))),
        ),
      ],
    );
  }

  Widget createTable(AsyncSnapshot<QuerySnapshot> snapshot) {
    //getMyInfoFromSharedPreference();
    List users = [];

    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      if (snapshot.data!.docs[i]['age'] >= currentValues.start.round() &&
          snapshot.data!.docs[i]['age'] <= currentValues.end.round()) {
        if (FiltrPol != '') {
          if (snapshot.data!.docs[i]['pol'].toString().toLowerCase() ==
              FiltrPol) {
            if (filtrCity.text != '') {
              if (snapshot.data!.docs[i]['city'] == filtrCity.text) {
                users.add(snapshot.data!.docs[i]);
              }
            } else {
              users.add(snapshot.data!.docs[i]);
            }
          }
        } else {
          if (filtrCity.text != '') {
            if (snapshot.data!.docs[i]['city'] == filtrCity.text) {
              users.add(snapshot.data!.docs[i]);
            }
          } else {
            users.add(snapshot.data!.docs[i]);
          }
        }
      }
    }

    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: users.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: GestureDetector(
            onTap: () async {
              DocumentSnapshot doc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(users[index].id)
                  .get();
              Images = doc.get('images');
              CountImages = Images.length;

              DatabaseService().getUserByUserName(
                  snapshot.data!.docs[index].get("fullName"));

              setState(() {
                somebodyUid = users[index].get("uid");
                somebodyFullname = users[index].get("fullName");
                somebodyImageUrl = users[index].get("profilePic");
              });
              // ignore: use_build_context_synchronously
              nextScreen(
                  context,
                  SomebodyProfile(
                    uid: somebodyUid.toString(),
                    name: somebodyFullname.toString(),
                    photoUrl: somebodyImageUrl.toString(),
                    userInfo: await FirebaseFirestore.instance
                        .collection('users')
                        .doc(users[index].get('uid'))
                        .get(),
                  ));
            },
            child: Container(
                decoration: BoxDecoration(
                  image: (users[index]["profilePic"] == "")
                      ? const DecorationImage(
                          image: AssetImage("assets/profile.png"),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(
                              users[index]["profilePic"].toString()),
                          fit: BoxFit.cover),
                ),
                child: Container(
                    constraints: BoxConstraints(minHeight: 0, maxHeight: 100),
                    color: Colors.black38,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    margin: const EdgeInsets.only(top: 100),
                    child: Text(
                      "${users[index]["fullName"]}, ${users[index]["age"]}",
                      style: const TextStyle(color: Colors.white),
                      softWrap: true,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ))),
          ),
        );
      },
    );
  }
}
