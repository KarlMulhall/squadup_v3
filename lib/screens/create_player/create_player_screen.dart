import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/helpers/image_helper.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';
import 'package:squadup_v3/screens/create_player/cubit/create_player_cubit.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class CreatePlayerScreenArgs {
  final BuildContext context;

  const CreatePlayerScreenArgs({
    @required this.context,
  });
}

class CreatePlayerScreen extends StatelessWidget {
  static const String routeName = '/createPlayer';

  static Route route({@required CreatePlayerScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CreatePlayerCubit>(
        create: (_) => CreatePlayerCubit(
          playerRepository: context.read<PlayerRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authBloc: args.context.read<AuthBloc>(),
        ),
        child: CreatePlayerScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Player'),
        ),
        body: BlocConsumer<CreatePlayerCubit, CreatePlayerState>(
          listener: (context, state) {
            if (state.status == CreatePlayerStatus.success) {
              _formKey.currentState.reset();
              context.read<CreatePlayerCubit>().reset();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Player Created'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            } else if (state.status == CreatePlayerStatus.error) {
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
                  GestureDetector(
                    onTap: () => _selectPlayerImage(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: state.playerImage != null
                          ? Image.file(
                              state.playerImage,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.person_add_alt_1_outlined,
                              color: Colors.grey,
                              size: 120.0,
                            ),
                    ),
                  ),
                  if (state.status == CreatePlayerStatus.submitting)
                    const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Player Name..',
                              filled: true,
                              fillColor: Colors.grey[300],
                            ),
                            style: TextStyle(
                              color: Colors.indigo[400],
                              decorationColor: Colors.indigo[400],
                            ),
                            onChanged: (value) => context
                                .read<CreatePlayerCubit>()
                                .nameChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Name cannot be empty'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          RaisedButton(
                            onPressed: () => _submitForm(
                              context,
                              state.playerImage,
                              state.status == CreatePlayerStatus.submitting,
                            ),
                            elevation: 1.0,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: const Text('Create'),
                          )
                        ],
                      ),
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

  void _selectPlayerImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Create Player',
    );
    if (pickedFile != null) {
      context.read<CreatePlayerCubit>().playerImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, File playerImage, bool isSubmitting) {
    if (_formKey.currentState.validate() &&
        playerImage != null &&
        !isSubmitting) {
      context.read<CreatePlayerCubit>().submit();
    }
  }
}
