import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squadup_v3/config/dbPaths.dart';

import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/models/player_model.dart';
import 'package:squadup_v3/repositories/player/base_player_repository.dart';
import 'package:meta/meta.dart';

class PlayerRepository extends BasePlayerRepository {
  final FirebaseFirestore _firebaseFirestore;
  PlayerRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPlayer({@required Player player}) async {
    await _firebaseFirestore.collection(DbPaths.players).add(player.toDocument());
  }

  @override
  Future<void> updatePlayer({Player player}) async {
    await _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update(player.toDocument());
  }

  @override
  Future<Player> getPlayerWithId({String playerId}) async {
    final doc =
        await _firebaseFirestore.collection(DbPaths.players).doc(playerId).get();
    return doc.exists ? Player.fromDocument(doc) : Player.empty;
  }

  @override
  Stream<List<Future<Player>>> getUserPlayers({@required String userId}) {
    final authorRef = _firebaseFirestore.collection(DbPaths.users).doc(userId);
    return _firebaseFirestore
        .collection(DbPaths.players)
        .where('author', isEqualTo: authorRef)
        .orderBy('goals', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Player.fromDocument(doc)).toList());
  }

  @override
  Future<List<Player>> getUserPlayerFeed({
    @required String userId,
    String lastPlayerId,
  }) async {
    QuerySnapshot playersSnap;
    if (lastPlayerId == null) {
      playersSnap = await _firebaseFirestore
          .collection(DbPaths.playerLists)
          .doc(userId)
          .collection(DbPaths.userPlayersFeed)
          .orderBy('date', descending: true)
          .limit(30)
          .get();
    } else {
      final lastPlayerDoc = await _firebaseFirestore
          .collection(DbPaths.playerLists)
          .doc(userId)
          .collection(DbPaths.userPlayersFeed)
          .doc(lastPlayerId)
          .get();

      if (!lastPlayerDoc.exists) {
        return [];
      }

      playersSnap = await _firebaseFirestore
          .collection(DbPaths.playerLists)
          .doc(userId)
          .collection(DbPaths.userPlayersFeed)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPlayerDoc)
          .limit(3)
          .get();
    }
    final players = Future.wait(
      playersSnap.docs.map((doc) => Player.fromDocument(doc)).toList(),
    );

    return players;
  }

  @override
  void addAppearance({Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'appearances': FieldValue.increment(1)});
  }

  @override
  void addGoal({@required Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'goals': FieldValue.increment(1)});
  }

  @override
  void addAssist({Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'assists': FieldValue.increment(1)});
  }

  @override
  void addCleanSheet({Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'cleanSheets': FieldValue.increment(1)});
  }

  @override
  void addRedCard({Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'redCards': FieldValue.increment(1)});
  }

  @override
  void addYellowCard({Player player}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(player.id)
        .update({'yellowCards': FieldValue.increment(1)});
  }

  @override
  void deleteAppearance({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'appearances': FieldValue.increment(-1)});
  }

  @override
  void deleteGoal({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'goals': FieldValue.increment(-1)});
  }

  @override
  void deleteAssist({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'assists': FieldValue.increment(-1)});
  }

  @override
  void deleteCleanSheet({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'cleanSheets': FieldValue.increment(-1)});
  }

  @override
  void deleteRedCard({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'redCards': FieldValue.increment(-1)});
  }

  @override
  void deleteYellowCard({String playerId}) {
    _firebaseFirestore
        .collection(DbPaths.players)
        .doc(playerId)
        .update({'yellowCards': FieldValue.increment(-1)});
  }

}
