import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'Message.dart';
import '../../../../services/remote/apiServicePro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
//   TextEditingController _userPrompt = TextEditingController();
//   final apikey = "AIzaSyBC-phQ1tI4EF-O5mRklJuNOrxkX6aMzOw";
//   final List<Message> _messages = [];

//   @override
//   void initState() {
//     super.initState();
//     // Ajouter un message de bienvenue lorsque le widget est construit
//     _messages.add(
//       Message(
//           isUser: false,
//           message: "Bonjour! Comment puis-je vous aider aujourd'hui?",
//           date: DateTime.now()),
//     );
//   }

//   Future<void> talkwithGemini() async {
//     final userMsg = _userPrompt.text;
//     setState(() {
//       _messages.add(
//         Message(isUser: true, message: userMsg, date: DateTime.now()),
//       );
//     });

//     final model = GenerativeModel(
//       apiKey: apikey,
//       model: 'gemini-pro',
//     );

//     final content = Content.text(userMsg);
//     final response = await model.generateContent([content]);
//     setState(() {
//       _messages.add(
//         Message(
//             isUser: false, message: response.text ?? "", date: DateTime.now()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               stops: [1, 0.1],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Colors.red.shade50, Colors.white],
//             ),
//           ),
//         ),
//         title: Text(
//           'Chatter avec votre conseiller médical',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//               child: ListView.builder(
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index];
//                     return Messages(
//                         isUser: message.isUser,
//                         message: message.message,
//                         date: DateFormat('HH:mm').format(message.date));
//                   })),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 15,
//                   child: TextFormField(
//                     style: TextStyle(color: Colors.black),
//                     controller: _userPrompt,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         label: Text('Entrer votre message')),
//                   ),
//                 ),
//                 Spacer(),
//                 IconButton(
//                     iconSize: 30,
//                     padding: EdgeInsets.all(12),
//                     color: Colors.red,
//                     onPressed: () {
//                       talkwithGemini();
//                     },
//                     icon: Icon(Icons.send))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final String apiUrl =
      'http://192.168.1.25:5000/chat'; // Replace this with your actual Flask server URL.

  void _sendMessage() async {
    String text = _textController.text;
    _textController.clear();

    if (text.isEmpty) return;

    setState(() {
      _messages.add({'user': true, 'text': text});
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({'user': false, 'text': data['response']});
        });
      } else {
        // Handle non-200 status code
        setState(() {
          _messages
              .add({'user': false, 'text': 'Error: Server returned an error.'});
        });
      }
    } catch (e) {
      // Handle network error or other exceptions
      setState(() {
        _messages.add(
            {'user': false, 'text': 'Error: Failed to connect to server.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.1,
        title: Text('Chatter avec votre conseiller médical'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUserMessage = message['user'];

                  return Messages(
                    isUser: isUserMessage,
                    message: message['text'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Écrit ton message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
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
