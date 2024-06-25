// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
//
// class MessagingScreen extends StatefulWidget {
//   @override
//   _MessagingScreenState createState() => _MessagingScreenState();
// }
//
// class _MessagingScreenState extends State<MessagingScreen> {
//   final TextEditingController _replyController = TextEditingController();
//   String _selectedMessageId = '';
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   Future<void> _sendMessage(String message) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final messageRef = _firestore.collection('messages').doc();
//       await messageRef.set({
//         'text': message,
//         'timestamp': FieldValue.serverTimestamp(),
//         'userId': user.uid,
//         'replyToMessageId':
//             _selectedMessageId.isNotEmpty ? _selectedMessageId : null,
//       });
//       _selectedMessageId = '';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Сообщение отправлено.'),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Вы должны авторизоваться, чтобы отправить сообщение'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _deleteMessage(String messageId) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final messageSnapshot =
//           await _firestore.collection('messages').doc(messageId).get();
//       if (messageSnapshot.exists &&
//           messageSnapshot.data()!['userId'] == user.uid) {
//         await _firestore.collection('messages').doc(messageId).delete();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Сообщение удалено.'),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Вы можете удалять только свои сообщения.'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Чтобы удалить сообщение, необходимо войти.'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _replyToMessage(String messageId) async {
//     setState(() {
//       _selectedMessageId = messageId;
//     });
//     _replyController.clear();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Написать ответ'),
//           content: TextField(
//             controller: _replyController,
//             decoration: InputDecoration(
//               labelText: 'Напишите свой ответ',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Отмена'),
//             ),
//             TextButton(
//               onPressed: () {
//                 _sendMessage(_replyController.text);
//                 Navigator.pop(context);
//               },
//               child: Text('Ответить'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _editMessage(String messageId) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final messageSnapshot =
//           await _firestore.collection('messages').doc(messageId).get();
//       if (messageSnapshot.exists &&
//           messageSnapshot.data()!['userId'] == user.uid) {
//         final messageText = messageSnapshot.data()!['text'];
//         final newMessageText = await showDialog<String>(
//           context: context,
//           builder: (BuildContext context) {
//             final controller = TextEditingController(text: messageText);
//             return AlertDialog(
//               title: Text('Редактировать сообщение'),
//               content: TextField(
//                 controller: controller,
//                 decoration: InputDecoration(
//                   labelText: 'Редактировать сообщение',
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('Отмена'),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, controller.text),
//                   child: Text('Сохранить'),
//                 ),
//               ],
//             );
//           },
//         );
//
//         if (newMessageText != null && newMessageText != messageText) {
//           await _firestore.collection('messages').doc(messageId).update({
//             'text': newMessageText,
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Сообщение успешно отредактировано'),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Вы можете редактировать только свои сообщения.'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Чтобы отредактировать сообщение, необходимо войти'),
//         ),
//       );
//     }
//   }
//
//   Future<void> _copyMessage(String message) async {
//     await Clipboard.setData(ClipboardData(text: message));
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Сообщение скопировано в буфер обмена.'),
//       ),
//     );
//   }
//
//   Future<void> _deleteMessageForEveryone(String messageId) async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final messageSnapshot =
//           await _firestore.collection('messages').doc(messageId).get();
//       if (messageSnapshot.exists &&
//           messageSnapshot.data()!['userId'] == user.uid) {
//         final sentTime = messageSnapshot.data()!['timestamp'].toDate();
//         final timeSinceMessageSent = DateTime.now().difference(sentTime);
//         final int timeLimit = 10; // В минутах
//         if (timeSinceMessageSent.inMinutes <= timeLimit) {
//           await _firestore.collection('messages').doc(messageId).delete();
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Сообщение удалено для всех.'),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                   'Удалить сообщение для всех можно только в течение 10 минут после его отправки..'),
//             ),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//                 'Вы можете удалять только свои собственные сообщения для всех.'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               'Вы должны быть авторизованы, чтобы удалить сообщение для всех.'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Сообщения'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Составить сообщение'),
//                     content: TextField(
//                       controller: _replyController,
//                       decoration: InputDecoration(
//                         labelText: 'Введите ваше сообщение',
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text('Отмена'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           _sendMessage(_replyController.text);
//                           Navigator.pop(context);
//                         },
//                         child: Text('Отправить'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 QueryDocumentSnapshot message = snapshot.data!.docs[index];
//                 return ListTile(
//                   title: Text(message['text']),
//                   subtitle: Text('Sent by: ${message['userId']}'),
//                   trailing: PopupMenuButton<String>(
//                     itemBuilder: (BuildContext context) =>
//                         <PopupMenuEntry<String>>[
//                       PopupMenuItem<String>(
//                         value: 'reply',
//                         child: Text('Ответить'),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'edit',
//                         child: Text('Редактировать'),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'copy',
//                         child: Text('Копировать'),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'delete_me',
//                         child: Text('Удалить у меня'),
//                       ),
//                       PopupMenuItem<String>(
//                         value: 'delete_everyone',
//                         child: Text('Удалить для всех'),
//                       ),
//                     ],
//                     onSelected: (String action) {
//                       switch (action) {
//                         case 'reply':
//                           _replyToMessage(message.id);
//                           break;
//                         case 'edit':
//                           _editMessage(message.id);
//                           break;
//                         case 'copy':
//                           _copyMessage(message['text']);
//                           break;
//                         case 'delete_me':
//                           _deleteMessage(message.id);
//                           break;
//                         case 'delete_everyone':
//                           _deleteMessageForEveryone(message.id);
//                           break;
//                       }
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
