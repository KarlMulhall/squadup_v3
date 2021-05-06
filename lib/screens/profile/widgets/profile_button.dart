import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/edit_profile/edit_profile_screen.dart';
import 'package:squadup_v3/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? FlatButton(
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileScreenArgs(context: context),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0),
            ),
          )
        : FlatButton(
            onPressed: () => isFollowing
                ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
                : context.read<ProfileBloc>().add(ProfileFollowUser()),
            color: isFollowing
                ? Colors.deepPurple[900]
                : Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(
              isFollowing ? 'Unfollow' : 'Follow',
              style: TextStyle(fontSize: 16.0),
            ),
          );
  }
}
