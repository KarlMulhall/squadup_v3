import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/cubits/player_stats/player_stats_cubit.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';
import 'package:squadup_v3/screens/edit_player/cubit/edit_player_cubit.dart';
import 'package:squadup_v3/screens/profile/bloc/profile_bloc.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:squadup_v3/widgets/player_stat.dart';
import 'package:squadup_v3/widgets/player_stat_large.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';

class EditPlayerScreenArgs {
  final BuildContext context;
  final Player player;

  const EditPlayerScreenArgs({
    @required this.context,
    @required this.player,
  });
}

class EditPlayerScreen extends StatefulWidget {
  static const String routeName = '/editPlayer';

  static Route route({@required EditPlayerScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditPlayerCubit>(
        create: (_) => EditPlayerCubit(
          playerRepository: context.read<PlayerRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditPlayerScreen(player: args.player),
      ),
    );
  }

  final Player player;
  EditPlayerScreen({
    Key key,
    @required this.player,
  }) : super(key: key);

  @override
  _EditPlayerScreenState createState() => _EditPlayerScreenState();
}

class _EditPlayerScreenState extends State<EditPlayerScreen> {
  int goals = 0;
  int appearances = 0;
  int assists = 0;
  int cleanSheets = 0;
  int yellowCards = 0;
  int redCards = 0;

  @override
  void initState() {
    goals = widget.player.goals;
    appearances = widget.player.appearances;
    assists = widget.player.assists;
    cleanSheets = widget.player.cleanSheets;
    yellowCards = widget.player.yellowCards;
    redCards = widget.player.redCards;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(player);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Player'),
        ),
        body: BlocConsumer<EditPlayerCubit, EditPlayerState>(
          listener: (context, state) {
            // if the change was successful and status = 'success' then pop from stack and return to profile screen
            if (state.status == EditPlayerStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditPlayerStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditPlayerStatus.submitting)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 10.0),
                  Container(
                    child: UserProfileImage(
                      radius: 60.0,
                      profileImageUrl: widget.player.imageUrl,
                      profileImage: state.playerImage,
                    ),
                    alignment: AlignmentDirectional.center,
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.player.name,
                          style: TextStyle(
                            color: Colors.tealAccent[400],
                            fontSize: 25.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 28.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.indigo[300],
                              ),
                              onPressed: () {
                                try {
                                  context
                                      .read<PlayerStatsCubit>()
                                      .addAppearance(player: widget.player);
                                  setState(() {
                                    appearances++;
                                  });
                                } catch (err) {}
                              },
                            ),
                            PlayerStatLarge(
                              count: appearances,
                              label: 'Apps',
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.indigo[300],
                              ),
                              onPressed: () {
                                try {
                                  if (appearances != 0) {
                                    context
                                        .read<PlayerStatsCubit>()
                                        .deleteAppearance(
                                            player: widget.player);
                                    setState(() {
                                      appearances--;
                                    });
                                  }
                                } catch (err) {}
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.tealAccent[400],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //
                            // GOALS
                            //
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      context
                                          .read<PlayerStatsCubit>()
                                          .addGoal(player: widget.player);
                                      setState(() {
                                        goals++;
                                      });
                                    } catch (err) {}
                                  },
                                ),
                                PlayerStat(
                                  count: goals,
                                  label: 'Goals Scored',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      if (goals != 0) {
                                        context
                                            .read<PlayerStatsCubit>()
                                            .deleteGoal(player: widget.player);
                                        setState(() {
                                          goals--;
                                        });
                                      }
                                    } catch (err) {}
                                  },
                                ),
                              ],
                            ),

                            //
                            // ASSISTS
                            //

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      context
                                          .read<PlayerStatsCubit>()
                                          .addAssist(player: widget.player);
                                      setState(() {
                                        assists++;
                                      });
                                    } catch (err) {}
                                  },
                                ),
                                PlayerStat(
                                  count: assists,
                                  label: 'Assists',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      if (assists != 0) {
                                        context
                                            .read<PlayerStatsCubit>()
                                            .deleteAssist(
                                                player: widget.player);
                                        setState(() {
                                          assists--;
                                        });
                                      }
                                    } catch (err) {}
                                  },
                                ),
                              ],
                            ),

                            //
                            // CLEAN SHEETS
                            //

                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      context
                                          .read<PlayerStatsCubit>()
                                          .addCleanSheet(player: widget.player);
                                      setState(() {
                                        cleanSheets++;
                                      });
                                    } catch (err) {}
                                  },
                                ),
                                PlayerStat(
                                  count: cleanSheets,
                                  label: 'Clean Sheets',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      if (cleanSheets != 0) {
                                        context
                                            .read<PlayerStatsCubit>()
                                            .deleteCleanSheet(
                                                player: widget.player);
                                        setState(() {
                                          cleanSheets--;
                                        });
                                      }
                                    } catch (err) {}
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.tealAccent[400],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //
                            // GOALS
                            //
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      context
                                          .read<PlayerStatsCubit>()
                                          .addYellowCard(player: widget.player);
                                      setState(() {
                                        yellowCards++;
                                      });
                                    } catch (err) {}
                                  },
                                ),
                                PlayerStat(
                                  count: yellowCards,
                                  label: 'Yellow Cards',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      if (yellowCards != 0) {
                                        context
                                            .read<PlayerStatsCubit>()
                                            .deleteYellowCard(
                                                player: widget.player);
                                        setState(() {
                                          yellowCards--;
                                        });
                                      }
                                    } catch (err) {}
                                  },
                                ),
                              ],
                            ),

                            //
                            // RED CARDS
                            //

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      context
                                          .read<PlayerStatsCubit>()
                                          .addRedCard(player: widget.player);
                                      setState(() {
                                        redCards++;
                                      });
                                    } catch (err) {}
                                  },
                                ),
                                PlayerStat(
                                  count: redCards,
                                  label: 'Red Cards',
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.indigo[300],
                                  ),
                                  onPressed: () {
                                    try {
                                      if (redCards != 0) {
                                        context
                                            .read<PlayerStatsCubit>()
                                            .deleteRedCard(
                                                player: widget.player);
                                        setState(() {
                                          redCards--;
                                        });
                                      }
                                    } catch (err) {}
                                  },
                                ),
                              ],
                            ),
                            // RaisedButton(
                            //   elevation: 1.0,
                            //   color: Theme.of(context).primaryColor,
                            //   textColor: Colors.white,
                            //   onPressed: () => _submitForm(
                            //     context,
                            //     // state.playerImage,
                            //     state.status == EditPlayerStatus.submitting,
                            //   ),
                            //   child: const Text('Update'),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
