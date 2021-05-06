import 'package:flutter/material.dart';

class PlayerStat extends StatelessWidget {
  final int count;
  final String label;

  const PlayerStat({
    Key key,
    @required this.count,
    @required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF26A69A),
            fontSize: 15.0,
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DE9B6),
          ),
        ),
      ],
    );
  }
}
