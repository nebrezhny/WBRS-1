import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/app/helper/helper_function.dart';
import 'package:wbrs/app/pages/filter_pages/cities.dart';
import 'package:wbrs/presentations/screens/list_of_meets/meetings.dart';

import '../../../service/notifications.dart';
import '../../../app/widgets/widgets.dart';

class CreateMeetPage extends StatefulWidget {
  const CreateMeetPage({super.key});

  @override
  State<CreateMeetPage> createState() => _CreateMeetPageState();
}

class _CreateMeetPageState extends State<CreateMeetPage> {
  CollectionReference collectionReference =
      firebaseFirestore.collection('meets');

  TextEditingController nameMeet = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController dateAndTime = TextEditingController();

  String? _type = 'групповая';

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool loading = false;

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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(boxShadow: []),
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
            backgroundColor: Colors.orangeAccent,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                  child: loading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5)),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Autocomplete<String>(
                              optionsMaxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                              optionsViewBuilder:
                                  (context, onSelected, options) {
                                return cityDropdown(
                                    context, options, onSelected);
                              },
                              optionsBuilder: (textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return [];
                                }
                                return cities
                                    .where((city) => city
                                        .toLowerCase()
                                        .startsWith(textEditingValue.text
                                            .toLowerCase()))
                                    .toList()
                                  ..sort((a, b) => a.compareTo(b));
                              },
                              onSelected: (String val) {
                                setState(() {
                                  city.text = val
                                      .split(RegExp(r'(?! )\s{2,}'))
                                      .join(' ')
                                      .split(RegExp(r'\s+$'))
                                      .join('');
                                });
                              },
                              fieldViewBuilder: (context, controller, focusNode,
                                  onSubmitted) {
                                return TextField(
                                  style: const TextStyle(color: Colors.white),
                                  controller: controller,
                                  focusNode: focusNode,
                                  onChanged: (value) {
                                    city.text = value;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Введите название города',
                                      fillColor: Colors.white,
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 5)),
                                );
                              },
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
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 5)),
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
                              onChanged: (String? value) {
                                setState(() {
                                  _type = value;
                                });
                              },
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              value: _type,
                            ),
                            TextButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  var day = selectedDate.day > 9
                                      ? selectedDate.day
                                      : '0${selectedDate.day}';
                                  var month = selectedDate.month > 9
                                      ? selectedDate.month
                                      : '0${selectedDate.month}';
                                  var hour = selectedTime.hour > 9
                                      ? selectedTime.hour
                                      : '0${selectedTime.hour}';
                                  var minute = selectedTime.minute > 9
                                      ? selectedTime.minute
                                      : '0${selectedTime.minute}';

                                  var dateTime =
                                      '$day.$month.${selectedDate.year} $hour:$minute';
                                  if (nameMeet.text == '') {
                                    showSnackbar(context, Colors.red,
                                        'Введите название!');
                                  }
                                  if (city.text == '') {
                                    showSnackbar(
                                        context, Colors.red, 'Введите город!');
                                  } else {
                                    collectionReference.add({
                                      'timeStamp': DateTime.now(),
                                      'name': nameMeet.text
                                          .split(RegExp(r'(?! )\s{2,}'))
                                          .join(' ')
                                          .split(RegExp(r'\s+$'))
                                          .join(''),
                                      'city': city.text,
                                      'description': description.text,
                                      'datetime': dateTime,
                                      'admin': firebaseAuth.currentUser!.uid,
                                      'type': _type != '' ? _type : 'групповая',
                                      'users': [firebaseAuth.currentUser!.uid],
                                      'recentMessage': '',
                                      'recentMessageSender': '',
                                    });
                                    QuerySnapshot users =
                                        await firebaseFirestore
                                            .collection('users')
                                            .where('city', isEqualTo: city.text)
                                            .get();
                                    for (var user in users.docs) {
                                      String token = await firebaseFirestore
                                          .collection('TOKENS')
                                          .doc(user.id)
                                          .get()
                                          .then((value) => value.get('token'));
                                      if (token == '') break;
                                      NotificationsService().sendPushMessage(
                                          token,
                                          {
                                            'isChat': false,
                                            'chatId': '',
                                            'title': nameMeet.text,
                                            'message':
                                                'Назначена новая встреча в вашем городе',
                                          },
                                          nameMeet.text,
                                          1,
                                          '');
                                    }
                                    if (context.mounted) {
                                      nextScreenReplace(context, MeetingPage());
                                    }
                                  }

                                  setState(() {
                                    nameMeet.clear();
                                    city.clear();
                                    description.clear();
                                    dateAndTime.clear();
                                  });
                                  setState(() {
                                    loading = false;
                                  });
                                },
                                child: const Text(
                                  'Сохранить',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.orangeAccent),
                                ))
                          ],
                        )),
            ),
          ),
        ),
      ],
    );
  }
}
