import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:meta/meta.dart';

import 'package:squadup_v3/models/models.dart';

class Comment extends Equatable {
  final String id;
  final User author;
  final String postId;
  final DateTime dateTime;
  final String content;

  const Comment({
    this.id,
    @required this.author,
    @required this.postId,
    @required this.dateTime,
    @required this.content,
  });

  @override
  List<Object> get props => [
        id,
        author,
        postId,
        dateTime,
        content,
      ];

  Comment copyWith({
    String id,
    User author,
    String postId,
    DateTime dateTime,
    String content,
  }) {
    return Comment(
      id: id ?? this.id,
      author: author ?? this.author,
      postId: postId ?? this.postId,
      dateTime: dateTime ?? this.dateTime,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'postId': postId,
      'author':
          FirebaseFirestore.instance.collection(DbPaths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(dateTime),
    };
  }

  static Future<Comment> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          id: doc.id,
          postId: data['postId'] ?? '',
          author: User.fromDocument(authorDoc),
          content: data['content'] ?? '',
          dateTime: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }
}
