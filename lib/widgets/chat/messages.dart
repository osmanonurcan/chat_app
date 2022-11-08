import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data?.docs;
        final user = FirebaseAuth.instance.currentUser!;

        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            chatDocs?[index]['text'],
            chatDocs?[index]['userId'] == user.uid,
            chatDocs?[index]['username'],
            chatDocs?[index]['userImage'],
            key: ValueKey(chatDocs?[index].id ?? DateTime.now()),
          ),
          itemCount: chatDocs?.length,
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
    );
  }
}
