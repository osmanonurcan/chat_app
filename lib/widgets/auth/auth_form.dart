import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);

  final void Function(
    String email,
    String username,
    String password,
    XFile? imageFile,
    bool isLogin,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var isLogin = true;

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  XFile? _userImageXFile;

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_userImageXFile == null && !isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick a valid image'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid != null && isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageXFile,
        isLogin,
      );
    }
  }

  void _pickedImage(XFile? pickedImage) {
    _userImageXFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLogin) UserImagePicker(_pickedImage),
              TextFormField(
                key: ValueKey('email'),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _userEmail = newValue!;
                },
              ),
              if (!isLogin)
                TextFormField(
                  key: ValueKey('username'),
                  decoration: InputDecoration(labelText: 'Usename'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 4) {
                      return 'Username must be at least 4 char';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _userName = newValue!;
                  },
                ),
              TextFormField(
                key: ValueKey('password'),
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 7) {
                    return 'Password must be at least 7 char';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _userPassword = newValue!;
                },
              ),
              SizedBox(
                height: 12,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(isLogin ? 'Login' : 'Signup')),
              if (!widget.isLoading)
                TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                        isLogin ? 'Create New Acoount' : 'I have an account'))
            ],
          ),
        ),
      ),
    ));
  }
}
