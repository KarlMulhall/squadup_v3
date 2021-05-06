import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:squadup_v3/enums/enums.dart';

import 'package:squadup_v3/models/comment_model.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/models/post_model.dart';
import 'package:squadup_v3/repositories/post/base_post_repository.dart';
import 'package:meta/meta.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;
  PostRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({@required Post post}) async {
    await _firebaseFirestore.collection(DbPaths.posts).add(post.toDocument());
  }

  @override
  Future<void> createComment(
      {@required Post post, @required Comment comment}) async {
    await _firebaseFirestore
        .collection(DbPaths.comments)
        .doc(comment.postId)
        .collection(DbPaths.postComments)
        .add(comment.toDocument());

    print('');
    print(post.author.id);
    print('');
    print(comment.author.id);

// Send notification if the userId of the user who commented on the post doesn't
// match the id of the posts author.
//
// Don't create notifs for commenting on their own post
    if (post.author.id != comment.author.id) {
      final notifications = Notif(
        notifType: NotificationType.comment,
        fromUser: comment.author,
        post: post,
        dateTime: DateTime.now(),
      );

      _firebaseFirestore
          .collection(DbPaths.notifications)
          .doc(post.author.id)
          .collection(DbPaths.userNotifications)
          .add(notifications.toDocument());
    }
  }

  @override
  void createLike({@required Post post, @required String userId}) {
    _firebaseFirestore
        .collection(DbPaths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(DbPaths.likes)
        .doc(post.id)
        .collection(DbPaths.postLikes)
        .doc(userId)
        .set({});

// Send notification if the userId of the user who liked the post doesn't match
// the id of the posts author.
//
// Don't create notifs for liking their own post
    if (post.author.id != userId) {
      final notifications = Notif(
        notifType: NotificationType.like,
        fromUser: User.empty.copyWith(id: userId),
        post: post,
        dateTime: DateTime.now(),
      );

      _firebaseFirestore
          .collection(DbPaths.notifications)
          .doc(post.author.id)
          .collection(DbPaths.userNotifications)
          .add(notifications.toDocument());
    }
  }

  @override
  Stream<List<Future<Post>>> getUserPosts({@required String userId}) {
    final authorRef = _firebaseFirestore.collection(DbPaths.users).doc(userId);
    return _firebaseFirestore
        .collection(DbPaths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Post.fromDocument(doc)).toList());
  }

  @override
  Stream<List<Future<Comment>>> getPostComments({@required String postId}) {
    return _firebaseFirestore
        .collection(DbPaths.comments)
        .doc(postId)
        .collection(DbPaths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Comment.fromDocument(doc)).toList(),
        );
  }

  @override
  Future<List<Post>> getUserFeed({
    @required String userId,
    String lastPostId,
  }) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(DbPaths.feeds)
          .doc(userId)
          .collection(DbPaths.userFeed)
          .orderBy('date', descending: true)
          .limit(10)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(DbPaths.feeds)
          .doc(userId)
          .collection(DbPaths.userFeed)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(DbPaths.feeds)
          .doc(userId)
          .collection(DbPaths.userFeed)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(3)
          .get();
    }
    final posts = Future.wait(
      postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList(),
    );

    return posts;
  }

  @override
  Future<Set<String>> getLikedPostIds({
    @required String userId,
    @required List<Post> posts,
  }) async {
    final postIds = <String>{};
    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(DbPaths.likes)
          .doc(post.id)
          .collection(DbPaths.postLikes)
          .doc(userId)
          .get();

      if (likeDoc.exists) {
        postIds.add(post.id);
      }
    }
    return postIds;
  }

  @override
  void deleteLike({@required String postId, @required String userId}) {
    _firebaseFirestore
        .collection(DbPaths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(DbPaths.likes)
        .doc(postId)
        .collection(DbPaths.postLikes)
        .doc(userId)
        .delete();
  }
}
