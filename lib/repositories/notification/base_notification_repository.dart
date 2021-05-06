import 'package:squadup_v3/models/models.dart';

abstract class BaseNotificationRepository {
  Stream<List<Future<Notif>>> getUserNotifications({String userId});
}
