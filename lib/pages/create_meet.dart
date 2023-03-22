import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/widgets.dart';

class CreateMeetPage extends StatefulWidget {
  const CreateMeetPage({super.key});

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

class _CreateMeetPageState extends State<CreateMeetPage> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('meets');

  TextEditingController name_meet = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date_and_time = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
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
                controller: name_meet,
                decoration: const InputDecoration(
                    hintText: 'Введите название встречи',
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: city,
                decoration: const InputDecoration(
                    hintText: 'Введите город встречи',
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                maxLength: 300,
                controller: description,
                decoration: const InputDecoration(
                    hintText: 'Введите краткое описание встречи',
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedDate.month > 10
                      ? 'Дата: ${selectedDate.day}.${selectedDate.month}.${selectedDate.year}'
                      : 'Дата: ${selectedDate.day}.0${selectedDate.month}.${selectedDate.year}'),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: const Text('Выбрать дату')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(selectedTime.hour > 10
                      ? selectedTime.minute > 10
                          ? 'Время: ${selectedTime.hour}:${selectedTime.minute}'
                          : 'Время: ${selectedTime.hour}:0${selectedTime.minute}'
                      : selectedTime.minute > 10
                          ? 'Время: 0${selectedTime.hour}:${selectedTime.minute}'
                          : 'Время: 0${selectedTime.hour}:0${selectedTime.minute}'),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent),
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: const Text('Выбрать время')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                items:
                    <String>['индивидуальная', 'групповая'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _type = value;
                  });
                },
                decoration: const InputDecoration(border: InputBorder.none),
                value: _type,
              ),
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

                    var date_time =
                        '$day.$month.${selectedDate.year} $hour:$minute';
                    if (name_meet.text == '') {
                      showSnackbar(context, Colors.red, 'Введите название!');
                    }
                    if (city.text == '') {
                      showSnackbar(context, Colors.red, 'Введите город!');
                    } else {
                      collectionReference.add({
                        'name': name_meet.text,
                        'city': city.text,
                        'description': description.text,
                        'datetime': date_time,
                        'admin': FirebaseAuth.instance.currentUser!.uid,
                        'type': _type != '' ? _type : 'групповая',
                        'users': [FirebaseAuth.instance.currentUser!.uid],
                        'recentMessage': '',
                        'recentMessageSender': '',
                      });
                      Navigator.pop(context);
                    }

                    setState(() {
                      name_meet.clear();
                      city.clear();
                      description.clear();
                      date_and_time.clear();
                    });
                  },
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(fontSize: 20, color: Colors.orangeAccent),
                  ))
            ],
          )),
        ),
      ),
    );
  }
}
