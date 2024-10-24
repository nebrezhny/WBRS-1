// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:cached_annotation/cached_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/auth/somebody_profile.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/app/widgets/widgets.dart';

import '../widgets/bottom_nav_bar.dart';
import 'filter_pages/filter_page.dart';

// ignore: must_be_immutable
class ProfilesList extends StatefulWidget {
  final int startPosition;
  final String group;

  const ProfilesList(
      {super.key, required this.group, required this.startPosition});

  @override
  State<ProfilesList> createState() => _ProfilesListState();
}

class _ProfilesListState extends State<ProfilesList> {
  AuthService authService = AuthService();

  String myUserName = "";
  bool checkGroup = false;

  getGroup() {
    String group = "";
    firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
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

  getUsers() async {
    QuerySnapshot doc = await firebaseFirestore
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        //.orderBy('lastOnlineTs')
        .get();
    for (int i = 0; i < doc.docs.length; i++) {
      users.add(doc.docs[i].data() as Map);
    }
    setState(() {});
  }

  FirebaseAuth auth = firebaseAuth;

  get user => auth.currentUser;

  get uid => user?.uid;

  List<Map> users = [];

  //int age = int.parse(GlobalAge.toString());

  var collection = firebaseFirestore.collection('users');

  String? pol;

  @override
  void initState() {
    super.initState();
    Group = widget.group;
    getUsers();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  onPressed: () {},
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

    if (users.isEmpty) {
      return const Center(child: Text("Пользователи не найдены"));
    } else {
      return createTable();
    }
  }

  Widget createTable() {
    List filteredUsers = [];
    print(widget.startPosition);
    print(users.length);
    int endPosition = widget.startPosition + 15 > users.length
        ? users.length - widget.startPosition
        : widget.startPosition + 15;
    if (users.isNotEmpty) {
      for (int i = widget.startPosition; i < endPosition; i++) {
        if (users[i]['age'] >= ageStart && users[i]['age'] <= ageEnd) {
          if (FiltrPol != '') {
            if (users[i]['pol'].toString().toLowerCase() == FiltrPol) {
              if (filtrCity.text != '') {
                if (users[i]['city'] == filtrCity.text) {
                  filteredUsers.add(users[i]);
                }
              } else {
                filteredUsers.add(users[i]);
              }
            }
          } else {
            if (filtrCity.text != '') {
              if (users[i]['city'] == filtrCity.text) {
                filteredUsers.add(users[i]);
              }
            } else {
              filteredUsers.add(users[i]);
            }
          }
        }
      }
    }

    return Column(
      children: [
        const FilterPage2(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.44,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: filteredUsers.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: GestureDetector(
                  onTap: () {
                    DatabaseService()
                        .getUserByUserName(filteredUsers[index]['fullName']);

                    setState(() {
                      somebodyUid = filteredUsers[index]['uid'];
                      somebodyFullname = filteredUsers[index]['fullName'];
                      somebodyImageUrl = filteredUsers[index]['profilePic'];
                    });
                    nextScreen(
                        context,
                        SomebodyProfile(
                          uid: somebodyUid.toString(),
                          name: somebodyFullname.toString(),
                          photoUrl: somebodyImageUrl.toString(),
                          userInfo: filteredUsers[index],
                        ));
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Column(children: [
                      userImageWithCircle(
                          filteredUsers[index]["profilePic"],
                          filteredUsers[index]["группа"] ?? '',
                          MediaQuery.of(context).size.height * 0.1,
                          MediaQuery.of(context).size.height * 0.1),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            "${filteredUsers[index]["fullName"]}, ${filteredUsers[index]["age"]},\n ${filteredUsers[index]["city"]}",
                            style: const TextStyle(color: Colors.white),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 5,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (users.length / 15).round(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    nextScreenReplace(
                        context,
                        ProfilesList(
                            group: widget.group, startPosition: index * 15));
                  },
                  child: CircleAvatar(
                    radius: 15,
                    child: Text(index.toString()),
                  ),
                );
              },
            ))
      ],
    );
  }
}
