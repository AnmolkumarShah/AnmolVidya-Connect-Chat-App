import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './messageBubble.dart';

class Message extends StatelessWidget {
  const Message({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data.docs;
        print(chatDocs);
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            chatDocs[i]['text'],
            chatDocs[i]['userId'],
            chatDocs[i]['userId'] == FirebaseAuth.instance.currentUser.uid,
            chatDocs[i]['userImage'],
            ValueKey(
              chatDocs[i].documentID,
            ),
          ),
        );
      },
    );
  }
}
