import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/pages/profile_page.dart';
import 'package:wbrs/widgets/widgets.dart';

class ShowImage extends StatefulWidget {
  final int index;
  final List initList;
  final List urls;
  final AsyncSnapshot snapshot;
  final String userName;
  final String email;
  final String about;
  final String age;
  final String rost;
  final String city;
  final String hobbi;
  final bool deti;
  final String pol;
  final String group;
  const ShowImage(
      {super.key,
      required this.urls,
      required this.index,
      required this.initList,
      required this.snapshot,
      required this.userName,
      required this.email,
      required this.about,
      required this.age,
      required this.rost,
      required this.city,
      required this.hobbi,
      required this.deti,
      required this.pol,
      required this.group});

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    firebaseFirestore
                        .collection('users')
                        .doc(firebaseAuth.currentUser!.uid)
                        .update({'profilePic': widget.urls[widget.index]});
                    firebaseAuth.currentUser!
                        .updatePhotoURL(widget.urls[widget.index]);
                  },
                  icon: const Icon(CupertinoIcons.profile_circled)),
              IconButton(
                  onPressed: () {
                    deleteImage(widget.snapshot, widget.index);
                  },
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    nextScreenReplace(
                        context,
                        ProfilePage(
                          userName: widget.userName,
                          email: widget.email,
                          about: widget.about,
                          age: widget.age,
                          rost: widget.rost,
                          city: widget.city,
                          hobbi: widget.hobbi,
                          deti: widget.deti,
                          pol: widget.pol,
                          group: widget.group,
                        ));
                  },
                  icon: const Icon(Icons.close)),
            ],
          )
        ],
      ),
      body: Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              moveToNext();
            } else {
              moveToPrevious();
            }
          },
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 2,
            panEnabled: false,
            scaleEnabled: true,
            boundaryMargin: const EdgeInsets.all(100),
            child: CachedNetworkImage(
              imageUrl: widget.urls[widget.index],
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fitWidth),
                ),
              ),
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  child: const Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  child: const Center(child: Icon(Icons.error))),
            ),
          )),
    );
  }

  moveToNext() {
    if (widget.index == widget.urls.length - 1) return;
    nextScreenReplace(
        context,
        ShowImage(
            index: widget.index + 1,
            initList: widget.initList,
            urls: widget.urls,
            snapshot: widget.snapshot,
            userName: widget.userName,
            email: widget.email,
            about: widget.about,
            age: widget.age,
            rost: widget.rost,
            city: widget.city,
            hobbi: widget.hobbi,
            deti: widget.deti,
            pol: widget.pol,
            group: widget.group));
  }

  moveToPrevious() {
    if (widget.index == 0) return;
    nextScreenReplace(
        context,
        ShowImage(
            index: widget.index - 1,
            initList: widget.initList,
            urls: widget.urls,
            snapshot: widget.snapshot,
            userName: widget.userName,
            email: widget.email,
            about: widget.about,
            age: widget.age,
            rost: widget.rost,
            city: widget.city,
            hobbi: widget.hobbi,
            deti: widget.deti,
            pol: widget.pol,
            group: widget.group));
  }

  deleteImage(snapshot, index) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.17,
            child: Column(
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                      decorationColor: Colors.white,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontSize: 16),
                  child: Text("Вы уверены, что хотите удалить это фото?"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent),
                        onPressed: () {
                          FirebaseStorage.instance
                              .refFromURL(snapshot.data!.docs[index]['url'])
                              .delete();
                          firebaseFirestore
                              .collection('users')
                              .doc(firebaseAuth.currentUser!.uid)
                              .collection('images')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                          if (index == 0) {
                            moveToNext();
                          } else {
                            moveToPrevious();
                          }
                        },
                        child: const Icon(Icons.check)),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close)),
                  ],
                )
              ],
            ),
          );
        });
  }
}
