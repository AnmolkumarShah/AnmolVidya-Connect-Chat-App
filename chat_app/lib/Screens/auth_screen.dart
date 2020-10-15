import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

import '../Widget/authForm.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuth(
    String email,
    String username,
    File userImage,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authresult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authresult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authresult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('users_image')
            .child(authresult.user.uid + '.jpg');

        await ref.putFile(userImage).onComplete;

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authresult.user.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': url,
        });
      }
    } catch (err) {
      var message = "An error occured,please check your credentials";
      if (err != null) {
        message = err.message;
        setState(() {
          _isLoading = false;
        });
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).errorColor,
          content: Text(message),
        ),
      );
    }
    // catch (err) {
    //   print("Anmol $err");
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuth, _isLoading),
    );
  }
}
