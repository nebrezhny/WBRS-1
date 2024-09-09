import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/auth/somebody_profile.dart';
import 'package:wbrs/widgets/drawer.dart';
import 'package:wbrs/widgets/widgets.dart';

import '../widgets/bottom_nav_bar.dart';

class MyVisitersPage extends StatefulWidget {
  final Stream? visiters;
  const MyVisitersPage({super.key, required this.visiters});

  @override
  State<MyVisitersPage> createState() => _MyVisitersPageState();
}

class _MyVisitersPageState extends State<MyVisitersPage> {
  String MyUid = '';
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Widget visitersList(AsyncSnapshot snapshot, int index) {

      Timestamp time = snapshot.data!.docs[index]['lastVisitTs'];
      return Card(
        color: Colors.white.withOpacity(0.25),
        child: ListTile(
          onTap: () async {
            var doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.docs[index]['uid'])
                .get();

            // ignore: use_build_context_synchronously
            nextScreen(
                context,
                SomebodyProfile(
                  uid: snapshot.data!.docs[index]['uid'],
                  photoUrl: snapshot.data!.docs[index]['photoUrl'],
                  name: snapshot.data!.docs[index]['fullName'],
                  userInfo: doc,
                ));
          },
          leading: SizedBox(
            width: 50,
            child: userImageWithCircle(
                (snapshot.data!.docs[index]['photoUrl'] == "" ||
                    snapshot.data!.docs[index]['photoUrl'] == null)
                    ? "assets/profile.png"
                    : snapshot.data!.docs[index]['photoUrl'].toString(),
                snapshot.data!.docs[index]['group'], 50.0, 50.0),
          ),
          title: Row(
            children: [
              Text(
                snapshot.data!.docs[index]['fullName'],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              int.parse(snapshot.data!.docs[index]['age'].toString()) % 10 == 0
                  ? Text('${snapshot.data!.docs[index]['age'].toString()} лет',
                style: const TextStyle(color: Colors.white),)
                  : int.parse(snapshot.data!.docs[index]['age'].toString()) %
                  10 ==
                  1
                  ? Text(
                '${snapshot.data!.docs[index]['age'].toString()} год',
                style: const TextStyle(color: Colors.white),)
                  : int.parse(snapshot.data!.docs[index]['age']
                  .toString()) %
                  10 !=
                  5
                  ? Text('${snapshot.data!.docs[index]['age']} года',
                style: const TextStyle(color: Colors.white),)
                  : Text('${snapshot.data!.docs[index]['age']} лет',
                style: const TextStyle(color: Colors.white),),
            ],
          ),
          subtitle: Text(
              "Последнее посещение: \n${time.toDate().toString().substring(0, 16)}",
            style: const TextStyle(color: Colors.white),),
          dense: false,
        ),
      );
    }

    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar:
          AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Посетители страницы",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
          ),
          backgroundColor: Colors.transparent,
          drawer: const MyDrawer(),
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: widget.visiters,
                builder: (context, snapshot) {
                  var length;
                  if (snapshot.data != null) {
                    length = snapshot.data!.docs.length;
                  }
                  if (snapshot.data != null) {
                    if (length == 0) {
                      return Container(
                        height: 700,
                        padding: const EdgeInsets.all(15),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Пока на вашей странице не было гостей.",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        height: 700,
                        child: ListView.builder(
                            itemCount: length,
                            itemBuilder: (BuildContext context, index) {
                              return visitersList(snapshot, index);
                            }),
                      );
                    }
                  } else {
                    return Container(
                      height: 700,
                      padding: const EdgeInsets.all(15),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Пока на вашей странице не было гостей.",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ),
      ],
    );
  }
}
