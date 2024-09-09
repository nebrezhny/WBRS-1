// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/auth/somebody_profile.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/widgets/drawer.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/widgets/widgets.dart';

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
  bool checkGroup = false;

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

  var collection = FirebaseFirestore.instance.collection('users')
      // .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: const MyBottomNavigationBar(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              Builder(builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () {
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
            child: checkGroup ? usersList() : usersList(),
          ),
        )
      ],
    );
  }

  Widget usersList() {
    var filtered_col;
    switch (Group) {
      case "коричнево-красная" ||
            "коричнево-синяя" ||
            "коричневая" ||
            "коричнево-белая":
        filtered_col = collection.where("группа", whereIn: [
          "коричнево-красная",
          "коричнево-синяя",
          "коричневая",
          "коричнево-белая",
          "бело-коричневая",
          "бело-красная",
          "бело-синяя",
          "белая",
          "сине-белая"
        ]);
        break;

      case "красно-синяя" || "красно-белая" || "красная":
        filtered_col = collection.where("группа", whereIn: [
          "синяя",
          "сине-коричневая",
        ]);
        break;

      case "красно-коричневая":
        filtered_col = collection.where("группа", whereIn: [
          "коричнево-белая",
          "сине-белая",
          "бело-коричневая",
          "бело-красная",
          "бело-синяя",
          "белая",
        ]);
        break;

      case "коричнево-белая":
        filtered_col = collection.where("группа", whereIn: [
          "коричнево-красная",
          "коричнево-синяя",
          "коричневая",
          "коричнево-белая",
          "бело-коричневая",
          "бело-красная",
          "бело-синяя",
          "белая",
          "сине-белая",
          "красно-коричневая",
        ]);
        break;

      case "синяя" || "сине-коричневая":
        filtered_col = collection.where("группа", whereIn: [
          "красная",
          "красно-белая",
          "сине-красная",
          "красно-синяя",
        ]);
        break;

      case "сине-белая":
        filtered_col = collection.where("группа", whereIn: [
          "коричнево-красная",
          "коричнево-синяя",
          "коричневая",
          "коричнево-белая",
          "бело-коричневая",
          "бело-красная",
          "бело-синяя",
          "белая",
          "красно-коричневая",
        ]);
        break;

      case "сине-красная":
        filtered_col = collection.where("группа", whereIn: [
          "синяя",
          "сине-коричневая",
        ]);
        break;

      case "бело-красная" || "бело-синяя" || "белая" || "бело-коричневая":
        filtered_col = collection.where("группа", whereIn: [
          "коричнево-красная",
          "коричнево-синяя",
          "коричневая",
          "коричнево-белая",
          "сине-белая",
          "красно-коричневая",
        ]);
        break;

      default:
        filtered_col = collection;
        break;
    }

    var stream = filterByGroup
        ? filtered_col
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('uid')
            .snapshots()
        : collection
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .orderBy('uid')
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: stream, //.takeWhile((element) => element.docs[0]["age"]>=20)
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Пользователи не найдены"));
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
        });
  }

  Widget createTable(AsyncSnapshot<QuerySnapshot> snapshot) {
    //getMyInfoFromSharedPreference();
    List users = [];

    for (int i = 0; i < snapshot.data!.docs.length; i++) {
      if (snapshot.data!.docs[i]['age'] >= ageStart &&
          snapshot.data!.docs[i]['age'] <= ageEnd) {
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

    return Column(
      children: [
        const FilterPage2(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: GridView.builder(
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
                    DatabaseService().getUserByUserName(
                        snapshot.data!.docs[index].get("fullName"));

                    setState(() {
                      somebodyUid = users[index].get("uid");
                      somebodyFullname = users[index].get("fullName");
                      somebodyImageUrl = users[index].get("profilePic");
                    });
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
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Column(children: [
                      userImageWithCircle(
                        users[index]["profilePic"],
                        users[index]["группа"] ?? '',
                          MediaQuery.of(context).size.height * 0.1,MediaQuery.of(context).size.height * 0.1
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "${users[index]["fullName"]}, ${users[index]["age"]},\n ${users[index]["city"]}",
                            style: const TextStyle(color: Colors.white),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          )),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
