import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/comment.dart';
import 'package:opalia_client/models/discussion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/local/sharedprefutils.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../../../services/remote/websocketService.dart';
import '../../../client/widgets/Allappwidgets/constant.dart';

class DiscussionItem extends StatefulWidget {
  final Discussion discu;
  const DiscussionItem({super.key, required this.discu});

  @override
  State<DiscussionItem> createState() => _DiscussionItemState();
}

class _DiscussionItemState extends State<DiscussionItem> {
  List<Comment>? allComment;
  String _userId = PreferenceUtils.getuserid(); // Example userId
  late WebSocketService _webSocketService;
  bool isLoading = true;
  late TextEditingController commentController;
  final formKey = GlobalKey<FormState>();
  bool _isLiked = false; // Track the like status
  var formatter = DateFormat('EEEE, d MMMM yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService(); // Initialize WebSocketService
    _webSocketService.socket.on('new_dicucomment', (data) {
      if (data['post'] == widget.discu.discussionId) {
        _fetchDiscussion();
      }
    });
    _webSocketService.socket.on('delete_dicucomment', (data) {
      if (data['_id'] == widget.discu.discussionId) {}
    });
    _fetchDiscussion();
    _loadLikeState();
    commentController = TextEditingController();
  }

  Future<void> _loadLikeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked =
          prefs.getBool('like_${widget.discu.discussionId}_$_userId') ?? false;
    });
  }

  Future<void> _saveLikeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('like_${widget.discu.discussionId}_$_userId', _isLiked);
  }

  Future<void> _fetchDiscussion() async {
    try {
      final comments = await ApiServicePro.getAllCommentsbyDiscussion(
          widget.discu.discussionId);
      setState(() {
        allComment = comments;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch comments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addComment(String newCommentText) async {
    try {
      await ApiServicePro.postComment(newCommentText,
          PreferenceUtils.getuserid(), widget.discu.discussionId!);
      _webSocketService.send('new_dicucomment', {
        'comment': newCommentText,
        'doc': PreferenceUtils.getuserid(),
        'post': widget.discu.discussionId!,
      });
      setState(() {
        isLoading = true;
      });
      _fetchDiscussion();
      commentController.clear();
    } catch (e) {
      print('Failed to add comment: $e');
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await ApiServicePro.deleteComment(commentId);
      _fetchDiscussion();
      print('sucess');
    } catch (e) {
      print('Failed to delete comment: $e');
    }
  }

  Future<void> _deleteDicussion(String commentId) async {
    try {
      await ApiServicePro.deleteDiscussion(commentId);
      _fetchDiscussion();
    } catch (e) {
      print('Failed to delete comment: $e');
    }
  }

  void _toggleLike() async {
    try {
      if (_isLiked) {
        await ApiServicePro.unlikePost(widget.discu.discussionId!, _userId);
      } else {
        await ApiServicePro.likePost(widget.discu.discussionId!, _userId);
      }
      setState(() {
        _isLiked = !_isLiked;
        _saveLikeState();
      });
      _fetchDiscussion();
    } catch (e) {
      print('Failed to toggle like: $e');
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.discu.author!.image!),
                radius: 20,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.discu.author!.name!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          widget.discu.author!.familyname!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(formatter.format(widget.discu.postedat!)),
                  ],
                ),
              ),
              widget.discu.author!.doctorId! == PreferenceUtils.getuserid()
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Voulez-vous vraiment supprimer ce post ?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                'Si oui, appuyez sur OK',
                                style: TextStyle(fontSize: 20),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                SizedBox(width: 110),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog before async operation
                                    try {
                                      await _deleteDicussion(
                                          widget.discu.discussionId!);
                                      print(widget.discu.discussionId!);
                                    } catch (e) {
                                      // Show error message to user
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to delete discussion: $e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    )
                  : SizedBox.shrink()
            ],
          ),
          SizedBox(height: 10),
          Text(widget.discu.subject!),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Commentaires ${allComment?.length.toString() ?? '0'}'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _toggleLike,
                icon: Icon(
                  _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                  color: _isLiked ? Colors.blue : Colors.grey,
                ),
              ),
              Text('Like'),
              SizedBox(width: 15),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DraggableScrollableSheet(
                      initialChildSize: 0.64,
                      minChildSize: 0.2,
                      maxChildSize: 1,
                      builder: (context, scrollController) {
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
                                    : allComment == null || allComment!.isEmpty
                                        ? Center(
                                            child: Text('Pas de Comentaire'))
                                        : ListView.builder(
                                            controller: scrollController,
                                            itemCount: allComment!.length,
                                            itemBuilder: (context, index) {
                                              final com = allComment![index];

                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        com.doc!.image!,
                                                      ),
                                                      radius: 20,
                                                    ),
                                                    title: Text(
                                                      'Dr ${com.doc!.familyname!} ${com.doc!.name!}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    subtitle:
                                                        Text(com.comment!),
                                                    isThreeLine: true,
                                                    trailing: com.doc!
                                                                .doctorId! ==
                                                            PreferenceUtils
                                                                .getuserid()
                                                        ? IconButton(
                                                            onPressed:
                                                                () async {
                                                              await _deleteComment(
                                                                  com.commentId!);
                                                            },
                                                            icon: Icon(
                                                                Icons.delete),
                                                          )
                                                        : SizedBox.shrink()),
                                              );
                                            },
                                          ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Form(
                                        key: formKey,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Veuillez saisir un commentaire";
                                            } else {
                                              return null;
                                            }
                                          },
                                          controller: commentController,
                                          autofocus: false,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius: kBorderRadius,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius: kBorderRadius,
                                            ),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
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
                      },
                    ),
                  );
                },
                icon: Icon(Icons.textsms_rounded),
                color: Colors.red,
              ),
              Text('Commenter'),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
