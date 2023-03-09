// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/pages/test/green_group.dart';

import '../../widgets/widgets.dart';

class FirstGroupRed extends StatefulWidget {
  const FirstGroupRed({Key? key}) : super(key: key);

  @override
  State<FirstGroupRed> createState() => _FirstGroupRedState();
}

class _FirstGroupRedState extends State<FirstGroupRed> {
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
    "неусидчивы, суетливы",
    "невыдержанны, вспыльчивы",
    'нетерпеливы',
    'резки и прямолинейны в отношениях с людьми',
    'решительны и инициативны',
    'упрямы',
    'находчивы в споре',
    'работаете рывками',
    'склонны к риску',
    'злопамятны',
    'обладаете быстрой, страстной, со сбивчивыми интонациями речью',
    'неуравновешенны и склонны к горячности',
    'агрессивный забияка',
    'нетерпимы к недостаткам',
    'обладаете выразительной мимикой',
    'способны быстро действовать и решать',
    'неустанно стремитесь к новому',
    'обладаете резкими порывистыми движениями',
    'настойчивы в достижении поставленной цели',
    'склонны к резким сменам настроения'
  ];

  int counter = 0;
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
              "Tecт",
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  const Text(
                    "Отметьте знаком «+» те качества , которые для вас обычны и «-» если противоположны, повседневны. Итак, если вы:",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(
                    height: 1150,
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
                        RedGroup = counter;
                      });
                      nextScreen(context, const GreenPage());
                    },
                    child: const Text("Дальше"),
                  )
                ],
              ),
            ),
          ),
        ),
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
                    width: 10,
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
