import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/helper/helper_function.dart';
import 'package:wbrs/pages/profiles_list.dart';
import 'package:wbrs/widgets/widgets.dart';

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
  const FilterPage2({super.key});

  @override
  State<FilterPage2> createState() => _FilterPage2State();
}

class _FilterPage2State extends State<FilterPage2> {
  String pol = "";
  String city = filtrCity.text;
  TextEditingController filtrAgeStart = TextEditingController();
  TextEditingController filtrAgeEnd = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtrAgeStart.text = ageStart.toString();
    filtrAgeEnd.text = ageEnd.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: MediaQuery.of(context).size.height*0.3,
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
                  Icon(filterByGroup ? Icons.check_box_outlined : Icons.check_box_outline_blank, color: Colors.white,),
                  const SizedBox(width: 10),
                  const Text("Фильтр по группам", style: TextStyle(color: Colors.white)),
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
                    const Text("Пол:", style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          FiltrPol = "м";
                          nextScreenReplace(context, ProfilesList(group: Group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text('M', style: TextStyle(color: FiltrPol == "м" ? Colors.orangeAccent : Colors.white24, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          FiltrPol = "ж";
                          nextScreenReplace(context, ProfilesList(group: Group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text('Ж', style: TextStyle(color: FiltrPol == "ж" ? Colors.orangeAccent : Colors.white24, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          FiltrPol = "";
                          nextScreenReplace(context, ProfilesList(group: Group));
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text('Все', style: TextStyle(color: FiltrPol == "" ? Colors.orangeAccent : Colors.white24, fontWeight: FontWeight.bold),),
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
              onTap: () {
              },
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
                        const Text("Возраст", style: TextStyle(color: Colors.white)),
                        const SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'от ${filtrAgeStart.text} ',
                              style: const TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            Text(
                              'до ${filtrAgeEnd.text}',
                              style: const TextStyle(fontSize: 13, color: Colors.white),
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.white)),
                                    filled: true,
                                    fillColor: Colors.white24,
                                  ),
                                  controller: filtrAgeStart,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const Text("-", style: TextStyle(color: Colors.white)),
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.white)),
                                    filled: true,
                                    fillColor: Colors.white24,
                                  ),
                                  controller: filtrAgeEnd,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
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
                    const Text("Город:", style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        controller: filtrCity,
                        style: const TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {
                            city = value.split(RegExp(r"(?! )\s{2,}")).join(' ').split(RegExp(r"\s+$")).join('');
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () async {
                var x = await getUserGroup();
                setState(() {
                  filtrCity.text = city;
                  ageStart = int.parse(filtrAgeStart.text);
                  ageEnd = int.parse(filtrAgeEnd.text);
                  nextScreenReplace(context, ProfilesList(group: x));
                });
              },
              child: const Text('Применить фильтры', style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
