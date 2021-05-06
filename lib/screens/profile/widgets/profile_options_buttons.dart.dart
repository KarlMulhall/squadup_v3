import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/create_player/create_player_screen.dart';
import 'package:squadup_v3/screens/messaging/messaging_screen.dart';

class ProfileOptionsButtons extends StatelessWidget {
  final bool isCurrentUser;

  const ProfileOptionsButtons({
    Key key,
    @required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? Container(
            width: 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    CreatePlayerScreen.routeName,
                    arguments: CreatePlayerScreenArgs(context: context),
                  ),
                  highlightColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  child: const Icon(
                    Icons.person_add,
                    color: Colors.indigo,
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    MessagingScreen.routeName,
                    arguments: CreatePlayerScreenArgs(context: context),
                  ),
                  highlightColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  child: const Icon(
                    Icons.mail,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          )
        : Opacity(opacity: 0.0, child: Container());
  }
}
