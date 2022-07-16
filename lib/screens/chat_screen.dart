import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String route = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  bool onlySpaces() {
    return messageText.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: kBodyText2Color),
                      minLines: 1,
                      maxLines: 4,
                      controller: _controller,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      if (!onlySpaces()) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'timeStamp': FieldValue.serverTimestamp(),
                        });
                        _controller.clear();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('No messages'),
            );
          }
          return Expanded(
            child: ListView(reverse: true, children: [
              for (int index = 0; index < snapshot.data!.docs.length; index++)
                MessageBubble(
                  sender: snapshot.data!.docs.elementAt(index)['sender'],
                  text: snapshot.data!.docs.elementAt(index)['text'],
                  lastSender: index < snapshot.data!.docs.length - 1
                      ? snapshot.data!.docs.elementAt(index + 1)['sender']
                      : '',
                  nextSender: index > 0
                      ? snapshot.data!.docs.elementAt(index - 1)['sender']
                      : '',
                ),
            ]),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final String lastSender;
  final String nextSender;
  final bool isSameLast;
  final bool isSameNext;
  final bool isMe;

  MessageBubble(
      {required this.sender,
      required this.text,
      required this.lastSender,
      required this.nextSender})
      : this.isMe = sender == loggedInUser.email,
        this.isSameLast = sender.compareTo(lastSender) == 0,
        this.isSameNext = sender.compareTo(nextSender) == 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: isMe ? 10 : 50,
          left: isMe ? 50 : 10,
          bottom: isSameNext ? 5 : 10,
          top: isSameLast ? 0 : 10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isSameLast)
            Padding(
              padding:
                  EdgeInsets.only(right: isMe ? 10 : 0, left: isMe ? 0 : 10),
              child: Text(
                sender,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          Material(
            color: isMe ? Colors.lightBlueAccent : Colors.blueGrey,
            elevation: 3,
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(30) : Radius.circular(0),
              topRight: isMe ? Radius.circular(0) : Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
