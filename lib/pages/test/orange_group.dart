// ignore_for_file: unrelated_type_equality_checks, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/pages/profile_page.dart';
import 'package:wbrs/widgets/widgets.dart';

class OrangePage extends StatefulWidget {
  const OrangePage({Key? key}) : super(key: key);

  @override
  State<OrangePage> createState() => _OrangePageState();
}

class _OrangePageState extends State<OrangePage> {
  int counter = 0;

  final List<Color> colors = <Color>[
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  final List<String> questions = [
    "стеснительны и застенчивы",
    "теряетесь в новой обстановке",
    'затрудняетесь установить контакт с незнакомыми людьми',
    'не верите в свои силы',
    'легко переносите одиночество',
    'чувствуете подавленность и растерянность при неудачах',
    'склонны уходить в себя',
    'быстро утомляетесь',
    'обладаете тихой речью',
    ' невольно приспосабливаетесь к характеру собеседника',
    'впечатлительны до слезливости',
    'чрезвычайно восприимчивы к одобрению и порицанию',
    'предъявляете высокие требования к себе и окружающим',
    'склонны к подозрительности, мнительности',
    'болезненно чувствительны и легко ранимы',
    'чрезмерно обидчивы',
    'скрытны и необщительны, не делитесь ни с кем своими мыслями',
    'малоактивны и робки',
    'уступчивы, покорны',
    'стремитесь вызвать сочувствие и помощь у окружающих'
  ];

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
              title: const Text(
                "Ответьте на вопросы",
              ),
            ),
            body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: colors.length,
                            itemBuilder: (_, int index) {
                              return QuestionBuilder(index);
                            }),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              BlueGroup = counter;
                            });
                            int max = 0;
                            int max2 = 0;
                            if (BrownGroup > max) {
                              max = BrownGroup;
                            }

                            if (RedGroup > max) {
                              max = RedGroup;
                            }

                            if (WhiteGroup > max) {
                              max = WhiteGroup;
                            }

                            if (BlueGroup > max) {
                              max = BlueGroup;
                            }
                            print(BrownGroup.toString() + RedGroup.toString() + WhiteGroup.toString() + BlueGroup.toString());

                            if (BrownGroup > max2 && BrownGroup != max) {
                              max2 = BrownGroup;
                            }

                            if (RedGroup > max2 && RedGroup != max) {
                              max2 = RedGroup;
                            }

                            if (WhiteGroup > max2 && WhiteGroup != max) {
                              max2 = WhiteGroup;
                            }

                            if (BlueGroup > max2 && OrangePage != max) {
                              max2 = BlueGroup;
                            }

                            if (max == BrownGroup) {
                              if (max2 == RedGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "коричнево-красная"});
                                Group = "коричнево-красная";
                              }
                              if (max2 == BlueGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "коричнево-синяя"});
                                Group = "коричнево-синяя";
                              }
                              if (max2 == WhiteGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "коричнево-белая"});
                                Group = "коричнево-белая";
                              }
                            }

                            if (max == RedGroup) {
                              if (max2 == BrownGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "красно-коричневая"});
                                Group = "красно-коричневая";
                              }
                              if (max2 == BlueGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "красно-синяя"});
                                Group = "красно-синяя";
                              }
                              if (max2 == WhiteGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "красно-белая"});
                                Group = "красно-белая";
                              }
                            }

                            if (max == BlueGroup) {
                              if (max2 == RedGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "сине-красная"});
                                Group = "сине-красная";
                              }
                              if (max2 == BrownGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "сине-коричневая"});
                                Group = "сине-коричневая";
                              }
                              if (max2 == WhiteGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "сине-белая"});
                                Group = "сине-белая";
                              }
                            }

                            if (max == WhiteGroup) {
                              if (max2 == RedGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "бело-красная"});
                                Group = "бело-красная";
                              }
                              if (max2 == BlueGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "бело-синяя"});
                                Group = "бело-синяя";
                              }
                              if (max2 == BrownGroup) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({"группа": "бело-коричневая"});
                                Group = "бело-коричневая";
                              }
                            }

                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'isRegistrationEnd': true});
                            setState(() {
                              selectedIndex = 0;
                            });
                            nextScreen(
                                context,
                                ProfilePage(
                                  group: Group,
                                  email: FirebaseAuth
                                      .instance.currentUser!.email
                                      .toString(),
                                  userName: FirebaseAuth
                                      .instance.currentUser!.displayName
                                      .toString(),
                                  about: GlobalAbout.toString(),
                                  age: GlobalAge.toString(),
                                  deti: GlobalDeti,
                                  rost: GlobalRost.toString(),
                                  city: GlobalCity.toString(),
                                  hobbi: GlobalHobbi.toString(),
                                  pol: GlobalPol.toString(),
                                ));
                            showSnackbar(context, Colors.green,
                                "Успешно! Ваша группа: $Group}");
                          },
                          child: const Text("Завершить"))
                    ],
                  ),
                ))),
      ],
    );
  }

  QuestionBuilder(int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(questions[index],
                    style: const TextStyle(color: Colors.white))),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        colors[index] = Colors.green;
                        counter++;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors[index] == Colors.red
                            ? Colors.grey
                            : colors[index]),
                    child: const Text(
                      "+",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (counter != 0) {
                        setState(() {
                          counter--;
                        });
                      }
                      setState(() {
                        colors[index] = Colors.red;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors[index] == Colors.green
                            ? Colors.grey
                            : colors[index]),
                    child: const Text(
                      "-",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
