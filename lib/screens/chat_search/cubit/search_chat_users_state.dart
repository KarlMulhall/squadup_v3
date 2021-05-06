part of 'search_chat_users_cubit.dart';

enum SearchChatUsersStatus { initial, loading, loaded, error }

class SearchChatUsersState extends Equatable {
  final List<User> users;
  final SearchChatUsersStatus status;
  final Failure failure;

  const SearchChatUsersState({
    @required this.users,
    @required this.status,
    @required this.failure,
  });

  factory SearchChatUsersState.initial() {
    return const SearchChatUsersState(
      users: [],
      status: SearchChatUsersStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        users,
        status,
        failure,
      ];

  SearchChatUsersState copyWith({
    List<User> users,
    SearchChatUsersStatus status,
    Failure failure,
  }) {
    return SearchChatUsersState(
      users: users ?? this.users,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

