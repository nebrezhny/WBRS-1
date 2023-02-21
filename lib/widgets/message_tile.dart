import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final String name;
  final bool sentByMe;
  final isRead;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender,
      required this.sentByMe,
      required this.isRead,
      required this.name})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: size.width * 0.7),
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
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
        child: Container(
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
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(widget.message,
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
