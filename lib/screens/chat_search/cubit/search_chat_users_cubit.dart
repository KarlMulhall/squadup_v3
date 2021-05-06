import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/repositories/user/user_repository.dart';

part 'search_chat_users_state.dart';

class SearchChatUsersCubit extends Cubit<SearchChatUsersState> {
  final UserRepository _userRepo;

  SearchChatUsersCubit({@required UserRepository userRepository})
      : _userRepo = userRepository,
        super(SearchChatUsersState.initial());

  void searchUsers(String query) async {
    emit(state.copyWith(status: SearchChatUsersStatus.loading));
    try {
      final users = await _userRepo.searchUsers(query: query);
      emit(state.copyWith(
        users: users,
        status: SearchChatUsersStatus.loaded,
      ));
    } catch (err) {
      state.copyWith(
        status: SearchChatUsersStatus.error,
        failure:
            const Failure(message: 'Something went wrong. Please try again.'),
      );
    }
  }

  void clearSearch() {
    emit(state.copyWith(users: [], status: SearchChatUsersStatus.initial));
  }
}
