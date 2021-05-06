import 'package:flutter/material.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';

class PlayerView extends StatelessWidget {
  final Player player;

  const PlayerView({
    Key key,
    @required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              UserProfileImage(
                radius: 25.0,
                profileImageUrl: player.imageUrl,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  player.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.tealAccent[400],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stats(count: player.appearances, label: 'APPS'),
              _Stats(count: player.goals, label: 'GOALS'),
              _Stats(count: player.assists, label: 'ASSISTS'),
              _Stats(count: player.yellowCards, label: 'YLW CARDS'),
              _Stats(count: player.redCards, label: 'RED CARDS'),
              _Stats(count: player.cleanSheets, label: 'CLN SHEETS'),
            ],
          ),
          const SizedBox(height: 10.0),
          Divider(
            color: Colors.tealAccent[400],
          ),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final int count;
  final String label;

  const _Stats({
    Key key,
    @required this.count,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DE9B6),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF26A69A),
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}
