import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:squadup_v3/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepo;
  final PostRepository _postRepo;
  final PlayerRepository _playerRepo;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  StreamSubscription<List<Future<Post>>> _postsSub;
  StreamSubscription<List<Future<Player>>> _playersSub;

  ProfileBloc({
    @required UserRepository userRepository,
    @required PostRepository postRepository,
    @required PlayerRepository playerRepository,
    @required AuthBloc authBloc,
    @required LikedPostsCubit likedPostsCubit,
  })  : _userRepo = userRepository,
        _postRepo = postRepository,
        _playerRepo = playerRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(ProfileState.initial());

  @override
  Future<void> close() {
    _postsSub.cancel();
    _playersSub.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else /* if (event is ProfileLoadSubbedPlayer) {
      yield* _mapProfileLoadSubbedPlayerToState(event);
    } else */ if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePlayers) {
      yield* _mapProfileUpdatePlayersToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    } else if (event is ProfileFollowUser) {
      yield* _mapProfileFollowUserToState();
    } else if (event is ProfileUnfollowUser) {
      yield* _mapProfileUnfollowUserToState();
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
    ProfileLoadUser event,
  ) async* {
    try {
      final user = await _userRepo.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;

      final isFollowing = await _userRepo.isFollowing(
        userId: _authBloc.state.user.uid,
        otherUserId: event.userId,
      );

      _postsSub?.cancel();
      _postsSub = _postRepo
          .getUserPosts(userId: event.userId)
          .listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      });

      _playersSub?.cancel();
      _playersSub = _playerRepo
          .getUserPlayers(userId: event.userId)
          .listen((players) async {
        final allPlayers = await Future.wait(players);
        add(ProfileUpdatePlayers(players: allPlayers));
      });

      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        isFollowing: isFollowing,
        status: ProfileStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(message: 'Unable to load this profile.'),
      );
    }
  }

  // Stream<ProfileState> _mapProfileLoadSubbedPlayerToState(
  //   ProfileLoadSubbedPlayer event,
  // ) async* {
  //   try {
  //     final player = await _playerRepo.getPlayerWithId(playerId: event.playerId);
  //     final isCurrentUser = _authBloc.state.user.uid == event.userId;

  //     final isFollowing = await _userRepo.isFollowing(
  //       userId: _authBloc.state.user.uid,
  //       otherUserId: event.userId,
  //     );

  //     _postsSub?.cancel();
  //     _postsSub = _postRepo
  //         .getUserPosts(userId: event.userId)
  //         .listen((posts) async {
  //       final allPosts = await Future.wait(posts);
  //       add(ProfileUpdatePosts(posts: allPosts));
  //     });

  //     _playersSub?.cancel();
  //     _playersSub = _playerRepo
  //         .getUserPlayers(userId: event.userId)
  //         .listen((players) async {
  //       final allPlayers = await Future.wait(players);
  //       add(ProfileUpdatePlayers(players: allPlayers));
  //     });

  //     yield state.copyWith(
  //       user: user,
  //       isCurrentUser: isCurrentUser,
  //       isFollowing: isFollowing,
  //       status: ProfileStatus.loaded,
  //     );
  //   } catch (err) {
  //     yield state.copyWith(
  //       status: ProfileStatus.error,
  //       failure: Failure(message: 'Unable to load this profile.'),
  //     );
  //   }
  // }

  Stream<ProfileState> _mapProfileToggleGridViewToState(
      ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(
    ProfileUpdatePosts event,
  ) async* {
    yield state.copyWith(posts: event.posts);
    final likedPostIds = await _postRepo.getLikedPostIds(
      userId: _authBloc.state.user.uid,
      posts: event.posts,
    );
    _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
  }

  Stream<ProfileState> _mapProfileUpdatePlayersToState(
    ProfileUpdatePlayers event,
  ) async* {
    yield state.copyWith(players: event.players);
    // final likedPostIds = await _postRepo.getLikedPostIds(
    //   userId: _authBloc.state.user.uid,
    //   posts: event.posts,
    // );
    // _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);
  }

  Stream<ProfileState> _mapProfileFollowUserToState() async* {
    try {
      _userRepo.followUser(
        userId: _authBloc.state.user.uid,
        followUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers + 1);
      yield state.copyWith(user: updatedUser, isFollowing: true);
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      );
    }
  }

  Stream<ProfileState> _mapProfileUnfollowUserToState() async* {
    try {
      _userRepo.unfollowUser(
        userId: _authBloc.state.user.uid,
        unfollowUserId: state.user.id,
      );
      final updatedUser =
          state.user.copyWith(followers: state.user.followers - 1);
      yield state.copyWith(user: updatedUser, isFollowing: false);
    } catch (err) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure:
            const Failure(message: 'Something went wrong! Please try again.'),
      );
    }
  }
}
