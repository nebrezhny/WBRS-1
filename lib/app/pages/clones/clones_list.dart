import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/clones/clone_edit.dart';
import 'package:wbrs/app/widgets/bottom_nav_bar.dart';
import 'package:wbrs/app/widgets/drawer.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class ClonesList extends StatefulWidget {
  const ClonesList({super.key});

  @override
  State<ClonesList> createState() => _ClonesEditState();
}

class _ClonesEditState extends State<ClonesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      drawer: MyDrawer(),
      appBar: AppBar(),
      bottomNavigationBar: MyBottomNavigationBar(),
      body: StreamBuilder(
          stream: firebaseFirestore
              .collection('users')
              .where('testing', isEqualTo: true)
              .snapshots(),
          builder: (BuildContext ctx,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return userCard(snapshot.data!.docs[index].data(),
                        snapshot.data!.docs[index].id);
                  });
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Text('No data');
              }
            }
          }),
    );
  }

  userCard(Map<String, dynamic> info, String id) {
    bool condition = info['fullName'] == 'TEST' ||
        info['about'] == 'TEST' ||
        info['hobbi'] == 'TEST';
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () async {
          info.addAll({'id': id});
          nextScreenReplace(context, CloneEdit(cloneInfo: info));
        },
        leading: SizedBox(
          width: 50,
          child: userImageWithCircle(
              info['profilePic'], info['group'], 50.0, 50.0),
        ),
        trailing: condition
            ? Icon(
                Icons.close,
                color: Colors.red,
              )
            : Icon(
                Icons.check,
                color: Colors.green,
              ),
        title: Row(
          children: [
            Text(
              info['fullName'],
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            int.parse(info['age'].toString()) % 10 == 0
                ? Text(
                    '${info['age'].toString()} лет',
                    style: const TextStyle(color: Colors.white),
                  )
                : int.parse(info['age'].toString()) % 10 == 1
                    ? Text(
                        '${info['age'].toString()} год',
                        style: const TextStyle(color: Colors.white),
                      )
                    : int.parse(info['age'].toString()) % 10 != 5
                        ? Text(
                            '${info['age']} года',
                            style: const TextStyle(color: Colors.white),
                          )
                        : Text(
                            '${info['age']} лет',
                            style: const TextStyle(color: Colors.white),
                          ),
          ],
        ),
        dense: false,
      ),
    );
  }
}
