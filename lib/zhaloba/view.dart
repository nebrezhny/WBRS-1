// import 'dart:io';
//
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
//
//
// class ComplaintForm extends StatefulWidget {
//   const ComplaintForm({Key? key}) : super(key: key);
//
//   @override
//   _ComplaintFormState createState() => _ComplaintFormState();
// }
//
// class _ComplaintFormState extends State<ComplaintForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _violatorIdController = TextEditingController();
//   final _violationTypeController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   XFile? _image;
//
//   Future<void> sendComplaint(String violatorId, String violationType, String description, String imageUrl) async {
//     final Email email = Email(
//       body: 'Идентификатор нарушителя: $violatorId\nТип нарушения: $violationType\nОписание жалобы: $description\nСкриншот: $imageUrl',
//       subject: 'Новая жалоба на нарушителя',
//       recipients: ['den.dmitriev.2017@inbox.ru'],
//       isHTML: false,
//     );
//
//     await FlutterEmailSender.send(email);
//   }
//
//   @override
//   void dispose() {
//     _violatorIdController.dispose();
//     _violationTypeController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _submitComplaint() async {
//     if (_formKey.currentState!.validate()) {
//       if (_image == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Пожалуйста, добавьте скриншот для подтверждения жалобы')),
//         );
//         return;
//       }
//
//       final violatorId = _violatorIdController.text;
//       final violationType = _violationTypeController.text;
//       final description = _descriptionController.text;
//       final complaint = {
//         'violatorId': violatorId,
//         'violationType': violationType,
//         'description': description,
//       };
//
//       try {
//         final imageUrl = await _uploadImage(_image!);
//         complaint['imageUrl'] = imageUrl;
//
//         sendComplaint(violatorId, violationType, description, imageUrl);
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Жалоба успешно отправлена')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Ошибка: $e')),
//         );
//       }
//     }
//   }
//
//   Future<String> _uploadImage(XFile imageFile) async {
//     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     final firebase_storage.Reference reference =
//     firebase_storage.FirebaseStorage.instance.ref().child('complaints/$fileName');
//     final uploadTask = reference.putFile(File(imageFile.path));
//     final snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }
//
//   Future<void> _getImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = pickedFile;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.asset(
//           "assets/fon2.jpg",
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.cover,
//         ),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             iconTheme: const IconThemeData(color: Colors.white),
//             title: const Text('Форма жалобы', style: TextStyle(color: Colors.white)),
//             backgroundColor: Colors.transparent,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     controller: _violatorIdController,
//                     decoration: const InputDecoration(
//                       labelText: 'ID нарушителя',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Введите ID нарушителя';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _violationTypeController,
//                     decoration: const InputDecoration(
//                       labelText: 'Тип нарушения',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Введите тип нарушения';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: _descriptionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Описание жалобы',
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Введите описание жалобы';
//                       }
//                       return null;
//                     },
//                     maxLines: 4,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _getImage,
//                     child: const Text('Выбрать скриншот'),
//                   ),
//                   if (_image != null) Image.file(File(_image!.path)),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _submitComplaint,
//                     child: const Text('Отправить жалобу'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
