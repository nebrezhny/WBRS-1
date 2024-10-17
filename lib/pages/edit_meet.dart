import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/helper/global.dart';
import 'package:wbrs/pages/meetings.dart';

import '../widgets/widgets.dart';

class EditMeet extends StatefulWidget {
  final DocumentSnapshot meet;
  const EditMeet({super.key, required this.meet});

  @override
  State<EditMeet> createState() => _EditMeetState();
}

class _EditMeetState extends State<EditMeet> {
  TextEditingController nameMeet = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController dateAndTime = TextEditingController();

  String? _type = 'групповая';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.input);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameMeet.text = widget.meet.get('name');
    city.text = widget.meet.get('city');
    description.text = widget.meet.get('description');
    dateAndTime.text = widget.meet.get('datetime');
    _type = widget.meet.get('type');
  }

  @override
  Widget build(BuildContext context) {
    DocumentReference collectionReference =
        firebaseFirestore.collection('meets').doc(widget.meet.id);
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: []),
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
            backgroundColor: Colors.orangeAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: nameMeet,
                    decoration: const InputDecoration(
                        hintText: 'Введите название встречи',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: city,
                    decoration: const InputDecoration(
                        hintText: 'Введите название города',
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    maxLength: 300,
                    controller: description,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Введите краткое описание встречи',
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate.month > 10
                            ? 'Дата: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'
                            : 'Дата: ${selectedDate.day}.0${selectedDate.month}.${selectedDate.year}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent),
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: const Text(
                            'Выбрать дату',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime.hour > 10
                            ? selectedTime.minute > 10
                                ? 'Время: ${selectedTime.hour}:${selectedTime.minute}'
                                : 'Время: ${selectedTime.hour}:0${selectedTime.minute}'
                            : selectedTime.minute > 10
                                ? 'Время: 0${selectedTime.hour}:${selectedTime.minute}'
                                : 'Время: 0${selectedTime.hour}:0${selectedTime.minute}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent),
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: const Text(
                            'Выбрать время',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    dropdownColor: Colors.black45,
                    items: <String>['индивидуальная', 'групповая']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: null,
                    decoration: const InputDecoration(border: InputBorder.none),
                    value: _type,
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            var day = selectedDate.day > 10
                                ? selectedDate.day
                                : '0${selectedDate.day}';
                            var month = selectedDate.month > 10
                                ? selectedDate.month
                                : '0${selectedDate.month}';
                            var hour = selectedTime.hour > 10
                                ? selectedTime.hour
                                : '0${selectedTime.hour}';
                            var minute = selectedTime.minute > 10
                                ? selectedTime.minute
                                : '0${selectedTime.minute}';

                            var dateTime =
                                '$day.$month.${selectedDate.year} $hour:$minute';
                            if (nameMeet.text.replaceAll(' ', '').isEmpty) {
                              showSnackbar(
                                  context, Colors.red, 'Введите название!');
                            }
                            if (city.text == '') {
                              showSnackbar(
                                  context, Colors.red, 'Введите город!');
                            } else {
                              collectionReference.update({
                                'name': nameMeet.text
                                    .split(RegExp(r"(?! )\s{2,}"))
                                    .join(' ')
                                    .split(RegExp(r"\s+$"))
                                    .join(''),
                                'city': city.text
                                    .split(RegExp(r"(?! )\s{2,}"))
                                    .join(' ')
                                    .split(RegExp(r"\s+$"))
                                    .join(''),
                                'description': description.text,
                                'datetime': dateTime,
                                'admin': firebaseAuth.currentUser!.uid,
                                'type': _type != '' ? _type : 'групповая',
                                'users': [firebaseAuth.currentUser!.uid],
                                'recentMessage': '',
                                'recentMessageSender': '',
                                'timeStamp': DateTime.now(),
                              });
                              nextScreenReplace(context, const MeetingPage());
                            }

                            setState(() {
                              nameMeet.clear();
                              city.clear();
                              description.clear();
                              dateAndTime.clear();
                            });
                          },
                          child: const Text(
                            "Сохранить",
                            style: TextStyle(
                                fontSize: 20, color: Colors.orangeAccent),
                          )),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor:
                                      Colors.grey.shade700.withOpacity(0.7),
                                  title: const Text(
                                    'Удалить встречу?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  titleTextStyle:
                                      const TextStyle(color: Colors.white),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Отмена',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        collectionReference.delete();
                                        nextScreenReplace(
                                            context, const MeetingPage());
                                      },
                                      child: const Text('Удалить',
                                          style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 20)),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: const Text('Удалить',
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 20)),
                      ),
                    ],
                  )
                ],
              )),
            ),
          ),
        ),
      ],
    );
  }
}
