import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:meta/meta.dart';

import 'package:squadup_v3/enums/enums.dart';
import 'package:squadup_v3/models/models.dart';

class Notif extends Equatable {
  final String id;
  final NotificationType notifType;
  final User fromUser;
  final Post post;
  final DateTime dateTime;

  const Notif({
    this.id,
    @required this.notifType,
    @required this.fromUser,
    this.post,
    @required this.dateTime,
  });

  @override
  List<Object> get props => [id, notifType, fromUser, post, dateTime];

  Notif copyWith({
    String id,
    NotificationType type,
    User fromUser,
    Post post,
    DateTime date,
  }) {
    return Notif(
      id: id ?? this.id,
      notifType: type ?? this.notifType,
      fromUser: fromUser ?? this.fromUser,
      post: post ?? this.post,
      dateTime: date ?? this.dateTime,
    );
  }

  Map<String, dynamic> toDocument() {
    final notificationType = EnumToString.convertToString(notifType);
    return {
      'type': notificationType,
      'fromUser':
          FirebaseFirestore.instance.collection(DbPaths.users).doc(fromUser.id),
      'post': post != null
          ? FirebaseFirestore.instance.collection(DbPaths.posts).doc(post.id)
          : null,
      'date': Timestamp.fromDate(dateTime),
    };
  }

  static Future<Notif> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final notificationType = EnumToString.fromString(NotificationType.values, data['type']);

    // From User
    final fromUserReference = data['fromUser'] as DocumentReference;
    if (fromUserReference != null) {
      final fromUserDocument = await fromUserReference.get();

      // Post
      final postReference = data['post'] as DocumentReference;
      if (postReference != null) {
        final postDocument = await postReference.get();
        if (postDocument.exists) {
          return Notif(
            id: doc.id,
            notifType: notificationType,
            fromUser: User.fromDocument(fromUserDocument),
            post: await Post.fromDocument(postDocument),
            dateTime: (data['date'] as Timestamp)?.toDate(),
          );
        }
      } else {
        return Notif(
          id: doc.id,
          notifType: notificationType,
          fromUser: User.fromDocument(fromUserDocument),
          post: null,
          dateTime: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }
}
