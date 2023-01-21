import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger/helper/global.dart';

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


  String pol="";

  static const List<String> _kOptions = <String>[
    'Чебоксары',
    'bobcat',
    'chameleon',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
        ),
        height: 500,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: const BoxConstraints(
            maxHeight: 400, minHeight: 20),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context){
                  return
                    Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(

                      ),
                      body: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Column (
                          children: [
                            GestureDetector(
                              child: Row(
                                children: const [
                                  Text("Мужчины"),
                                  Icon(Icons.man)
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  pol="m";
                                });
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 15,),
                            GestureDetector(
                              child: Row(
                                children: const[
                                  Text("Женщины"),
                                  Icon(Icons.woman)
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  pol="zh";
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

                width: MediaQuery.of(context).size.width-20,
                padding:const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.person),
                        const SizedBox(width: 10,),
                        const Text("Пол:"),
                        const SizedBox(width: 10,),
                        Text(pol=="m"? "Мужчины" : "Женщины")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                showModalBottomSheet(context: context, builder: (context){
                  return
                    //
                      Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(

                        ),
                        body: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Column(
                          children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('от ${currentValues.start.round()} ',style: const TextStyle(
                          fontSize: 22
                          ),),
                          Text('до ${currentValues.end.round()}',style: const TextStyle(
                          fontSize: 22
                          ),)
                          ],
                          ),
                          StatefulBuilder(builder: (BuildContext context, StateSetter setState){
                          return RangeSlider(
                          values: currentValues,
                                  min: 18,
                                  max: 100,
                                  divisions: 100,
                                  activeColor: Colors.orange,
                                  labels:  RangeLabels(
                                      currentValues.start.round().toString(),
                                      currentValues.end.round().toString()),
                                  onChanged: (RangeValues values){
                                    setState(() {
                                      currentValues=values;
                                    });
                                  });}),
                            ],),
                        ),
                      );
                    });

              },
              child: Container(

                width: MediaQuery.of(context).size.width-20,
                padding:const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(CupertinoIcons.calendar),
                        const SizedBox(width: 10,),
                        const Text("Возраст:"),
                        const SizedBox(width: 10,),
                        Text("${currentValues.start.round().toString()}-${currentValues.end.round().toString()}")
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: (){

                Scaffold.of(context).showBottomSheet<void>((BuildContext context){
                  return Scaffold(

                    body: Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue){
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _kOptions.where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        debugPrint('You just selected $selection');
                      },


                    ),
                  );
                });

              },
              child: Container(

                width: MediaQuery.of(context).size.width-20,
                padding:const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const[
                        Icon(CupertinoIcons.map),
                        SizedBox(width: 10,),
                        Text("Город:"),
                        SizedBox(width: 10,),
                        Text("Чебоксары")
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


