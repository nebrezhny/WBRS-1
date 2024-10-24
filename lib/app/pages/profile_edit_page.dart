// ignore_for_file: must_be_immutable, library_private_types_in_public_api, empty_catches, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/auth/login_page.dart';
import 'package:wbrs/app/pages/profile_page.dart';
import 'package:wbrs/service/auth_service.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/widgets/widgets.dart';
import 'package:wbrs/app/helper/global.dart' as global;

import '../helper/global.dart';
import '../widgets/bottom_nav_bar.dart';
import 'filter_pages/cities.dart';

class ProfilePageEdit extends StatefulWidget {
  String userName;
  String email;
  String about;
  String age;
  String rost;
  String city;
  String hobbi;
  bool deti;
  ProfilePageEdit({
    super.key,
    required this.email,
    required this.userName,
    required this.about,
    required this.age,
    required this.deti,
    required this.rost,
    required this.city,
    required this.hobbi,
  });

  @override
  _ProfilePageEditState createState() => _ProfilePageEditState();
}

class _ProfilePageEditState extends State<ProfilePageEdit> {
  String? dropdownValue;
  FirebaseStorage storage = FirebaseStorage.instance;
  String imageUrl = " ";
  String chatIdThis = "";
  XFile? _image;
  TextEditingController? name = TextEditingController();
  TextEditingController? age = TextEditingController();
  TextEditingController? email = TextEditingController();
  TextEditingController? about = TextEditingController();
  TextEditingController? hobbi = TextEditingController();
  TextEditingController? city = TextEditingController();
  String? deti;
  late User? user = firebaseAuth.currentUser;
  FirebaseFirestore db = firebaseFirestore;

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilepic${firebaseAuth.currentUser?.uid}.jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    about!.text = widget.about;
    hobbi!.text = widget.hobbi;
    city!.text = widget.city;
  }

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    TextTheme tema =
        GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme);

    return Stack(
      children: [
        Image.asset(
          "assets/fon.jpg",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        MaterialApp(
          theme: ThemeData(textTheme: tema),
          home: Scaffold(
            bottomNavigationBar: const MyBottomNavigationBar(),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  onPressed: () async {
                    var x = await getUserGroup();
                    nextScreenReplace(
                        context,
                        ProfilePage(
                          group: x,
                          email: widget.email,
                          userName: widget.userName,
                          about: widget.about,
                          age: widget.age,
                          hobbi: widget.hobbi,
                          deti: widget.deti,
                          city: widget.city,
                          rost: widget.rost,
                          pol: GlobalPol.toString(),
                        ));
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  )),
              title: const Text(
                "Редактирование профиля",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/fon.jpg"),
                        fit: BoxFit.fitHeight)),
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          (_image == null)
                              ? (firebaseAuth.currentUser!.photoURL == "" ||
                                      FirebaseAuth
                                              .instance.currentUser!.photoURL ==
                                          null)
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.asset(
                                        "assets/profile.png",
                                        fit: BoxFit.cover,
                                        height: 100.0,
                                        width: 100.0,
                                      ))
                                  : ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        FirebaseAuth
                                            .instance.currentUser!.photoURL
                                            .toString(),
                                        fit: BoxFit.cover,
                                        height: 150.0,
                                        width: 150.0,
                                      ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    width: 150.0,
                                  )),
                          Positioned(
                            bottom: 0,
                            right: 4,
                            child: ClipOval(
                              child: Container(
                                color: Colors.orange,
                                width: 50,
                                height: 50,
                                child: IconButton(
                                  onPressed: () async {
                                    XFile? image = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);

                                    setState(() {
                                      _image = image;
                                    });

                                    if (_image != null) {
                                      FirebaseStorage storage =
                                          FirebaseStorage.instance;
                                      String ref =
                                          '${firebaseAuth.currentUser!.uid}/avatar-${firebaseAuth.currentUser!.displayName}-${DateTime.now()}';
                                      try {
                                        await storage
                                            .ref(ref)
                                            .putFile(File(_image!.path));
                                      } on FirebaseException {}
                                      var downloadUrl = await storage
                                          .ref(ref)
                                          .getDownloadURL();
                                      await firebaseAuth.currentUser!
                                          .updatePhotoURL(
                                              downloadUrl.toString());
                                      await db
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'profilePic': downloadUrl,
                                      }).then((value) => print("done"));

                                      await db
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .collection("images")
                                          .add({
                                        'url': downloadUrl,
                                      }).then((value) => print("done"));

                                      var chats = await FirebaseFirestore
                                          .instance
                                          .collection('chats')
                                          .get();

                                      for (int i = 0; i < chats.size; i++) {
                                        if (chats.docs[i]['user1'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          db
                                              .collection('chats')
                                              .doc(chats.docs[i].id)
                                              .update(
                                                  {'user1_image': downloadUrl});
                                        } else if (chats.docs[i]['user2'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid) {
                                          db
                                              .collection('chats')
                                              .doc(chats.docs[i].id)
                                              .update(
                                                  {'user2_image': downloadUrl});
                                        } else {
                                          null;
                                        }
                                      }
                                      updateVisiterImage(downloadUrl);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Имя",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      onSubmitted: (name) {
                                        widget.userName = name.toString();
                                      },
                                      onChanged: (name) {
                                        widget.userName = name.toString();
                                      },
                                      controller: name,
                                      decoration: InputDecoration(
                                        alignLabelWithHint: false,
                                        border: InputBorder.none,
                                        hintText: widget.userName,
                                        hintStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Возраст",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onSubmitted: (age) {
                                        widget.age = age.toString();
                                      },
                                      onChanged: (value) {
                                        widget.age = value.toString();
                                      },
                                      controller: age,
                                      decoration: InputDecoration(
                                        hintText: widget.age,
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
                                        alignLabelWithHint: false,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Рост",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      onSubmitted: (email) {
                                        widget.rost = email.toString();
                                      },
                                      onChanged: (email) {
                                        widget.rost = email.toString();
                                      },
                                      controller: email,
                                      decoration: InputDecoration(
                                        hintText: widget.rost,
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
                                        alignLabelWithHint: false,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "О себе",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      minLines: 1,
                                      maxLines: 5,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      onSubmitted: (about) {
                                        widget.about = about.toString();
                                      },
                                      onChanged: (about) {
                                        widget.about = about.toString();
                                      },
                                      controller: about,
                                      decoration: InputDecoration(
                                        hintText: widget.about,
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
                                        alignLabelWithHint: false,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Хобби",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: TextField(
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      onSubmitted: (about) {
                                        widget.hobbi = about.toString();
                                      },
                                      onChanged: (about) {
                                        widget.hobbi = about.toString();
                                      },
                                      controller: hobbi,
                                      minLines: 1,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText: widget.hobbi,
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
                                        alignLabelWithHint: false,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Город",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Autocomplete<String>(
                                      optionsMaxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      optionsViewBuilder:
                                          (context, onSelected, options) {
                                        return Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            surfaceTintColor: Colors.white54,
                                            type: MaterialType.transparency,
                                            elevation: 4.0,
                                            child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.3,
                                              ),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final option = options
                                                        .elementAt(index);
                                                    return ListTile(
                                                      tileColor: Colors
                                                          .grey.shade700
                                                          .withOpacity(0.8),
                                                      title: Text(
                                                        option
                                                            .split(RegExp(
                                                                r"(?! )\s{2,}"))
                                                            .join(' ')
                                                            .split(
                                                                RegExp(r"\s+$"))
                                                            .join(''),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onTap: () =>
                                                          onSelected(option),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        );
                                      },
                                      optionsBuilder: (textEditingValue) {
                                        if (textEditingValue.text == '') {
                                          return [];
                                        }
                                        return cities
                                            .where((city) => city
                                                .toLowerCase()
                                                .startsWith(textEditingValue
                                                    .text
                                                    .toLowerCase()))
                                            .toList()
                                          ..sort((a, b) => a.compareTo(b));
                                      },
                                      onSelected: (String val) {
                                        setState(() {
                                          city!.text = val
                                              .split(RegExp(r"(?! )\s{2,}"))
                                              .join(' ')
                                              .split(RegExp(r"\s+$"))
                                              .join('');
                                        });
                                      },
                                      fieldViewBuilder: (context, controller,
                                          focusNode, onSubmitted) {
                                        controller.text = city!.text;
                                        return TextField(
                                          textAlign: TextAlign.right,
                                          controller: controller,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          focusNode: focusNode,
                                          onSubmitted: (String value) {
                                            onSubmitted();
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              city!.text = value
                                                  .split(RegExp(r"(?! )\s{2,}"))
                                                  .join(' ')
                                                  .split(RegExp(r"\s+$"))
                                                  .join('');
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.only(bottom: 10.0)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Наличие детей",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,

                                      //
                                      items: <String>['да', 'нет']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          deti = value.toString();
                                        });
                                      },
                                      value: deti,

                                      style: const TextStyle(
                                        color: Color.fromRGBO(128, 128, 128, 1),
                                      ),
                                      hint: const Text(
                                        "нет",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      dropdownColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                var chats = await db.collection('chats').get();

                                for (int i = 0; i < chats.size; i++) {
                                  if (chats.docs[i]['user1Nickname'] ==
                                      FirebaseAuth
                                          .instance.currentUser!.displayName) {
                                    db
                                        .collection('chats')
                                        .doc(chats.docs[i].id)
                                        .update(
                                            {'user1Nickname': widget.userName});
                                  } else if (chats.docs[i]['user2Nickname'] ==
                                      FirebaseAuth
                                          .instance.currentUser!.displayName) {
                                    db
                                        .collection('chats')
                                        .doc(chats.docs[i].id)
                                        .update(
                                            {'user2Nickname': widget.userName});
                                  } else {
                                    null;
                                  }
                                }
                                setState(() {
                                  DatabaseService().updateUserData(
                                      widget.userName,
                                      widget.email,
                                      int.parse(widget.age),
                                      widget.about,
                                      widget.hobbi,
                                      city!.text);
                                  firebaseAuth.currentUser!
                                      .updateDisplayName(widget.userName);
                                  global.GlobalAge = widget.age;
                                  global.GlobalAbout = widget.about;
                                });
                                var x = await getUserGroup();
                                nextScreenReplace(
                                    context,
                                    ProfilePage(
                                      group: x,
                                      email: widget.email,
                                      userName: widget.userName,
                                      about: widget.about,
                                      age: widget.age,
                                      hobbi: widget.hobbi,
                                      deti: widget.deti,
                                      city: city!.text,
                                      rost: widget.rost,
                                      pol: GlobalPol.toString(),
                                    ));
                              },
                              style: const ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(10.0)),
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.green),
                              ),
                              child: const Text(
                                "Сохранить",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ElevatedButton(
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.all(10.0)),
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.redAccent),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.12,
                                          padding: const EdgeInsets.all(15),
                                          child: Column(children: [
                                            const Text('Вы уверены?'),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor: Colors
                                                                .orangeAccent),
                                                    onPressed: () async {
                                                      var currentUser =
                                                          firebaseAuth
                                                              .currentUser;

                                                      FirebaseStorage.instance
                                                          .ref(currentUser!.uid)
                                                          .listAll()
                                                          .then((value) {
                                                        for (var element
                                                            in value.items) {
                                                          element.delete();
                                                        }
                                                      });

                                                      List chatsId = [];

                                                      await db
                                                          .collection('chats')
                                                          .where(Filter.or(
                                                              Filter('user1',
                                                                  isEqualTo:
                                                                      currentUser
                                                                          .uid),
                                                              Filter('user2',
                                                                  isEqualTo:
                                                                      currentUser
                                                                          .uid)))
                                                          .get()
                                                          .then((value) {
                                                        setState(() {
                                                          chatsId.add(value
                                                              .docs[0]
                                                              .data());
                                                        });
                                                      });

                                                      for (int i = 0;
                                                          i < chatsId.length;
                                                          i++) {
                                                        db
                                                            .collection(
                                                                'removedChats')
                                                            .add(chatsId[i]);
                                                        db
                                                            .collection('chats')
                                                            .doc(chatsId[i]
                                                                ['chatId'])
                                                            .delete();
                                                      }

                                                      currentUser.delete();

                                                      db
                                                          .collection('users')
                                                          .doc(currentUser.uid)
                                                          .delete();

                                                      nextScreenReplace(context,
                                                          const LoginPage());
                                                    },
                                                    child: const Text('Да')),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor: Colors
                                                                .orangeAccent),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Нет')),
                                              ],
                                            )
                                          ]),
                                        );
                                      });
                                },
                                child: const Text(
                                  'Удалить профиль',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  updateVisiterImage(String photourl) async {
    var users = await db.collection('users').get();

    for (int i = 0; i < users.size; i++) {
      if (users.docs[i].id != firebaseAuth.currentUser!.uid) {
        var collections = db
            .collection('users')
            .doc(users.docs[i].id)
            .collection('visiters')
            .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
            .snapshots();

        bool isEmpty = await collections.isEmpty;

        var snapshot = await db
            .collection('users')
            .doc(users.docs[i].id)
            .collection('visiters')
            .where('uid', isEqualTo: firebaseAuth.currentUser!.uid)
            .get();

        if (!isEmpty && snapshot.docs.isNotEmpty) {
          db
              .collection('users')
              .doc(users.docs[i].id)
              .collection('visiters')
              .doc(firebaseAuth.currentUser!.uid)
              .update({'photoUrl': photourl});
        } else {
          print(isEmpty);
        }
      }
    }
  }
}
