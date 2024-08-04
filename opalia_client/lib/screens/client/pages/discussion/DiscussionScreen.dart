import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/discussion/viewAnswer.dart';
import 'package:opalia_client/services/local/sharedprefutils.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';
import 'package:opalia_client/services/remote/websocketService.dart'; // Import WebSocketService
import '../../../../models/answer.dart';
import '../../../../models/posequestion.dart';

class DicusssionDoc extends StatefulWidget {
  const DicusssionDoc({super.key});

  @override
  State<DicusssionDoc> createState() => _DicusssionDocState();
}

class _DicusssionDocState extends State<DicusssionDoc> {
  late Future<List<PoseQuestion>?> _questions;
  final _questionController = TextEditingController();
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

  Future<void> _submitQuestion() async {
    final question = _questionController.text;

    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    bool success =
        await ApiServicePro.postQuestion(PreferenceUtils.getuserid(), question);

    if (success) {
      _questionController.clear();
      _loadQuestions();
      _webSocketService.send('new_question', {
        // Emit a new question event
        'question': question,
        'patientId': PreferenceUtils.getuserid(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post question')),
      );
    }
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
        centerTitle: true,
        title: Text(
          'Questions',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: [1, 0.1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red.shade50, Colors.white])),
        ),
      ),
      body: Column(
        children: [
          Expanded(
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
                      return Dismissible(
                        background: Container(
                          height: 50,
                          color: Colors.red, // Background color when swiping
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 36,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                        ),
                        key: Key(
                          question.toString(),
                        ),
                        onDismissed: (direction) async {
                          // Remove the item from the data source.
                          await ApiServicePro.deleteQuestion(question.id!);
                          _loadQuestions(); // Refresh the list after deletion
                        },
                        child: ListTile(
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
                          title: Text(question.question!),
                          subtitle: Text(
                            'Asked by Patient: ${question.patientId?.name ?? 'Unknown'}',
                          ),
                          trailing: Numberasnwserss(questionId: question.id!),
                          onTap: () {
                            Get.to(ViewAnswersScreen(
                              questionId: question.id!,
                            ));
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: 'Ta Question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitQuestion,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Numberasnwserss extends StatefulWidget {
  final String questionId;

  const Numberasnwserss({super.key, required this.questionId});

  @override
  State<Numberasnwserss> createState() => _NumberasnwserssState();
}

class _NumberasnwserssState extends State<Numberasnwserss> {
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
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No answers yet');
        } else {
          return Text('${snapshot.data!.length} answers');
        }
      },
    );
  }
}
