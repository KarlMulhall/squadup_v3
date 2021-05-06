import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/notification/notification_repository.dart';
import 'package:meta/meta.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepo;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif>>> _notificationsSub;

  NotificationsBloc({
    @required NotificationRepository notificationRepository,
    @required AuthBloc authBloc,
  })  : _notificationRepo = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    _notificationsSub?.cancel();
    _notificationsSub = _notificationRepo
        .getUserNotifications(userId: _authBloc.state.user.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdate(notifications: allNotifications));
    });
  }


  // close subscription
  @override
  Future<void> close() {
    _notificationsSub.cancel();
    return super.close();
  }

  Stream<NotificationsState> _mapNotificationsUpdateToState(
    NotificationsUpdate event,
  ) async* {
    yield state.copyWith(
      notifications: event.notifications,
      status: NotificationsStatus.loaded,
    );
  }

  @override
  Stream<NotificationsState> mapEventToState(
    NotificationsEvent event,
  ) async* {
    if (event is NotificationsUpdate) {
      yield* _mapNotificationsUpdateToState(event);
    }
  }
}
