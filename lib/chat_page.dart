import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Service'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildReceivedMessage(
                    'Hi, how are you today, are there any improvements?',
                    '7:00',
                    context),
                _buildSentMessage(
                    "It's gotten worse, I keep thinking weird things",
                    '7:00',
                    context),
                _buildReceivedMessage(
                    'Do not panic, would you like us to have a session?',
                    '7:00',
                    context),
                _buildSentMessage(
                    "Yes please, there's no other person I can talk to, I need help before I go crazy",
                    '7:01',
                    context),
                _buildReceivedMessage(
                    'I have free time today at noon, can you come over at 4pm?',
                    '7:01',
                    context),
                _buildSentMessage(
                    "Yes please, that's totally fine with me I will come at 4pm to attend your session, thank you so much",
                    '7:02',
                    context),
                _buildReceivedMessage(
                    "Take care and don't take any type of stress",
                    '7:04',
                    context),
              ],
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(
      String message, String time, BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 5.0),
            Text(
              time,
              style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentMessage(String message, String time, BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.all(8.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
            SizedBox(height: 5.0),
            Text(
              time,
              style: TextStyle(fontSize: 10.0, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: Colors.red,
            child: IconButton(
              icon: Icon(Icons.mic, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
