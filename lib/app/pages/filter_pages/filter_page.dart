import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/filter_pages/cities.dart';
import 'package:wbrs/presentations/screens/list_of_users/profiles_list.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильтр'),
        backgroundColor: Colors.orangeAccent,
        //actions: [IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(CupertinoIcons.clear)),],
      ),
      body: const FilterPage2(),
    );
  }
}

class FilterPage2 extends StatefulWidget {
  const FilterPage2({super.key});

  @override
  State<FilterPage2> createState() => _FilterPage2State();
}

class _FilterPage2State extends State<FilterPage2> {
  String pol = '';
  String city = filterCity.text;
  TextEditingController filtrAgeStart = TextEditingController();
  TextEditingController filtrAgeEnd = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtrAgeStart.text = ageStart.toString();
    filtrAgeEnd.text = ageEnd.toString();
  }

  @override
  void dispose() {
    filtrAgeStart.dispose();
    filtrAgeEnd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: MediaQuery.of(context).size.height * 0.3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                filterByGroup = !filterByGroup;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    filterByGroup
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  const Text('Фильтр по группам',
                      style: TextStyle(color: Colors.white)),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Container(
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
                    const Text('Пол:', style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          filtrPol = 'м';
                          nextScreenReplace(context,
                              ProfilesList(startPosition: 0, group: group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          'M',
                          style: TextStyle(
                              color: filtrPol == 'м'
                                  ? Colors.orangeAccent
                                  : Colors.white24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          filtrPol = 'ж';
                          nextScreenReplace(context,
                              ProfilesList(startPosition: 0, group: group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          'Ж',
                          style: TextStyle(
                              color: filtrPol == 'ж'
                                  ? Colors.orangeAccent
                                  : Colors.white24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          filtrPol = '';
                          nextScreenReplace(context,
                              ProfilesList(startPosition: 0, group: group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          'Все',
                          style: TextStyle(
                              color: filtrPol == ''
                                  ? Colors.orangeAccent
                                  : Colors.white24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          StatefulBuilder(builder: (context, state) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.calendar),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Возраст',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'от ${filtrAgeStart.text} ',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white),
                            ),
                            Text(
                              'до ${filtrAgeEnd.text}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.white),
                            )
                          ],
                        ),
                        SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      filled: true,
                                      fillColor: Colors.white24,
                                    ),
                                    controller: filtrAgeStart,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const Text('-',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white)),
                                      filled: true,
                                      fillColor: Colors.white24,
                                    ),
                                    controller: filtrAgeEnd,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            )),
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
          Container(
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
                    const Text('Город:', style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Autocomplete<String>(
                        optionsMaxHeight:
                            MediaQuery.of(context).size.height * 0.3,
                        optionsViewBuilder: (context, onSelected, options) {
                          return cityDropdown(context, options, onSelected);
                        },
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text == '') {
                            return [];
                          }
                          return cities
                              .where((city) => city.toLowerCase().startsWith(
                                  textEditingValue.text.toLowerCase()))
                              .toList()
                            ..sort((a, b) => a.compareTo(b));
                        },
                        onSelected: (String val) {
                          setState(() {
                            String value = val.trim();
                            filterCity.text = value;
                            city = value;
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode, onSubmitted) {
                          controller.text = city;
                          return TextField(
                            controller: controller,
                            style: const TextStyle(color: Colors.white),
                            focusNode: focusNode,
                            onSubmitted: (String value) {
                              onSubmitted();
                            },
                            onChanged: (value) {
                              setState(() {
                                city = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    var x = await getUserGroup();
                    setState(() {
                      filterCity.text = city;
                      ageStart = int.parse(filtrAgeStart.text);
                      ageEnd = int.parse(filtrAgeEnd.text);
                      nextScreenReplace(
                          context,
                          ProfilesList(
                              startPosition: 0, group: filterByGroup ? x : ''));
                    });
                  },
                  child: const Text('Применить фильтры',
                      style: TextStyle(color: Colors.white))),
              TextButton(
                  onPressed: () async {
                    var x = await getUserGroup();
                    filterByGroup = false;
                    filtrPol = '';
                    setState(() {
                      filterCity.text = '';
                      ageStart = 0;
                      ageEnd = 100;
                      nextScreenReplace(
                          context, ProfilesList(startPosition: 0, group: x));
                    });
                  },
                  child: const Text('Сбросить фильтры',
                      style: TextStyle(color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }
}
