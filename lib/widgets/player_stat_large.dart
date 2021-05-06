import 'package:flutter/material.dart';

class PlayerStatLarge extends StatelessWidget {
  final int count;
  final String label;

  const PlayerStatLarge({
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
            fontSize: 25.0,
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DE9B6),
          ),
        ),
      ],
    );
  }
}
