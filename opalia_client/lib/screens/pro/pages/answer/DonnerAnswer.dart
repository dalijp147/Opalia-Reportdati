import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../../models/AnswerToQuestion.dart';
import '../../../../models/answer.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../../../services/remote/websocketService.dart';
import '../../../client/widgets/Allappwidgets/constant.dart';

class DonnerAnswer extends StatefulWidget {
  final String questionId;

  const DonnerAnswer({super.key, required this.questionId});

  @override
  State<DonnerAnswer> createState() => _DonnerAnswerState();
}

class _DonnerAnswerState extends State<DonnerAnswer> {
  late Future<List<Answer>?> _reponse;
  final _questionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _loadQuestions();

    // Listen for new answers through WebSocket
    _webSocketService.socket.on('new_answer', (data) {
      if (data['questionId'] == widget.questionId) {
        _loadQuestions();
      }
    });
  }

  void _loadQuestions() {
    setState(() {
      _reponse = ApiServicePro.getAllAnswerss(widget.questionId);
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

    bool success = await ApiServicePro.postAnswer(
        PreferenceUtils.getuserid(), question, widget.questionId);

    if (success) {
      _questionController.clear();
      _loadQuestions();
      _webSocketService.send('new_answer', {
        // Emit a new question event
        'answer': question,
        'questionId': widget.questionId,
        'doctorId': PreferenceUtils.getuserid(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit the question')),
      );
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _webSocketService.reconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reponse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
      body: FutureBuilder<List<Answer>?>(
        future: _reponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Pas de reponse'));
          } else {
            return snapshot.data! == null || snapshot.data!.isEmpty
                ? Center(child: Text('pas de Reponse'))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final answer = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Dismissible(
                          background: Container(
                            height: 50,
                            color: Colors.red,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 36,
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                          ),
                          key: Key(answer.toString()),
                          onDismissed: (direction) async {
                            await ApiServicePro.deleteAnswer(answer.id!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            padding: EdgeInsets.all(9.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        answer.doctorId?.image ?? '',
                                      ),
                                      radius: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            answer.doctorId!.name! +
                                                '' +
                                                answer.doctorId!.familyname!,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(answer.answer!),
                                SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(height: 1),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print('goof' + '' + answer.id!);
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              DraggableScrollableSheet(
                                            initialChildSize: 0.64,
                                            minChildSize: 0.2,
                                            maxChildSize: 1,
                                            builder:
                                                (context, scrollController) {
                                              return AnswerCommentsModal(
                                                answerId: answer,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      icon: Icon(Iconsax.message_text_1),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'posté le ${formatter.format(answer.Publication!)}',
                                  style: TextStyle(fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          DraggableScrollableSheet(
                                        initialChildSize: 0.64,
                                        minChildSize: 0.2,
                                        maxChildSize: 1,
                                        builder: (context, scrollController) {
                                          return AnswerCommentsModal(
                                            answerId: answer,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text('voir les '),
                                      Numberasnwser(
                                        answerId: answer.id!,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text('Comenetaires')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Ta Reponse',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veuillez saisir une réponse";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _submitQuestion();
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerCommentsModal extends StatefulWidget {
  final Answer answerId;

  AnswerCommentsModal({required this.answerId});

  @override
  _AnswerCommentsModalState createState() => _AnswerCommentsModalState();
}

class _AnswerCommentsModalState extends State<AnswerCommentsModal> {
  bool isLoading = true;
  List<AnswerToQuestion>? allComment;
  late TextEditingController commentController;
  final formKey = GlobalKey<FormState>();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _webSocketService = WebSocketService();
    _fetchDiscussion();

    // Listen for new comments through WebSocket
    _webSocketService.socket.on('new_comment', (data) {
      if (data['question'] == widget.answerId.id) {
        _fetchDiscussion();
      }
    });
  }

  Future<void> _fetchDiscussion() async {
    try {
      final comments =
          await ApiServicePro.getAllAnswerbyDoctor(widget.answerId.id);
      setState(() {
        allComment = comments;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch comments: $e');
      setState(() {
        allComment = [];
        isLoading = false;
      });
    }
  }

  Future<void> _addComment(String newCommentText) async {
    try {
      await ApiServicePro.postAnswerToQuestionDoc(
        newCommentText,
        PreferenceUtils.getuserid(),
        widget.answerId.id!,
      );

      _webSocketService.send('new_comment', {
        'question': widget.answerId.id!,
        'comment': newCommentText,
        'doc': PreferenceUtils.getuserid(),
      }); // Emit WebSocket event
      _fetchDiscussion();
    } catch (e) {
      print('Failed to add comment: $e');
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    _webSocketService.reconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 5),
            Container(
              height: 8,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : allComment!.isEmpty
                      ? Center(child: Text('No comments yet'))
                      : ListView.builder(
                          itemCount: allComment!.length,
                          itemBuilder: (context, index) {
                            final comment = allComment![index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  comment.doc?.image ??
                                      comment.user?.image ??
                                      '',
                                ),
                                radius: 20,
                              ),
                              title: Text(
                                comment.doc?.name ?? comment.user?.name ?? '',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(comment.comment!),
                              isThreeLine: true,
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: commentController,
                        decoration: InputDecoration(
                          labelText: 'Your comment',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a comment";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _addComment(commentController.text);
                        commentController.clear();
                      }
                    },
                    child: Text('Submit'),
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

class Numberasnwser extends StatefulWidget {
  final String answerId;

  const Numberasnwser({super.key, required this.answerId});

  @override
  State<Numberasnwser> createState() => _NumberasnwserState();
}

class _NumberasnwserState extends State<Numberasnwser> {
  late Future<List<AnswerToQuestion>?> _reponse;
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _loadQuestions();

    // Listen for new answers through WebSocket
    _webSocketService.socket.on('new_comment', (data) {
      if (data['questionId'] == widget.answerId) {
        _loadQuestions();
      }
    });
  }

  void _loadQuestions() {
    setState(() {
      _reponse = ApiServicePro.getAllAnswerbyDoctor(widget.answerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnswerToQuestion>?>(
      future: _reponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        } else if (snapshot.hasError) {
          return Text('0');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No comments yet');
        } else {
          return Text('${snapshot.data!.length}');
        }
      },
    );
  }
}
