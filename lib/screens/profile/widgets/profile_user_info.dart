import 'package:flutter/material.dart';

class ProfileUserInfo extends StatelessWidget {
  final String username;
  final String bio;

  const ProfileUserInfo({
    Key key,
    @required this.username,
    @required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1DE9B6),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          bio,
          style: const TextStyle(
            fontSize: 15.0,
            color: Color(0xFF1DE9B6),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Color(0xFF1DE9B6),
        ),
      ],
    );
  }
}
