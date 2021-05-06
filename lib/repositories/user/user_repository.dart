import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:squadup_v3/enums/enums.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/models/user_model.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({String userId}) async {
    final doc =
        await _firebaseFirestore.collection(DbPaths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({User user}) async {
    await _firebaseFirestore
        .collection(DbPaths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  @override
  Future<List<User>> searchUsers({@required String query}) async {
    final userSnap = await _firebaseFirestore
        .collection(DbPaths.users)
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: 'z')
        .get();

    return userSnap.docs.map((doc) => User.fromDocument(doc)).toList();
  }

  @override
  void followUser({@required String userId, @required String followUserId}) {
    // add followUser to user's userFollowing
    _firebaseFirestore
        .collection(DbPaths.following)
        .doc(userId)
        .collection(DbPaths.userFollowing)
        .doc(followUserId)
        .set({});

    // add user to followUser's userFollowers
    _firebaseFirestore
        .collection(DbPaths.followers)
        .doc(followUserId)
        .collection(DbPaths.userFollowers)
        .doc(userId)
        .set({});

    final notifications = Notif(
      notifType: NotificationType.follow,
      fromUser: User.empty.copyWith(id: userId),
      dateTime: DateTime.now(),
    );

    _firebaseFirestore
        .collection(DbPaths.notifications)
        .doc(followUserId)
        .collection(DbPaths.userNotifications)
        .add(notifications.toDocument());
  }

  @override
  void unfollowUser(
      {@required String userId, @required String unfollowUserId}) {
    //remove unfollowUser from user's userFollowing.
    _firebaseFirestore
        .collection(DbPaths.following)
        .doc(userId)
        .collection(DbPaths.userFollowing)
        .doc(unfollowUserId)
        .delete();

    //Remove user from unfollowUser's userFollowers.
    _firebaseFirestore
        .collection(DbPaths.followers)
        .doc(unfollowUserId)
        .collection(DbPaths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing(
      {@required String userId, @required String otherUserId}) async {
    //otherUser in user's userFollowing
    final otherUserDoc = await _firebaseFirestore
        .collection(DbPaths.following)
        .doc(userId)
        .collection(DbPaths.userFollowing)
        .doc(otherUserId)
        .get();
    return otherUserDoc.exists;
  }
}
