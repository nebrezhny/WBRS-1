// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/pages/test/white_group.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class GreenPage extends StatefulWidget {
  const GreenPage({super.key});

  @override
  State<GreenPage> createState() => _GreenPageState();
}

class _GreenPageState extends State<GreenPage> {
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
    'веселы и жизнерадостны',
    'энергичны и деловиты',
    'часто не доводите начатое дело до конца',
    'склонны переоценивать себя',
    'способны быстро схватывать новое',
    'неустойчивы в интересах и склонностях',
    'легко переживаете неудачи и неприятности',
    'легко приспосабливаетесь к разным обстоятельствам',
    'с увлечением беретесь за любое новое дело',
    'быстро остываете, если дело перестает вас интересовать',
    'быстро включаетесь в новую работу и быстро переключаетесь с одной работы на другую',
    'тяготитесь однообразием будничной кропотливой работы',
    'общительны и отзывчивы, не чувствуете скованности с новыми для вас людьми',
    'выносливы и работоспособны',
    'обладаете громкой, быстрой, отчетливой речью, сопровождающейся жестами, выразительной мимикой',
    'сохраняете самообладание в неожиданной сложной обстановке',
    'обладаете всегда бодрым настроением',
    'быстро засыпаете и пробуждаетесь',
    'часто не собраны, проявляете поспешность в решениях',
    'склонны иногда скользить по поверхности, отвлекаться'
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
            'assets/fon.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            scale: 0.6,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.transparent,
              title: const Text(
                'Ответьте на вопросы',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: colors.length,
                          itemBuilder: (_, int index) {
                            return QuestionBuilder(index);
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              redGroup = counter;
                            });
                            nextScreenReplace(context, const WhitePage());
                          },
                          child: const Text('Дальше'))
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
                      '+',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        colors[index] = Colors.red;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colors[index] == Colors.green
                            ? Colors.grey
                            : colors[index]),
                    child: const Text(
                      '-',
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
