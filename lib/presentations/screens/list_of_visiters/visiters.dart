// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/presentations/screens/list_of_users/show/somebody_profile.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/app/widgets/widgets.dart';

import '../../../app/widgets/bottom_nav_bar.dart';

class MyVisitersPage extends StatefulWidget {
  final Stream? visiters;
  const MyVisitersPage({super.key, required this.visiters});

  @override
  State<MyVisitersPage> createState() => _MyVisitersPageState();
}

class _MyVisitersPageState extends State<MyVisitersPage> {
  var currentUser = firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context) {
    Widget visitersList(AsyncSnapshot snapshot, int index) {
      Timestamp time = snapshot.data!.docs[index]['lastVisitTs'];
      Map visitor = snapshot.data!.docs[index].data() as Map;
      return Card(
        color: grey,
        child: ListTile(
          onTap: () async {
            var doc = await firebaseFirestore
                .collection('users')
                .doc(snapshot.data!.docs[index]['uid'])
                .get();
            if(doc.exists){
              nextScreen(
                  context,
                  SomebodyProfile(
                    uid: snapshot.data!.docs[index]['uid'],
                    photoUrl: snapshot.data!.docs[index]['photoUrl'],
                    name: snapshot.data!.docs[index]['fullName'],
                    userInfo: doc.data() as Map,
                  ));
            } else{
              showSnackbar(context, Colors.red, 'Пользователь был удален');
            }
          },
          leading: SizedBox(
            width: 50,
            child: userImageWithCircle(visitor['photoUrl'],
                visitor['group'],
                visitor.containsKey('online') ? visitor['online'] : false,
                50.0, 50.0),
          ),
          title: Row(
            children: [
              Text(
                visitor['fullName'],
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              int.parse(visitor['age'].toString()) % 10 == 0
                  ? Text(
                      '${visitor['age'].toString()} лет',
                      style: const TextStyle(color: Colors.white),
                    )
                  : int.parse(visitor['age'].toString()) %
                              10 ==
                          1
                      ? Text(
                          '${visitor['age'].toString()} год',
                          style: const TextStyle(color: Colors.white),
                        )
                      : int.parse(visitor['age']
                                      .toString()) %
                                  10 !=
                              5
                          ? Text(
                              '${visitor['age']} года',
                              style: const TextStyle(color: Colors.white),
                            )
                          : Text(
                              '${visitor['age']} лет',
                              style: const TextStyle(color: Colors.white),
                            ),
            ],
          ),
          subtitle: Text(
            'Последнее посещение: \n${time.toDate().toString().substring(0, 16)}',
            style: const TextStyle(color: Colors.white),
          ),
          dense: false,
        ),
      );
    }

    return Stack(
      children: [
        Image.asset(
          'assets/fon.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Посетители страницы',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 27),
            ),
          ),
          backgroundColor: Colors.transparent,
          drawer: const MyDrawer(),
          bottomNavigationBar: const MyBottomNavigationBar(),
          body: StreamBuilder(
              stream: widget.visiters,
              builder: (context, snapshot) {
                int length = 0;
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
                          'Пока на вашей странице не было гостей.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      height: MediaQuery.of(context).size.height * 0.9,
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
                        'Пока на вашей странице не было гостей.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
}
