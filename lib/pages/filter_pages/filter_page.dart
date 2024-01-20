import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/helper/global.dart';
import 'package:messenger/helper/helper_function.dart';
import 'package:messenger/pages/profiles_list.dart';
import 'package:messenger/widgets/widgets.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Фильтр"),
        backgroundColor: Colors.orangeAccent,
        //actions: [IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(CupertinoIcons.clear)),],
      ),
      body: const FilterPage2(),
    );
  }
}

class FilterPage2 extends StatefulWidget {
  const FilterPage2({Key? key}) : super(key: key);

  @override
  State<FilterPage2> createState() => _FilterPage2State();
}

class _FilterPage2State extends State<FilterPage2> {
  String pol = "";
  RangeValues localValues = currentValues;
  String city = filtrCity.text;

  static const List<String> _kOptions = <String>[
    'Чебоксары',
    'Bobcat',
    'Chameleon',
    'Moscow'
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 500,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: const BoxConstraints(maxHeight: 400, minHeight: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: Colors.orangeAccent,
                        ),
                        body: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                child: const Row(
                                  children: [Text("Мужчины"), Icon(Icons.man)],
                                ),
                                onTap: () {
                                  setState(() {
                                    pol = "м";
                                    FiltrPol = "м";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                child: const Row(
                                  children: [
                                    Text("Женщины"),
                                    Icon(Icons.woman)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    pol = "ж";
                                    FiltrPol = "ж";
                                  });
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.person),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Пол:"),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(FiltrPol == ""
                            ? "Не выбрано"
                            : FiltrPol == "м"
                                ? "Мужчины"
                                : "Женщины")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            StatefulBuilder(builder: (context, state) {
              localValues = currentValues;
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return
                            //
                            StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            appBar: AppBar(
                              backgroundColor: Colors.orangeAccent,
                            ),
                            body: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'от ${currentValues.start.round()} ',
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                      Text(
                                        'до ${currentValues.end.round()}',
                                        style: const TextStyle(fontSize: 22),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      RangeSlider(
                                          values: localValues,
                                          min: 18,
                                          max: 100,
                                          divisions: 100,
                                          activeColor: Colors.orange,
                                          labels: RangeLabels(
                                              localValues.start
                                                  .round()
                                                  .toString(),
                                              localValues.end
                                                  .round()
                                                  .toString()),
                                          onChanged: (RangeValues values) {
                                            setState(() {
                                              currentValues = values;
                                              localValues = values;
                                            });
                                          }),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              localValues = currentValues;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Сохранить"))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(CupertinoIcons.calendar),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Возраст"),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).showBottomSheet((BuildContext context) {
                  return Scaffold(
                      body: Column(
                    children: [
                      TextField(
                        controller: filtrCity,
                        onChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Сохранить'))
                    ],
                  ));
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.map),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Город:"),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(city)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  filtrCity.text = city;
                  FiltrPol = pol;
                  currentValues = localValues;
                  var x = await getUserGroup();
                  nextScreen(context, ProfilesList(group: x));
                },
                child: Text('Сохранить'))
          ],
        ),
      ),
    );
  }
}
