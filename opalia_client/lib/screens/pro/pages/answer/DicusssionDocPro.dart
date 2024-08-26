import 'package:flutter/material.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';
import 'package:opalia_client/services/remote/websocketService.dart'; // Import WebSocketService
import '../../../../models/answer.dart';
import '../../../../models/posequestion.dart';
import 'DonnerAnswer.dart';

class DicusssionDocPro extends StatefulWidget {
  const DicusssionDocPro({super.key});

  @override
  State<DicusssionDocPro> createState() => _DicusssionDocProState();
}

class _DicusssionDocProState extends State<DicusssionDocPro> {
  late Future<List<PoseQuestion>?> _questions;
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(); // Initialize WebSocketService
    _webSocketService.socket.on('new_question', (data) {
      print('New question received: $data');
      _loadQuestions(); // Refresh questions when a new one is received
    });
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _questions = ApiServicePro.getAllQuestions();
    });
  }

  @override
  void dispose() {
    _webSocketService.reconnect(); // Dispose WebSocketService
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: FutureBuilder<List<PoseQuestion>?>(
          future: _questions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No questions found'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final question = snapshot.data![index];
                  return ListTile(
                    leading: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(
                          question.patientId?.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50);
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      '${question.patientId!.name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(question.question!, maxLines: 2),
                    trailing: Numberasnwser(questionId: question.id!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DonnerAnswer(questionId: question.id!),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Numberasnwser extends StatefulWidget {
  final String questionId;

  const Numberasnwser({super.key, required this.questionId});

  @override
  State<Numberasnwser> createState() => _NumberasnwserState();
}

class _NumberasnwserState extends State<Numberasnwser> {
  late Future<List<Answer>?> _reponse;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    setState(() {
      _reponse = ApiServicePro.getAllAnswerss(widget.questionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Answer>?>(
      future: _reponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == 0) {
          return Text('No answers yet');
        } else {
          return Text('${snapshot.data!.length} answers');
        }
      },
    );
  }
}
