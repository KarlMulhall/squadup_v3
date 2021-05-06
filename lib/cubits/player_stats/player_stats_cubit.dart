import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:meta/meta.dart';

part 'player_stats_state.dart';

class PlayerStatsCubit extends Cubit<PlayerStatsState> {
  final PlayerRepository _playerRepo;
  // final AuthBloc _authBloc;

  PlayerStatsCubit({
    @required PlayerRepository playerRepository,
    // @required AuthBloc authBloc,
  })  : _playerRepo = playerRepository,
        // _authBloc = authBloc,
        super(PlayerStatsState.initial());

  void addAppearance({@required Player player}) {
    _playerRepo.addAppearance(player: player);
  }

  void deleteAppearance({@required Player player}) {
    _playerRepo.deleteAppearance(playerId: player.id);
  }

  void addGoal({@required Player player}) {
    _playerRepo.addGoal(player: player);
  }

  void deleteGoal({@required Player player}) {
    _playerRepo.deleteGoal(playerId: player.id);
  }

  void addAssist({@required Player player}) {
    _playerRepo.addAssist(player: player);
  }

  void deleteAssist({@required Player player}) {
    _playerRepo.deleteAssist(playerId: player.id);
  }

  void addCleanSheet({@required Player player}) {
    _playerRepo.addCleanSheet(player: player);
  }

  void deleteCleanSheet({@required Player player}) {
    _playerRepo.deleteCleanSheet(playerId: player.id);
  }

  void addYellowCard({@required Player player}) {
    _playerRepo.addYellowCard(player: player);
  }

  void deleteYellowCard({@required Player player}) {
    _playerRepo.deleteYellowCard(playerId: player.id);
  }

  void addRedCard({@required Player player}) {
    _playerRepo.addRedCard(player: player);
  }

  void deleteRedCard({@required Player player}) {
    _playerRepo.deleteRedCard(playerId: player.id);
  }
}
