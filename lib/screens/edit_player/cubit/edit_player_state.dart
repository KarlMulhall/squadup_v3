part of 'edit_player_cubit.dart';

enum EditPlayerStatus { initial, submitting, success, error }

class EditPlayerState extends Equatable {
  final File playerImage;
  final String name;
  final int appearances;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final int cleanSheets;
  final EditPlayerStatus status;
  final Failure failure;

  const EditPlayerState({
    @required this.playerImage,
    @required this.name,
    @required this.appearances,
    @required this.goals,
    @required this.assists,
    @required this.yellowCards,
    @required this.redCards,
    @required this.cleanSheets,
    @required this.status,
    @required this.failure,
  });

  factory EditPlayerState.initial() {
    return EditPlayerState(
      playerImage: null,
      name: '',
      appearances: 0,
      goals: 0,
      assists: 0,
      yellowCards: 0,
      redCards: 0,
      cleanSheets: 0,
      status: EditPlayerStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        playerImage,
        name,
        appearances,
        goals,
        assists,
        yellowCards,
        redCards,
        cleanSheets,
        status,
        failure,
      ];

  EditPlayerState copyWith({
    File playerImage,
    String name,
    int appearances,
    int goals,
    int assists,
    int yellowCards,
    int redCards,
    int cleanSheets,
    EditPlayerStatus status,
    Failure failure,
  }) {
    return EditPlayerState(
      playerImage: playerImage ?? this.playerImage,
      name: name ?? this.name,
      appearances: appearances ?? this.appearances,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      yellowCards: yellowCards ?? this.yellowCards,
      redCards: redCards ?? this.redCards,
      cleanSheets: cleanSheets ?? this.cleanSheets,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
