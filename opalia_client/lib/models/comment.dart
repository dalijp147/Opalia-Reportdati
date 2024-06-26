import 'package:opalia_client/models/discussion.dart';

import 'medecin.dart';

List<Comment> CommentFromJson(dynamic str) =>
    List<Comment>.from((str).map((x) => Comment.fromMap(x)));

class Comment {
  final String? commentId;
  final String? comment;
  final Medecin? doc;
  final Discussion? post;
  late DateTime? postedat;

  Comment({
    this.commentId,
    this.comment,
    this.doc,
    this.post,
    this.postedat,
  });
  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(
      commentId: json['_id'],
      doc: json['doc'] != null
          ? Medecin.fromMap(json['doc'] as Map<String, dynamic>)
          : null,
      // post: json['post'] != null
      //     ? Discussion.fromMap(json['post'] as Map<String, dynamic>)
      //     : null,
      comment: json['comment'],
      postedat: DateTime.parse(json['createdAt'].toString()),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': commentId,
      'doc': doc,
      'post': post,
      'comment': comment,
      'createdAt': postedat,
    };
  }
}
