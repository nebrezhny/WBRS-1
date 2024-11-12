// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/pages/auth/somebody_profile.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/app/widgets/widgets.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/circle_user_image.dart';
import 'filter_pages/filter_page.dart';

class ProfilesList extends StatefulWidget {
  int startPosition;
  final String group;

  ProfilesList({super.key, required this.group, required this.startPosition});

  @override
  State<ProfilesList> createState() => _ProfilesListState();
}

class _ProfilesListState extends State<ProfilesList> {
  AuthService authService = AuthService();
  List<Map> users = [];
  bool isLoading = true;

  Stream getStream() {
    Query query = firebaseFirestore
        .collection('users')
        .where('uid', isNotEqualTo: firebaseAuth.currentUser!.uid)
        .where('age', isGreaterThanOrEqualTo: ageStart)
        .where('age', isLessThanOrEqualTo: ageEnd);
    if(filterCity.text != '') {
      query = query.where('city', isEqualTo: filterCity.text);
    }

    if(FiltrPol != '') {
      query = query.where('pol', isEqualTo: FiltrPol);
    }

    query = query.orderBy('lastOnlineTS', descending: true);
    Stream<QuerySnapshot> stream = query.snapshots();
    return stream;
  }

  Stream usersStream = const Stream.empty();

  @override
  void initState() {
    usersStream = getStream();
    Group = widget.group;
    super.initState();

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          filterQuality: FilterQuality.low,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: const MyBottomNavigationBar(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
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
          body: isLoading ? const Center(child: CircularProgressIndicator()) : _buildStreamContent(),
        )
      ],
    );
  }

  Widget _buildStreamContent() {
    return StreamBuilder(
        stream: usersStream,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == null) {
              return const Center(child: Text("Пользователи не найдены"));
            }else{
              return createTable(snapshot.data!.docs);
            }
          }
        });
  }

  Widget createTable(List snapshot) {
    int count = widget.startPosition + 15 > snapshot.length
        ? snapshot.length - widget.startPosition
        : 15;

    return Column(
      children: [
        const FilterPage2(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.42,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: count,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.3,
                key: ValueKey(snapshot[index + widget.startPosition].data()),
                child: userCard(snapshot[index + widget.startPosition].data(), context),
              );
            },
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              padding: const EdgeInsets.all(7),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 5,
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: (snapshot.length / 15).round(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.startPosition = index * 15;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: index==widget.startPosition/15? Colors.orangeAccent: Colors.orangeAccent.shade100 ,
                    radius: 15,
                    child: Text((index+1).toString()),
                  ),
                );
              },
            ))
      ],
    );
  }
}

Widget userCard(Map user, context){
  return GestureDetector(
    onTap: () {
      nextScreen(
          context,
          SomebodyProfile(
            uid: user['uid'],
            name: user['fullName'],
            photoUrl: user['profilePic'],
            userInfo: user,
          ));
    },
    child: _buildUserCardContent(user, context),
  );
}

Widget _buildUserCardContent(Map user, BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.05,
    child: Column(
      children: [
        UserImage(
          userPhotoUrl: user['profilePic'],
          uid: user['uid'],
          group: user["группа"],
          width: 70.ceilToDouble(),
          height: 70.ceilToDouble(),
        ),
        Container(
          key: Key(user['uid']),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            "${user["fullName"]}, ${user["age"]},\n ${user["city"]}",
            style: const TextStyle(color: Colors.white),
            softWrap: true,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
