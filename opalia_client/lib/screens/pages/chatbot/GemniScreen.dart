import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'Message.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  TextEditingController _userPrompt = TextEditingController();
  final apikey = "AIzaSyBC-phQ1tI4EF-O5mRklJuNOrxkX6aMzOw";
  final List<Message> _messages = [];
  Future<void> talkwithGemini() async {
    final userMsg = _userPrompt.text;
    setState(() {
      _messages.add(
        Message(isUser: true, message: userMsg, date: DateTime.now()),
      );
    });

    final model = GenerativeModel(
      apiKey: apikey,
      model: 'gemini-pro',
    );

    final content = Content.text(userMsg);
    final response = await model.generateContent([content]);
    setState(() {
      _messages.add(
        Message(
            isUser: false, message: response.text ?? "", date: DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        title: Text(
          'chatter avec votre assistant personel',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Messages(
                        isUser: message.isUser,
                        message: message.message,
                        date: DateFormat('HH:mm').format(message.date));
                  })),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 15,
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _userPrompt,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        label: Text('Entrer votre message')),
                  ),
                ),
                Spacer(),
                IconButton(
                    iconSize: 30,
                    padding: EdgeInsets.all(12),
                    color: Colors.red,
                    onPressed: () {
                      talkwithGemini();
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
