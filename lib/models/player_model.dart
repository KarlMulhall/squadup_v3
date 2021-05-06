import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:squadup_v3/config/dbPaths.dart';
import 'package:squadup_v3/models/models.dart';

enum Position { goalkeeper, defender, midfielder, forward }

class Player extends Equatable {
  final String id;
  final User author;
  final String imageUrl;
  final String name;
  final int appearances;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final int cleanSheets;

  const Player({
    this.id,
    @required this.author,
    @required this.imageUrl,
    @required this.name,
    @required this.appearances,
    @required this.goals,
    @required this.assists,
    @required this.yellowCards,
    @required this.redCards,
    @required this.cleanSheets,
  });

  static const empty = Player(
    id: '',
    author: User.empty,
    imageUrl: '',
    name: '',
    appearances: 0,
    goals: 0,
    assists: 0,
    yellowCards: 0,
    redCards: 0,
    cleanSheets: 0,
  );

  @override
  List<Object> get props => [
        id,
        author,
        imageUrl,
        name,
        appearances,
        goals,
        assists,
        yellowCards,
        redCards,
        cleanSheets,
      ];

  Player copyWith({
    String id,
    User author,
    String imageUrl,
    String name,
    int appearances,
    int goals,
    int assists,
    int yellowCards,
    int redCards,
    int cleanSheets,
  }) {
    return Player(
      id: id ?? this.id,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      appearances: appearances ?? this.appearances,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      cleanSheets: cleanSheets ?? this.cleanSheets,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(DbPaths.users).doc(author.id),
      'imageUrl': imageUrl,
      'name': name,
      'appearances': appearances,
      'goals': goals,
      'assists': assists,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'cleanSheets': cleanSheets,
    };
  }

  static Future<Player> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author'] as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Player(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          name: data['name'] ?? '',
          appearances: (data['appearances'] ?? 0).toInt(),
          goals: (data['goals'] ?? 0).toInt(),
          assists: (data['assists'] ?? 0).toInt(),
          yellowCards: (data['yellowCards'] ?? 0).toInt(),
          redCards: (data['redCards'] ?? 0).toInt(),
          cleanSheets: (data['cleanSheets'] ?? 0).toInt(),
        );
      }
    }
    return null;
  }
}
