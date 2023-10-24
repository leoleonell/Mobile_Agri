import 'package:flutter/material.dart';

class Message {
  final String sender;
  final String text;
  final DateTime time;

  Message({required this.sender, required this.text, required this.time});
}


class ChatApp extends StatelessWidget {
  final List<Message> messages = [
    Message(sender: 'Alice', text: 'Bonjour', time: DateTime.now()),
    Message(sender: 'Bob', text: 'Salut ! Comment ça va ?', time: DateTime.now()),
    Message(sender: 'Alice', text: 'Bonjour', time: DateTime.now()),
    Message(sender: 'Bob', text: 'Salut ! Comment ça va ?', time: DateTime.now()),
    Message(sender: 'Alice', text: 'Bonjour', time: DateTime.now()),
    Message(sender: 'Bob', text: 'Salut ! Comment ça va ?', time: DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Discussion'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageWidget(message: messages[index]);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Votre message...'),
              // Add controller and onChanged to handle user input
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              // Add logic to send the message and update the messages list
            },
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;

  MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: message.sender == 'Alice' ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: message.sender == 'Alice' ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            message.sender,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: message.sender == 'Alice' ? Colors.blue : Colors.grey,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(
            message.time.toLocal().toString(),
            style: TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
