import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import '../../../../models/AnswerToQuestion.dart';
import '../../../../models/answer.dart';
import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../../../services/remote/websocketService.dart';
import '../../widgets/Allappwidgets/constant.dart';

class ViewAnswersScreen extends StatefulWidget {
  final String questionId;

  ViewAnswersScreen({required this.questionId});

  @override
  _ViewAnswersScreenState createState() => _ViewAnswersScreenState();
}

class _ViewAnswersScreenState extends State<ViewAnswersScreen> {
  late Future<List<Answer>?> _answers;
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _loadQuestions();
    _webSocketService.socket.on('new_answer', (data) {
      if (data['questionId'] == widget.questionId) {
        _loadQuestions();
      }
    });
  }

  void _loadQuestions() {
    setState(() {
      _answers = ApiServicePro.getAllAnswerss(widget.questionId);
    });
  }

  @override
  void dispose() {
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
          'Réponses',
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: FutureBuilder<List<Answer>?>(
          future: _answers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Aucune réponse trouvée'));
            } else {
              return snapshot.data!.isEmpty
                  ? Center(child: Text('No comments yet'))
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final answer = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Dismissible(
                            background: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 36,
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                            ),
                            key: Key(answer.id!),
                            onDismissed: (direction) async {
                              try {
                                await ApiServicePro.deleteAnswer(answer.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Réponse supprimée')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erreur: $e')),
                                );
                              }
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
                                            answer.doctorId!.image!),
                                        radius: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${answer.doctorId!.name} ${answer.doctorId!.familyname}',
                                              style: TextStyle(
                                                fontSize: 12,
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
                                                  webSocketService:
                                                      _webSocketService,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
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
                                              webSocketService:
                                                  _webSocketService,
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
      ),
    );
  }
}

class AnswerCommentsModal extends StatefulWidget {
  final Answer answerId;
  final WebSocketService webSocketService;

  AnswerCommentsModal({
    required this.answerId,
    required this.webSocketService,
  });

  @override
  _AnswerCommentsModalState createState() => _AnswerCommentsModalState();
}

class _AnswerCommentsModalState extends State<AnswerCommentsModal> {
  bool isLoading = true;
  List<AnswerToQuestion>? allComment;
  late TextEditingController commentController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _fetchDiscussion();

    widget.webSocketService.socket.on('new_comment', (data) {
      if (data['question'] == widget.answerId.id) {
        _fetchDiscussion();
      }
    });
  }

  @override
  void dispose() {
    commentController.dispose();

    super.dispose();
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
      await ApiServicePro.postAnswerToQuestionPateint(
        newCommentText,
        PreferenceUtils.getuserid(),
        widget.answerId.id,
      );

      widget.webSocketService.send('new_comment', {
        'question': widget.answerId.id!,
        'comment': newCommentText,
        'user': PreferenceUtils.getuserid(),
      });

      _fetchDiscussion();
      commentController.clear();
    } catch (e) {
      print('Failed to add comment: $e');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await ApiServicePro.deleteAnswerToQuestion(commentId);
      _fetchDiscussion();
    } catch (e) {
      print('Failed to delete comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: allComment?.length ?? 0,
                    itemBuilder: (context, index) {
                      final com = allComment![index];
                      return allComment!.isEmpty
                          ? Center(child: Text('Pas de discussion'))
                          : Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    com.doc?.image ?? com.user?.image ?? '',
                                  ),
                                  radius: 20,
                                ),
                                title: Text(
                                  com.doc?.name ?? com.user?.name ?? '',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(com.comment!),
                                isThreeLine: true,
                                trailing: IconButton(
                                  onPressed: () async {
                                    await _deleteComment(com.id!);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Veuillez saisir un commentaire";
                        }
                        return null;
                      },
                      controller: commentController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: kBorderRadius,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: kBorderRadius,
                        ),
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        hintText: "Écrire un commentaire",
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _addComment(commentController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
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
