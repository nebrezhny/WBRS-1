// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:wbrs/app/helper/global.dart';
import 'package:wbrs/presentation/screens/list_of_users/show/somebody_profile.dart';
import 'package:wbrs/presentation/screens/shop/shop.dart';
import 'package:wbrs/service/database_service.dart';
import 'package:wbrs/app/widgets/widgets.dart';

class MessageTile extends StatefulWidget {
  final DocumentSnapshot message;
  final String sender;
  final String chatId;
  final String name;
  final bool sentByMe;
  final bool isRead;
  final Widget? avatar;
  final bool isChat;

  const MessageTile(
      {super.key,
      required this.message,
      required this.chatId,
      required this.sender,
      required this.sentByMe,
      required this.isRead,
      required this.name,
      this.avatar,
      required this.isChat});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  Offset? _tapPosition;
  bool isMessage = true, isReply = false, isTs = false, isGroup = false;
  Timestamp time = Timestamp.fromDate(DateTime.now());
  Map msg = {};

  @override
  void initState() {
    super.initState();
    _tapPosition = const Offset(0.0, 0.0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    msg = widget.message.data() as Map<String, dynamic>;
    setState(() {
      isMessage = msg.containsKey('message');
      isReply = msg.containsKey('replyMessage');
      isGroup = !widget.isChat;
      isTs = msg.containsKey('ts');
      time = isTs ? widget.message['ts'] : widget.message['time'];
    });
    final DocumentReference firestore =
        firebaseFirestore.collection('chats').doc(widget.chatId);
    Size size = MediaQuery.of(context).size;

    void storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

    final TextEditingController replyController = TextEditingController();
    final FirebaseAuth auth = firebaseAuth;

    Future<void> sendMessage(String message, Map replyMsg) async {
      final user = auth.currentUser;
      if (user != null) {
        final messageRef = {
          'message': message,
          'sender': user.uid,
          'avatar': user.photoURL,
          'name': user.displayName,
          'replyMessage': replyMsg,
          'sendByID': user.uid,
          'isRead': true,
          'sendBy': user.displayName,
        };
        if (!isGroup) {
          messageRef.addAll({'ts': FieldValue.serverTimestamp()});
          DatabaseService()
              .addMessage(widget.chatId, randomNumeric(12), messageRef);
        } else {
          messageRef.addAll({'time': FieldValue.serverTimestamp()});
          DatabaseService().sendMessageGroup(widget.chatId, messageRef);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сообщение отправлено.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Вы должны авторизоваться, чтобы отправить сообщение'),
          ),
        );
      }
    }

    Future<void> deleteMessage(String messageId) async {
      final user = auth.currentUser;
      if (user != null) {
        final messageSnapshot =
            await firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          await firestore
              .collection('chats')
              .doc(widget.message.id)
              .update({'deleteFor': firebaseAuth.currentUser!.uid});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Сообщение удалено.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вы можете удалять только свои сообщения.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Чтобы удалить сообщение, необходимо войти.'),
          ),
        );
      }
    }

    Future<void> replyToMessage(Map message) async {
      setState(() {});
      replyController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: grey,
            title: const Text('Написать ответ'),
            titleTextStyle: const TextStyle(color: Colors.white),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: replyController,
                minLines: 1,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Напишите свой ответ',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Отмена',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  sendMessage(replyController.text, message);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ответить',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    Future<void> editMessage(String messageId) async {
      final user = auth.currentUser;
      if (user != null) {
        final messageSnapshot =
            await firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          final messageText = messageSnapshot.data()!['message'];
          final newMessageText = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              final controller = TextEditingController(text: messageText);
              return AlertDialog(
                title: const Text('Редактировать сообщение'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Редактировать сообщение',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: const Text('Сохранить'),
                  ),
                ],
              );
            },
          );

          if (newMessageText != null && newMessageText != messageText) {
            await firestore.collection('chats').doc(widget.message.id).update({
              'message': newMessageText,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Сообщение успешно отредактировано'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вы можете редактировать только свои сообщения.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Чтобы отредактировать сообщение, необходимо войти'),
          ),
        );
      }
    }

    Future<void> copyMessage(String message) async {
      await Clipboard.setData(ClipboardData(text: message));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сообщение скопировано в буфер обмена.'),
        ),
      );
    }

    Future<void> deleteMessageForEveryone(String messageId) async {
      final user = auth.currentUser;
      if (user != null) {
        final messageSnapshot =
            await firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          final sentTime = messageSnapshot.data()!['ts'].toDate();
          final timeSinceMessageSent = DateTime.now().difference(sentTime);
          const int timeLimit = 2; // В минутах
          if (timeSinceMessageSent.inDays <= timeLimit) {
            await firestore.collection('chats').doc(widget.message.id).delete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Сообщение удалено для всех.'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Удалить сообщение для всех можно только в течение 2 дней после его отправки..'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Вы можете удалять только свои собственные сообщения для всех.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Вы должны быть авторизованы, чтобы удалить сообщение для всех.'),
          ),
        );
      }
    }

    showPopupMenu() async {
      final RenderObject? overlay =
          Overlay.of(context).context.findRenderObject();

      await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            _tapPosition! & const Size(40, 40), // smaller rect, the touch area
            Offset.zero &
                overlay!.semanticBounds.size // Bigger rect, the entire screen
            ),
        items: isMessage
            ? [
                PopupMenuItem<String>(
                  value: 'reply',
                  onTap: () {
                    replyToMessage(
                        widget.message.data() as Map<String, dynamic>);
                  },
                  child: const Text('Ответить'),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  onTap: () {
                    editMessage(widget.message.id);
                  },
                  child: const Text('Редактировать'),
                ),
                PopupMenuItem<String>(
                  value: 'copy',
                  onTap: () {
                    copyMessage(widget.message['message']);
                  },
                  child: const Text('Копировать'),
                ),
                PopupMenuItem<String>(
                  value: 'delete_me',
                  onTap: () {
                    deleteMessage(widget.message.id);
                  },
                  child: const Text('Удалить у меня'),
                ),
                PopupMenuItem<String>(
                  value: 'delete_everyone',
                  onTap: () {
                    deleteMessageForEveryone(widget.message.id);
                  },
                  child: const Text('Удалить для всех'),
                ),
              ]
            : [
                PopupMenuItem<String>(
                  value: 'delete_me',
                  onTap: () {
                    deleteMessage(widget.message.id);
                  },
                  child: const Text('Удалить у меня'),
                ),
                PopupMenuItem<String>(
                  value: 'delete_everyone',
                  onTap: () {
                    deleteMessageForEveryone(widget.message.id);
                  },
                  child: const Text('Удалить для всех'),
                ),
              ],
        elevation: 8.0,
      );
    }

    return GestureDetector(
      onTapDown: storePosition,
      onLongPress: () {
        showPopupMenu();
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: widget.sentByMe ? 0 : 15,
            right: widget.sentByMe ? 24 : 0),
        alignment:
            widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.sentByMe
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () async {
                      final userInfo = await firebaseFirestore
                          .collection('users')
                          .doc(widget.sender)
                          .get();

                      nextScreen(
                          context,
                          SomebodyProfile(
                              uid: widget.sender,
                              photoUrl: userInfo.get('profilePic'),
                              name: widget.name,
                              userInfo: userInfo.data() as Map));
                    },
                    child: widget.avatar ?? const SizedBox.shrink()),
            const SizedBox(
              width: 5,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.74),
              margin: widget.sentByMe
                  ? const EdgeInsets.only(left: 30)
                  : const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: widget.sentByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                  color: widget.sentByMe
                      ? orange90
                      : grey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name.toUpperCase(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5),
                  ),
                  isReply
                      ? IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const VerticalDivider(
                                width: 4,
                                color: Colors.white,
                                thickness: 2,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    isGroup
                                        ? msg['replyMessage']['name']
                                        : msg['replyMessage']['sendBy'],
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.6,
                                    child: Text(
                                      msg['replyMessage']['message'],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: isMessage
                            ? Text(widget.message['message'],
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white))
                            : GestureDetector(
                                onTap: () {
                                  if (widget.sentByMe) {
                                    nextScreenReplace(
                                        context,
                                        const ShopPage(
                                          tabIndex: 1,
                                        ));
                                  } else {
                                    nextScreenReplace(
                                        context,
                                        const ShopPage(
                                          tabIndex: 0,
                                        ));
                                  }
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      widget.message['image'],
                                    ),
                                    Text(widget.message['name'],
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ],
                                )),
                      ),
                      widget.sentByMe
                          ? const SizedBox.shrink()
                          : const SizedBox(),
                      widget.sentByMe
                          ? widget.isRead
                              ? const FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 15,
                                  color: Colors.greenAccent,
                                )
                              : const FaIcon(
                                  FontAwesomeIcons.check,
                                  size: 15,
                                  color: Colors.grey,
                                )
                          : const SizedBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${time.toDate().hour}:${time.toDate().minute < 10 ? '0${time.toDate().minute}' : time.toDate().minute}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
