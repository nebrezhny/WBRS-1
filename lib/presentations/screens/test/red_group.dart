
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import '../../../app/widgets/widgets.dart';
import '../../../presentations/screens/home/home_page.dart';

class FirstGroupRed extends StatefulWidget {
  const FirstGroupRed({super.key});

  @override
  State<FirstGroupRed> createState() => _FirstGroupRedState();
}

class _FirstGroupRedState extends State<FirstGroupRed> {
  final List<Color> colors = List.generate(80, (index) => Colors.grey);

  final List<String> brownQuestions = [
    'неусидчивы, суетливы',
    'невыдержанны, вспыльчивы',
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

  final List<String> redQuestions = [
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

  final List<String> blueQuestions = [
    'стеснительны и застенчивы',
    'теряетесь в новой обстановке',
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

  final List<String> whiteQuestions = [
    'спокойны и хладнокровны',
    'последовательны и обстоятельны в делах',
    'осторожны и рассудительны',
    'умеете ждать',
    'молчаливы и не любите попусту болтать',
    'обладаете спокойной, равномерной речью, с остановками, без резко выраженных эмоций, жестикуляции и мимики',
    'сдержаны и терпеливы',
    'доводите начатое дело до конца',
    'не растрачиваете попусту сил',
    'придерживаетесь выработанного распорядка дня, жизни, системы в работе',
    'легко сдерживаете порывы',
    'маловосприимчивы к одобрению и порицанию',
    'незлобивы, проявляете снисходительное отношение к колкостям в свой адрес',
    'постоянны в своих отношениях и интересах',
    'медленно включаетесь в работу и медленно переключаетесь с одного дела на другое',
    'ровны в отношениях со всеми',
    'любите аккуратность и порядок во всем',
    'с трудом приспосабливаетесь к новой обстановке',
    'обладаете выдержкой',
    'несколько медлительны'
  ];

  List<List<String>> allQuestions = [];
  List groupCounter = [0, 0, 0, 0];

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    allQuestions = [
      brownQuestions,
      redQuestions,
      blueQuestions,
      whiteQuestions
    ];

    void finishTest(){
      int max = 0;
      int max2 = 0;
      setState(() {
        if (brownGroup > max) {
          max = brownGroup;
        }

        if (redGroup > max) {
          max = redGroup;
        }

        if (whiteGroup > max) {
          max = whiteGroup;
        }

        if (blueGroup > max) {
          max = blueGroup;
        }

        if (brownGroup > max2 && brownGroup != max) {
          max2 = brownGroup;
        }

        if (redGroup > max2 && redGroup != max) {
          max2 = redGroup;
        }

        if (whiteGroup > max2 && whiteGroup != max) {
          max2 = whiteGroup;
        }

        if (blueGroup > max2 && blueGroup != max) {
          max2 = blueGroup;
        }

        if (max == brownGroup) {
          if (max2 > 0) {
            if (max2 == redGroup) {
              group = 'коричнево-красная';
            }
            if (max2 == blueGroup) {
              group = 'коричнево-синяя';
            }
            if (max2 == whiteGroup) {
              group = 'коричнево-белая';
            }
          } else {
            group = 'коричневая';
          }
        }

        if (max == redGroup) {
          if (max2 > 0) {
            if (max2 == brownGroup) {
              group = 'красно-коричневая';
            }
            if (max2 == blueGroup) {
              group = 'красно-синяя';
            }
            if (max2 == whiteGroup) {
              group = 'красно-белая';
            }
          } else {
            group = 'красная';
          }
        }

        if (max == blueGroup) {
          if (max2 > 0) {
            if (max2 == redGroup) {
              group = 'сине-красная';
            }
            if (max2 == brownGroup) {
              group = 'сине-коричневая';
            }
            if (max2 == whiteGroup) {
              group = 'сине-белая';
            }
          } else {
            group = 'синяя';
          }
        }

        if (max == whiteGroup) {
          if (max2 > 0) {
            if (max2 == redGroup) {
              group = 'бело-красная';
            }
            if (max2 == blueGroup) {
              group = 'бело-синяя';
            }
            if (max2 == brownGroup) {
              group = 'бело-коричневая';
            }
          } else {
            group = 'белая';
          }
        }
        firebaseFirestore
            .collection('users')
            .doc(firebaseAuth.currentUser!.uid)
            .update({
          'isRegistrationEnd': true,
          'группа': group
        });
        setState(() {
          selectedIndex = 1;
        });
        showSnackbar(context, Colors.green,
            'Успешно! Ваша группа: $group');
      });
    }

    return Stack(
      children: [
        Image.asset(
          'assets/fon.jpg',
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          scale: 0.6,
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                children: [
                  const Text(
                    'Поставьте + там, где похоже на вас',
                    style: TextStyle(fontSize: 16, color: Colors.white, height: 5),
                  ),
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
                        brownGroup = groupCounter[0];
                        redGroup = groupCounter[1];
                        blueGroup = groupCounter[2];
                        whiteGroup = groupCounter[3];
                      });
                      finishTest();
                      nextScreenReplace(context, const HomePage());
                    },
                    child: const Text('Завершить тест'),
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
    int groupIndex =
        index>=40 ? index ~/ 10 - 4 : index ~/ 10;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  index>=40
                    ?allQuestions[groupIndex][index % 10 + 10]
                    :allQuestions[groupIndex][index % 10],
                    style: const TextStyle(color: Colors.white))),
            SizedBox(
              width: 30,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if(colors[index] == Colors.green){
                      colors[index] = Colors.grey;
                      groupCounter[groupIndex]--;
                    } else{
                      colors[index] = Colors.green;
                      groupCounter[groupIndex]++;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                    backgroundColor: colors[index] == Colors.red
                        ? Colors.grey
                        : colors[index]),
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 20),
                ),
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
