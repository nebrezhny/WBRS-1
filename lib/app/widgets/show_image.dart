import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/pages/profile_page.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class ShowImage extends StatefulWidget {
  final int index;
  final List initList;
  final List urls;
  final AsyncSnapshot snapshot;
  const ShowImage(
      {super.key,
      required this.urls,
      required this.index,
      required this.initList,
      required this.snapshot,});

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
                  icon: const Icon(Icons.photo_camera_front_sharp)),
              IconButton(
                  onPressed: () {
                    deleteImage(widget.snapshot, widget.index);
                  },
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
    if (widget.index == widget.urls.length - 1){
      nextScreenReplace(
          context,
          ShowImage(
              index: 0,
              initList: widget.initList,
              urls: widget.urls,
              snapshot: widget.snapshot,));
    }else{
      nextScreenReplace(
          context,
          ShowImage(
              index: widget.index + 1,
              initList: widget.initList,
              urls: widget.urls,
              snapshot: widget.snapshot,));
    }
  }

  moveToPrevious() {
    if (widget.index == 0) {
      nextScreenReplace(
          context,
          ShowImage(
              index: widget.urls.length - 1,
              initList: widget.initList,
              urls: widget.urls,
              snapshot: widget.snapshot,));
    }
    else{
      nextScreenReplace(
          context,
          ShowImage(
              index: widget.index - 1,
              initList: widget.initList,
              urls: widget.urls,
              snapshot: widget.snapshot,));
    }
  }

  deleteImage(snapshot, index) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              color: darkGrey,
            ),
            height: MediaQuery.of(context).size.height * 0.17,
            child: Column(
              children: [
                const DefaultTextStyle(
                  style: TextStyle(
                      decorationColor: Colors.white,
                      fontStyle: FontStyle.normal,
                      color: Colors.white,
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
