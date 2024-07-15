import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/comment.dart';
import 'package:opalia_client/models/discussion.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../services/local/sharedprefutils.dart';
import '../../../../../services/remote/apiServicePro.dart';
import '../../../../client/widgets/Allappwidgets/constant.dart';

class DiscussionItem extends StatefulWidget {
  final Discussion discu;
  const DiscussionItem({super.key, required this.discu});

  @override
  State<DiscussionItem> createState() => _DiscussionItemState();
}

class _DiscussionItemState extends State<DiscussionItem> {
  List<Comment>? allComment;
  String _userId = PreferenceUtils.getuserid(); // Example userId

  bool isLoading = true;
  late TextEditingController CommentController;
  final formKey = GlobalKey<FormState>();
  Future<void> _loadLikeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLiked =
          prefs.getBool('like_${widget.discu.discussionId!}_$_userId') ?? false;
      print(_userId);
    });
  }

  Future<void> _saveLikeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('like_${widget.discu.discussionId!}_$_userId', _isLiked);
  }

  Future<void> _fetchDiscussion() async {
    try {
      final comment = await ApiServicePro.getAllCommentsbyDiscussion(
          widget.discu.discussionId);
      setState(
        () {
          allComment = comment;
          isLoading = false;
        },
      );
    } catch (e) {
      print('Failed to fetch comment: $e');
      setState(() {
        allComment = [];
        isLoading = false;
      });
    }
  }

  Future<void> _addComment(String newCommentText) async {
    // Example: Adding new comment
    try {
      // Call your API to add the new comment
      await ApiServicePro.postComment(
        newCommentText,
        PreferenceUtils.getuserid(),
        widget.discu.discussionId,
      );

      // After successfully adding, fetch the updated list
      _fetchDiscussion(); // This will refresh the page automatically
      CommentController.clear();
    } catch (e) {
      print('Failed to add comment: $e');
      // Handle error if needed
    }
  }

  Future<void> deletecomment(String newCommentText) async {
    // Example: Adding new comment
    try {
      // Call your API to add the new comment
      await ApiServicePro.deleteComment(newCommentText);

      // After successfully adding, fetch the updated list
      _fetchDiscussion(); // This will refresh the page automatically
      CommentController.clear();
    } catch (e) {
      print('Failed to delete comment: $e');
      // Handle error if needed
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDiscussion();
    _loadLikeState();
    CommentController = TextEditingController();
  }

  @override
  void dispose() {
    CommentController.dispose();
    super.dispose();
  }

  bool _isLiked = false; // Track the like status

  void _toggleLike() async {
    try {
      if (_isLiked) {
        await ApiServicePro.unlikePost(
            widget.discu.discussionId!, "66754d2525c9be414693c2e9");
        _fetchDiscussion();
      } else {
        await ApiServicePro.likePost(
            widget.discu.discussionId!, "66754d2525c9be414693c2e9");
        _fetchDiscussion();
      }
      setState(() {
        _isLiked = !_isLiked;
        _saveLikeState();
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  var formatter = new DateFormat('dd-MM-yyyy');
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
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.discu.author!.name!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          widget.discu.author!.familyname!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      DateFormat.yMMMEd().format(widget.discu.postedat!),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // await ApiServicePro.deleteDiscussion(
                  //     discu.discussionId);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Voulez vous vraiment suprimer ce post ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Si ou appuyer sur ok',
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 110,
                          ),
                          TextButton(
                            child: Text('OK'),
                            onPressed: () async {
                              await ApiServicePro.deleteDiscussion(
                                  widget.discu.discussionId);
                              _fetchDiscussion();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 5,
          ),

          ///sublect
          Text(widget.discu.subject!),
          SizedBox(
            height: 10,
          ),

          ///coùents
          Row(
            children: [
              Text('Commentaire ${allComment?.length.toString()}'),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
            ),
          ),

          ///likke comment
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                      color: _isLiked ? Colors.blue : Colors.grey,
                    ),
                    color: Colors.red,
                  ),
                  Text('Like'),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                children: [
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
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: allComment!.length,
                                      itemBuilder: (context, index) {
                                        final com = allComment![index];
                                        if (isLoading) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          var nameItial =
                                              com.doc!.name![0].toUpperCase();
                                          return allComment!.isEmpty
                                              ? Center(
                                                  child:
                                                      Text('pas de Discussion'))
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        widget.discu.author!
                                                            .image!,
                                                      ),
                                                      radius: 20,
                                                      child: Text(
                                                        nameItial,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      '${com.doc!.name!} ${com.doc!.familyname!}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    subtitle: Text(
                                                      com.comment!,
                                                    ),
                                                    isThreeLine: true,
                                                    trailing: IconButton(
                                                      onPressed: () async {
                                                        deletecomment(
                                                            com.commentId!);
                                                      },
                                                      icon: Icon(
                                                        Icons.delete,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Form(
                                            key: formKey,
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "veullez saisire une comentaire";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              controller: CommentController,
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            kBorderRadius),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.red,
                                                        ),
                                                        borderRadius:
                                                            kBorderRadius),
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                filled: true,
                                                hintText: "ecrire comentaire",
                                                fillColor: Colors.transparent,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              _addComment(
                                                  CommentController.text);
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
                    icon: Icon(
                      Icons.textsms_rounded,
                    ),
                    color: Colors.red,
                  ),
                  Text('Comment'),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
