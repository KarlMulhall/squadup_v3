import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/profile/widgets/profile_options_buttons.dart.dart';
import 'package:squadup_v3/screens/profile/widgets/widgets.dart';

class ProfileStats extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;
  final int posts;
  final int followers;
  final int following;

  const ProfileStats({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.posts,
    @required this.followers,
    @required this.following,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // _Stats(count: posts, label: 'posts'),
              _Stats(count: followers, label: 'followers'),
              _Stats(count: following, label: 'following'),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ProfileButton(
              isCurrentUser: isCurrentUser,
              isFollowing: isFollowing,
            ),
          ),
          ProfileOptionsButtons(isCurrentUser: isCurrentUser),
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
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1DE9B6),
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF26A69A)),
        ),
      ],
    );
  }
}
