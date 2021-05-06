import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/edit_profile/edit_profile_screen.dart';
import 'package:squadup_v3/screens/notifications/notifications_screen.dart';

class ProfileNotifsButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileNotifsButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? FlatButton(
            onPressed: () => Navigator.of(context).pushNamed(
              NotificationsScreen.routeName,
              arguments: EditProfileScreenArgs(context: context),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : null;
  }
}
