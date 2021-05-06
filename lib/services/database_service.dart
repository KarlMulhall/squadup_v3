import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squadup_v3/config/constants.dart';
import 'package:squadup_v3/models/models.dart';

class DatabaseService {
  Future<User> getUser(String userId) async {
    DocumentSnapshot userDoc = await usersRef.doc(userId).get();
    return User.fromDocument(userDoc);
  }

  Future<List<User>> searchUsers(String currentUserId, String name) async {
    QuerySnapshot usersSnap =
        await usersRef.where('username', isGreaterThanOrEqualTo: name).get();

    List<User> users = [];
    usersSnap.docs.forEach((doc) {
      User user = User.fromDocument(doc);
      if (user.id != currentUserId) {
        users.add(user);
      }
    });
    return users;
  }
}
