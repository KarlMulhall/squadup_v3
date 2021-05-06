import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';
import 'package:squadup_v3/screens/profile/bloc/profile_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_player_state.dart';

class EditPlayerCubit extends Cubit<EditPlayerState> {
  final PlayerRepository _playerRepo;
  final StorageRepository _storageRepo;
  final ProfileBloc _profileBloc;

  EditPlayerCubit({
    @required PlayerRepository playerRepository,
    @required StorageRepository storageRepository,
    @required ProfileBloc profileBloc,
  })  : _playerRepo = playerRepository,
        _storageRepo = storageRepository,
        _profileBloc = profileBloc,
        super(EditPlayerState.initial()) {
    emit(state.copyWith(name: state.name));
  }

  void playerImageChanged(File file) {
    emit(state.copyWith(playerImage: file, status: EditPlayerStatus.initial));
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name, status: EditPlayerStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: EditPlayerStatus.submitting));
    try {
      final author = _profileBloc.state.user;
      var playerImageUrl = state.playerImage.path;
      if (state.playerImage != null) {
        playerImageUrl = await _storageRepo.uploadPlayerImage(
          url: playerImageUrl,
          image: state.playerImage,
        );
      }

      final updatedPlayer = Player(
        author: author,
        imageUrl: playerImageUrl,
        name: state.name,
        appearances: state.appearances,
        goals: state.goals,
        assists: state.assists,
        yellowCards: state.yellowCards,
        redCards: state.redCards,
        cleanSheets: state.cleanSheets,
      );

      await _playerRepo.updatePlayer(player: updatedPlayer);

      emit(state.copyWith(status: EditPlayerStatus.success));
      reset();
    } catch (err) {
      emit(
        state.copyWith(
          status: EditPlayerStatus.error,
          failure: const Failure(message: 'Unable to update player.'),
        ),
      );
    }
  }

  void reset() {
    emit(EditPlayerState.initial());
  }
}
