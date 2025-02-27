// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:wbrs/app/pages/filter_pages/cities.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wbrs/app/widgets/widgets.dart';

import '../../helper/global.dart';
import '../../helper/helper_function.dart';
import '../test/red_group.dart';

class AboutUserWriting extends StatefulWidget {
  const AboutUserWriting({super.key});

  @override
  State<AboutUserWriting> createState() => _AboutUserWritingState();
}

class _AboutUserWritingState extends State<AboutUserWriting> {
  TextEditingController age = TextEditingController();
  bool Age = false;
  bool Rost = false;
  bool City = false;
  TextEditingController rost = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController hobbi = TextEditingController();
  TextEditingController about = TextEditingController();

  String imageUrl = ' ';
  String chatIdThis = '';
  XFile? _image;
  String? deti;
  String? pol;
  bool Deti = false;
  String profilePic = '';

  var currentUser;
  var displayName;
  var email;

  bool Is18 = false;
  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.green,
            )
          ]),
          child: Image.asset(
            'assets/fon2.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orangeAccent,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 37),
              width: double.infinity,
              height: 1150,
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _image == null
                              ? Container(
                                  color: Colors.white,
                                  width: 200,
                                  height: 200,
                                  child: IconButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.white)),
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.person,
                                        size: 105,
                                      )),
                                )
                              : SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                          child: Container(
                            color: Colors.deepOrangeAccent,
                            width: 50,
                            height: 50,
                            child: IconButton(
                              onPressed: () async {
                                XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);

                                setState(() {
                                  _image = image;
                                });

                                FirebaseStorage storage =
                                    FirebaseStorage.instance;
                                try {
                                  await storage
                                      .ref(
                                          'avatar-${firebaseAuth.currentUser!.displayName}')
                                      .putFile(File(_image!.path));
                                } on FirebaseException catch (e) {
                                  e.message;
                                }
                                String downloadUrl = await storage
                                    .ref(
                                        'avatar-${firebaseAuth.currentUser!.displayName}')
                                    .getDownloadURL();
                                await firebaseAuth.currentUser!
                                    .updatePhotoURL(downloadUrl.toString());
                                await firebaseFirestore
                                    .collection('users')
                                    .doc(firebaseAuth.currentUser!.uid)
                                    .collection('images')
                                    .add({
                                  'url': downloadUrl,
                                });
                                profilePic = downloadUrl.toString();
                              },
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Возраст'),
                        SizedBox(
                          width: 190,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onSubmitted: (name) {},
                            controller: age,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorText: Age ? 'Заполните поле' : null,
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(right: 30),
                                hintText: '20',
                                hintStyle: const TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Рост'),
                        SizedBox(
                          width: 190,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.right,
                            style: const TextStyle(color: Colors.black),
                            onSubmitted: (name) {},
                            controller: rost,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorText: Rost ? 'Заполните поле' : null,
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(right: 30),
                                hintText: '20',
                                hintStyle: const TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Город'),
                        SizedBox(
                          width: 150,
                          child: Autocomplete<String>(
                            optionsMaxHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topCenter,
                                child: Material(
                                  surfaceTintColor: Colors.white54,
                                  type: MaterialType.transparency,
                                  elevation: 4.0,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                    ),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option =
                                              options.elementAt(index);
                                          return ListTile(
                                            tileColor: grey,
                                            title: Text(
                                              option
                                                  .split(RegExp(r'(?! )\s{2,}'))
                                                  .join(' ')
                                                  .split(RegExp(r'\s+$'))
                                                  .join(''),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () => onSelected(option),
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
                                      .startsWith(
                                          textEditingValue.text.toLowerCase()))
                                  .toList()
                                ..sort((a, b) => a.compareTo(b));
                            },
                            onSelected: (String val) {
                              setState(() {
                                city.text = val
                                    .split(RegExp(r'(?! )\s{2,}'))
                                    .join(' ')
                                    .split(RegExp(r'\s+$'))
                                    .join('');
                              });
                            },
                            fieldViewBuilder:
                                (context, controller, focusNode, onSubmitted) {
                              controller.text = city.text;
                              return TextField(
                                textAlign: TextAlign.right,
                                controller: controller,
                                focusNode: focusNode,
                                onSubmitted: (String value) {
                                  onSubmitted();
                                },
                                onChanged: (value) {
                                  setState(() {
                                    city.text = value
                                        .split(RegExp(r'(?! )\s{2,}'))
                                        .join(' ')
                                        .split(RegExp(r'\s+$'))
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
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Есть дети?'),
                        DropdownButton(
                          //
                          items: <String>['да', 'нет'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              deti = value;
                            });
                          },
                          value: deti,
                          style: const TextStyle(color: Colors.black),
                          hint: const Text('нет'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Пол'),
                        DropdownButton(
                          //
                          items: <String>['м', 'ж'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              pol = value;
                            });
                          },
                          value: pol,
                          style: const TextStyle(color: Colors.black),
                          hint: const Text(''),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Хобби'),
                        SizedBox(
                          width: 190,
                          height: 40,
                          child: TextField(
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onSubmitted: (name) {},
                            controller: hobbi,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 30),
                                hintText: 'рисование, пение...',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('О себе'),
                        SizedBox(
                          width: 190,
                          height: 140,
                          child: TextField(
                            textAlign: TextAlign.right,
                            maxLines: 5,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            onSubmitted: (name) {},
                            controller: about,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(right: 30),
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        //color: Colors.white70
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'Вы подтверждаете, что вам есть 18 лет',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Checkbox(
                            value: Is18,
                            onChanged: (value) {
                              setState(() {
                                Is18 = value!;
                              });
                            },
                            checkColor: Colors.deepOrangeAccent,
                            fillColor: const WidgetStatePropertyAll(
                                Color.fromARGB(255, 209, 204, 204)),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.deepOrangeAccent)),
                      onPressed: () {
                        if (city.text.isEmpty) {
                          setState(() {
                            City = true;
                          });
                        } else {
                          setState(() {
                            City = false;
                          });
                        }

                        if (age.text.isEmpty) {
                          setState(() {
                            Age = true;
                          });
                        } else {
                          setState(() {
                            Age = false;
                          });
                        }
                        if (deti == '' || deti == 'нет' || deti == null) {
                          Deti = false;
                        } else {
                          Deti = true;
                        }

                        if (rost.text.isEmpty) {
                          setState(() {
                            Rost = true;
                          });
                        } else {
                          setState(() {
                            Rost = false;
                          });
                        }

                        if (city.text.isNotEmpty &&
                            age.text.isNotEmpty &&
                            rost.text.isNotEmpty &&
                            profilePic.isNotEmpty &&
                            hobbi.text.isNotEmpty &&
                            about.text.isNotEmpty &&
                            rost.text.isNotEmpty) {
                          DatabaseService().savingUserDataAfterRegister(
                              displayName,
                              email,
                              profilePic,
                              int.parse(age.text),
                              rost.text,
                              city.text,
                              Deti,
                              hobbi.text,
                              about.text,
                              pol.toString());
                          globalAge = age.text;
                          globalAbout = about.text;
                          globalPol = pol;
                          globalCity = city.text;
                          globalHobbi = hobbi.text;
                          globalRost = rost.text;
                          globalDeti = Deti;

                          if (!Is18) {
                            showSnackbar(context, Colors.red,
                                'Подтвердите, что вам есть 18 лет.');
                          } else {
                            if (pol == null) {
                              showSnackbar(context, Colors.red, 'Укажите пол.');
                            } else {
                              nextScreenReplace(context, const FirstGroupRed());
                            }
                          }

                          setState(() {});

                          //showSnackbar(context, Colors.green, "Успешно!");
                        } else {
                          showSnackbar(
                              context, Colors.red, 'Заполните все поля.');
                        }
                      },
                      child: const Text('Пройти тест для определения группы', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
