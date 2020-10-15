import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sender extends StatefulWidget {
  Sender({Key key}) : super(key: key);

  @override
  _SenderState createState() => _SenderState();
}

class _SenderState extends State<Sender> {
  var _message = '';
  final _controller = new TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userImage': userData['image_url']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Enter Your Message"),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.send),
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
