part of 'messaging_bloc.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();
  
  @override
  List<Object> get props => [];
}

class MessagingInitial extends MessagingState {}
