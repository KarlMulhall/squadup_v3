part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final List<Player> players;
  final List<Post> posts;
  final Player subbedPlayer;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.user,
    @required this.posts,
    @required this.players,
    @required this.subbedPlayer,
    @required this.isCurrentUser,
    @required this.isGridView,
    @required this.isFollowing,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      posts: [],
      players: [],
      subbedPlayer: Player.empty,
      isCurrentUser: false,
      isGridView: true,
      isFollowing: false,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        user,
        posts,
        players,
        subbedPlayer,
        isCurrentUser,
        isGridView,
        isFollowing,
        status,
        failure
      ];

  ProfileState copyWith({
    User user,
    List<Post> posts,
    List<Player> players,
    Player subbedPlayer,
    bool isCurrentUser,
    bool isGridView,
    bool isFollowing,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      players: players ?? this.players,
      subbedPlayer: subbedPlayer ?? this.subbedPlayer,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
