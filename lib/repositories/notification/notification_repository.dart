import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squadup_v3/config/dbPaths.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/notification/base_notification_repository.dart';
import 'package:meta/meta.dart';

class NotificationRepository extends BaseNotificationRepository {
  final FirebaseFirestore _firebaseFirestore;

  NotificationRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  
// Stream listens for any changes to the notifications collection in the 
// database and maps them from the snapshot to the notifications list
  Stream<List<Future<Notif>>> getUserNotifications({@required String userId}) {
    return _firebaseFirestore
        .collection(DbPaths.notifications)
        .doc(userId)
        .collection(DbPaths.userNotifications)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList(),
        );
  }

  
}
