import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageTile extends StatefulWidget {
  final DocumentSnapshot message;
  final String sender;
  final String chatId;
  final String name;
  final bool sentByMe;
  final bool isRead;


  const MessageTile(
      {Key? key,
      required this.message,
      required this.chatId,
      required this.sender,
      required this.sentByMe,
      required this.isRead,
      required this.name})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  var _tapPosition;

  @override
  void initState() {
    super.initState();
    _tapPosition = Offset(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final DocumentReference _firestore = FirebaseFirestore.instance.collection(
        'chats').doc(widget.chatId);
    Size size = MediaQuery
        .of(context)
        .size;

    void _storePosition(TapDownDetails details) {
      _tapPosition = details.globalPosition;
    }

    final TextEditingController _replyController = TextEditingController();
    String _selectedMessageId = '';
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<void> _sendMessage(String message) async {
      final user = _auth.currentUser;
      if (user != null) {
        final messageRef = _firestore.collection('messages').doc();
        await messageRef.set({
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'replyToMessageId':
          _selectedMessageId.isNotEmpty ? _selectedMessageId : null,
        });
        _selectedMessageId = '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сообщение отправлено.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Вы должны авторизоваться, чтобы отправить сообщение'),
          ),
        );
      }
    }

    Future<void> _deleteMessage(String messageId) async {
      final user = _auth.currentUser;
      if (user != null) {
        final messageSnapshot =
        await _firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          await _firestore.collection('chats').doc(widget.message.id).update({
            'deleteFor':FirebaseAuth.instance.currentUser!.uid
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Сообщение удалено.'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Вы можете удалять только свои сообщения.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Чтобы удалить сообщение, необходимо войти.'),
          ),
        );
      }
    }

    Future<void> _replyToMessage(String messageId) async {
      setState(() {
        _selectedMessageId = widget.message.id;
      });
      _replyController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Написать ответ'),
            content: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                labelText: 'Напишите свой ответ',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  _sendMessage(_replyController.text);
                  Navigator.pop(context);
                },
                child: Text('Ответить'),
              ),
            ],
          );
        },
      );
    }

    Future<void> _editMessage(String messageId) async {
      final user = _auth.currentUser;
      if (user != null) {
        final messageSnapshot =
        await _firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          final messageText = messageSnapshot.data()!['message'];
          final newMessageText = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              final controller = TextEditingController(text: messageText);
              return AlertDialog(
                title: Text('Редактировать сообщение'),
                content: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'Редактировать сообщение',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Отмена'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: Text('Сохранить'),
                  ),
                ],
              );
            },
          );

          if (newMessageText != null && newMessageText != messageText) {
            await _firestore.collection('chats').doc(widget.message.id).update({
              'message': newMessageText,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Сообщение успешно отредактировано'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Вы можете редактировать только свои сообщения.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Чтобы отредактировать сообщение, необходимо войти'),
          ),
        );
      }
    }

    Future<void> _copyMessage(String message) async {
      await Clipboard.setData(ClipboardData(text: message));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Сообщение скопировано в буфер обмена.'),
        ),
      );
    }

    Future<void> _deleteMessageForEveryone(String messageId) async {
      final user = _auth.currentUser;
      if (user != null) {
        final messageSnapshot =
        await _firestore.collection('chats').doc(widget.message.id).get();
        if (messageSnapshot.exists &&
            messageSnapshot.data()!['sendByID'] == user.uid) {
          final sentTime = messageSnapshot.data()!['ts'].toDate();
          final timeSinceMessageSent = DateTime.now().difference(sentTime);
          final int timeLimit = 10; // В минутах
          if (timeSinceMessageSent.inMinutes <= timeLimit) {
            await _firestore.collection('chats').doc(widget.message.id).delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Сообщение удалено для всех.'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Удалить сообщение для всех можно только в течение 10 минут после его отправки..'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Вы можете удалять только свои собственные сообщения для всех.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Вы должны быть авторизованы, чтобы удалить сообщение для всех.'),
          ),
        );
      }
    }

    _showPopupMenu() async {
      final RenderObject? overlay = Overlay
          .of(context)
          .context
          .findRenderObject();

      await showMenu(
        context: context,
        position: RelativeRect.fromRect(
            _tapPosition & Size(40, 40), // smaller rect, the touch area
            Offset.zero & overlay!.semanticBounds
                .size // Bigger rect, the entire screen
        ),
        items: [

          PopupMenuItem<String>(
            value: 'reply',
            onTap: () {
              _replyToMessage(widget.message.id);
            },
            child: Text('Ответить'),
          ),
          PopupMenuItem<String>(
            value: 'edit',
            onTap: () {
              _editMessage(widget.message.id);
            },
            child: Text('Редактировать'),
          ),
          PopupMenuItem<String>(
            value: 'copy',
            onTap: () {
              _copyMessage(widget.message['message']);
            },
            child: Text('Копировать'),
          ),
          PopupMenuItem<String>(
            value: 'delete_me',
            onTap: () {
              _deleteMessage(widget.message.id);
            },
            child: Text('Удалить у меня'),
          ),
          PopupMenuItem<String>(
            value: 'delete_everyone',
            onTap: () {
              _deleteMessageForEveryone(widget.message.id);
            },
            child: Text('Удалить для всех'),
          ),

        ],
        elevation: 8.0,
      );
    }

    return GestureDetector(
      onTapDown: _storePosition,
      onLongPress: () {
        _showPopupMenu();
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: widget.sentByMe ? 0 : 24,
            right: widget.sentByMe ? 24 : 0),
        alignment:
        widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.7),
          margin: widget.sentByMe
              ? const EdgeInsets.only(left: 30)
              : const EdgeInsets.only(right: 30),
          padding:
          const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
              color: widget.sentByMe ? Colors.orangeAccent : Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name.toUpperCase(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: -0.5),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(widget.message['message'],
                        textAlign: TextAlign.start,
                        style:
                        const TextStyle(fontSize: 16, color: Colors.black)),
                  ),
                  widget.sentByMe
                      ? const SizedBox(
                    width: 10,
                  )
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
                ],
              )
              // widget.isRead
              //     ? const FaIcon(FontAwesomeIcons.check)
              //     : const FaIcon(FontAwesomeIcons.check),
            ],
          ),
        ),
      ),
    );
  }
}
