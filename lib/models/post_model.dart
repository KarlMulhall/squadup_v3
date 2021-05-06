import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:meta/meta.dart';

import 'package:squadup_v3/models/models.dart';

class Post extends Equatable {
  final String id;
  final DateTime date;
  final User author;
  final int likes;
  final String imageUrl;
  final String caption;

  const Post({
    this.id,
    @required this.date,
    @required this.author,
    @required this.imageUrl,
    @required this.likes,
    @required this.caption,
  });

  @override
  List<Object> get props => [id, date, author, likes, imageUrl, caption];

  Post copyWith({
    String id,
    DateTime date,
    User author,
    String imageUrl,
    int likes,
    String caption,
  }) {
    return Post(
      id: id ?? this.id,
      date: date ?? this.date,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(DbPaths.users).doc(author.id),
      'date': Timestamp.fromDate(date),
      'likes': likes,
      'imageUrl': imageUrl,
      'caption': caption,
    };
  }

  static Future<Post> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          date: (data['date'] as Timestamp)?.toDate(),
          author: User.fromDocument(authorDoc),
          likes: (data['likes'] ?? 0).toInt(),
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
        );
      }
    }
    return null;
  }
}
