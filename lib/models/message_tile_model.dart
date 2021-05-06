import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:meta/meta.dart';

import 'package:squadup_v3/models/models.dart';

class MessageTile extends Equatable {
  final String id;
  final User author;
  final DateTime date;

  const MessageTile({
    this.id,
    @required this.author,
    @required this.date,
  });

  @override
  List<Object> get props => [id, author, date];

  MessageTile copyWith({
    String id,
    User user,
    DateTime dateTime,
  }) {
    return MessageTile(
      id: id ?? this.id,
      author: user ?? this.author,
      date: dateTime ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(DbPaths.users).doc(author.id),
      'date': Timestamp.fromDate(date),
    };
  }

  // static Future<MessageTile> fromDocument(DocumentSnapshot doc) async {
  //   if (doc == null) return null;
  //   final data = doc.data();
  //   final authorRef = data['author'] as DocumentReference;
  // }
}
