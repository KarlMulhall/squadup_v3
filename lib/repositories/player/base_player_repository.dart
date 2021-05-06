import 'package:squadup_v3/models/models.dart';

abstract class BasePlayerRepository {

  //create methods
  Future<void> createPlayer({Player player});
  void addAppearance({Player player});
  void addGoal({Player player});
  void addAssist({Player player});
  void addYellowCard({Player player});
  void addRedCard({Player player});
  void addCleanSheet({Player player});    

  //update methods
  Future<void> updatePlayer({Player player});

  //get methods
  Future<Player> getPlayerWithId({String playerId});
  Stream<List<Future<Player>>> getUserPlayers({String userId});
  
  Future<List<Player>> getUserPlayerFeed({String userId, String lastPlayerId});

  //delete methods
  void deleteAppearance({String playerId});
  void deleteGoal({String playerId});
  void deleteAssist({String playerId});
  void deleteYellowCard({String playerId});
  void deleteRedCard({String playerId});
  void deleteCleanSheet({String playerId});
}