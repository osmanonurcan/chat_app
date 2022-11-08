import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _entryMessage = '';
  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _entryMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text(
                  'Send a message..',
                  // style: TextStyle(
                  //   color: Theme.of(context).primaryColor,
                  // ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _entryMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _entryMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
            ),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
