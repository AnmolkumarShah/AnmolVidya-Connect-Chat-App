import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../Widget/messages.dart';
import '../Widget/sender.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    });
    fbm.subscribeToTopic('chat');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AnmolVidya Connect!"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Logout"),
                    ],
                  ),
                ),
              )
            ],
            onChanged: (identifier) {
              if (identifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Message(),
            ),
            Sender(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/s8wZQLg63mjBk2w12AE1/messages')
      //         .add({
      //       'text': 'this was added by clicking the button!',
      //     });
      //   },
      // ),
    );
  }
}
