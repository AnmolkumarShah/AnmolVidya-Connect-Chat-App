import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String userId;
  final String userImage;
  final Key key;
  MessageBubble(
    this.text,
    this.userId,
    this.isMe,
    this.userImage,
    this.key,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              width: 150,
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.green[100] : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                  bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Loading...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                      return Text(
                        snapshot.data['username'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe
                              ? Colors.black
                              : Theme.of(context)
                                  .accentTextTheme
                                  .headline3
                                  .color,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline3.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          right: isMe ? 120 : null,
          left: isMe ? null : 120,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
            radius: 30,
          ),
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
