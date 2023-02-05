import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  Stream<QuerySnapshot>? meets;
  TextEditingController city = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              title: const Text("Встречи"),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: TextField(
                              controller: city,
                              style: const TextStyle(),
                              decoration: const InputDecoration(
                                alignLabelWithHint: false,
                                border: InputBorder.none,
                                hintText: "Москва",
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                            splashRadius: 10,
                            splashColor: Colors.black,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 1000,
                        child: StreamBuilder<Object>(
                            stream: meets = FirebaseFirestore.instance
                                .collection('meets')
                                .snapshots(),
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
}

Widget kartovhkaVstrechi(
    context, AsyncSnapshot snapshot, int index, CollectionReference meets) {
  return snapshot.hasData
      ? GestureDetector(
          onTap: (() {
            nextScreen(context, const AboutMeet());
          }),
          child: Container(
            margin: const EdgeInsets.all(12),
            color: Colors.white,
            height: 70,
            width: double.infinity,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(snapshot.data.docs[index]['name']),
                  Text(snapshot.data.docs[index]['city']),
                  Text(snapshot.data.docs[index]['type']),
                ]),
          ),
        )
      : Container();
}
