part of 'create_player_cubit.dart';

enum CreatePlayerStatus { initial, submitting, success, error }

class CreatePlayerState extends Equatable {
  final File playerImage;
  final String name;
  final CreatePlayerStatus status;
  final Failure failure;

  const CreatePlayerState({
    @required this.playerImage,
    @required this.name,
    @required this.status,
    @required this.failure,
  });

  factory CreatePlayerState.initial() {
    return const CreatePlayerState(
      playerImage: null,
      name: '',
      status: CreatePlayerStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [playerImage, name, status, failure];

  CreatePlayerState copyWith({
    File playerImage,
    String name,
    CreatePlayerStatus status,
    Failure failure,
  }) {
    return CreatePlayerState(
      playerImage: playerImage ?? this.playerImage,
      name: name ?? this.name,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
