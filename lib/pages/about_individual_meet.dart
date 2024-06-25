import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/pages/auth/somebody_profile.dart';
import 'package:wbrs/widgets/widgets.dart';

class AboutIndividualMeet extends StatefulWidget {
  AsyncSnapshot snapshot;
  int index;
  DocumentSnapshot doc;
  AboutIndividualMeet(
      {super.key,
      required this.snapshot,
      required this.index,
      required this.doc});

  @override
  State<AboutIndividualMeet> createState() => _AboutIndividualMeetState();
}

class _AboutIndividualMeetState extends State<AboutIndividualMeet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        title: Text(widget.snapshot.data.docs[widget.index]['name']),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              child: ListTile(
                onTap: () {
                  nextScreen(
                      context,
                      SomebodyProfile(
                          uid: widget.doc.get('uid'),
                          photoUrl: widget.doc.get('profilePic'),
                          name: widget.doc.get('fullName'),
                          userInfo: widget.doc));
                },
                title: Text(widget.doc.get('fullName')),
                leading: widget.doc.get('profilePic') != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.doc.get('profilePic'),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          'assets/profile.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                subtitle: Row(
                  children: [
                    widget.doc.get('age') % 10 == 0
                        ? Text('${widget.doc.get('age')} лет')
                        : widget.doc.get('age') % 10 == 1
                            ? Text('${widget.doc.get('age')} год')
                            : widget.doc.get('age') % 10 != 5
                                ? Text('${widget.doc.get('age')} года')
                                : Text('${widget.doc.get('age')} лет'),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("Город ${widget.doc.get('city')}")
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text('Детали встречи'),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
                "Описание: ${widget.snapshot.data.docs[widget.index]['description']}"),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Дата и время: ${widget.snapshot.data.docs[widget.index]['datetime']}'),
            const SizedBox(
              height: 10,
            ),
            Text('Город: ${widget.snapshot.data.docs[widget.index]['city']}'),
          ],
        ),
      )),
    );
  }
}
