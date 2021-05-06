import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';

part 'create_player_state.dart';

class CreatePlayerCubit extends Cubit<CreatePlayerState> {
  final PlayerRepository _playerRepo;
  final StorageRepository _storageRepo;
  final AuthBloc _authBloc;

  CreatePlayerCubit({
    @required PlayerRepository playerRepository,
    @required StorageRepository storageRepository,
    @required AuthBloc authBloc,
  })  : _playerRepo = playerRepository,
        _storageRepo = storageRepository,
        _authBloc = authBloc,
        super(CreatePlayerState.initial());

  void playerImageChanged(File file) {
    emit(state.copyWith(playerImage: file, status: CreatePlayerStatus.initial));
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name, status: CreatePlayerStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePlayerStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final playerImageUrl =
          await _storageRepo.uploadPostImage(image: state.playerImage);

      final player = Player(
        author: author,
        imageUrl: playerImageUrl,
        name: state.name,
        appearances: 0,
        goals: 0,
        assists: 0,
        yellowCards: 0,
        redCards: 0,
        cleanSheets: 0,
      );

      await _playerRepo.createPlayer(player: player);

      emit(state.copyWith(status: CreatePlayerStatus.success));
      reset();
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePlayerStatus.error,
          failure: const Failure(message: 'Unable to create player.'),
        ),
      );
    }
  }

  void reset() {
    emit(CreatePlayerState.initial());
  }
}
