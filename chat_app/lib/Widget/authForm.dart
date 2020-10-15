import 'package:flutter/material.dart';
import 'dart:io';

import '../Widget/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool loading;
  final void Function(
    String email,
    String username,
    File userImage,
    String passeord,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  AuthForm(this.submitFn, this.loading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userPassword = '';
  String _userName = '';
  File _userImage;

  void _pickImage(File image) {
    _userImage = image;
  }

  var _isLogin = true;

  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _trySubmitForm() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an User Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState.save();
    }

    widget.submitFn(
      _userEmail.trim(),
      _userName.trim(),
      _userImage,
      _userPassword.trim(),
      _isLogin,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickImage),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return "Please enter a valid Email Address";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_usernameFocusNode);
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email address",
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return "Username must be at least 4 characters long";
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      focusNode: _usernameFocusNode,
                      onSaved: (newValue) {
                        _userName = newValue;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return "Password must be at least 6 characters long";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue;
                    },
                    focusNode: _passwordFocusNode,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.loading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!widget.loading)
                    RaisedButton(
                      onPressed: _trySubmitForm,
                      child: Text(
                        _isLogin ? "Login" : "Signup",
                      ),
                    ),
                  if (!widget.loading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? "Create a new Account"
                          : "I already have an account"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
