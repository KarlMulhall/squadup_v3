part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationsUpdate extends NotificationsEvent {
  final List<Notif> notifications;

  const NotificationsUpdate({@required this.notifications});

  @override
  List<Object> get props => [notifications];
}
