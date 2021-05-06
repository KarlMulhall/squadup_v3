import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PostRepository _postRepo;
  final AuthBloc _authBloc;
  final LikedPostsCubit _likedPostsCubit;

  HomeBloc(
      {@required PostRepository postRepository,
      @required AuthBloc authBloc,
      @required LikedPostsCubit likedPostsCubit})
      : _postRepo = postRepository,
        _authBloc = authBloc,
        _likedPostsCubit = likedPostsCubit,
        super(HomeState.initial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeFetchPosts) {
      yield* _mapFetchPostsToState();
    } else if (event is HomePaginatePosts) {
      yield* _mapPaginatePostsToState();
    }
  }

  Stream<HomeState> _mapFetchPostsToState() async* {
    yield state.copyWith(posts: [], status: HomeStatus.loading);
    try {
      final posts =
          await _postRepo.getUserFeed(userId: _authBloc.state.user.uid);

      _likedPostsCubit.clearAllLikedPosts();

      final likedPostIds = await _postRepo.getLikedPostIds(
        userId: _authBloc.state.user.uid,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      yield state.copyWith(posts: posts, status: HomeStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: HomeStatus.error,
        failure: const Failure(message: 'Unable to load feed..'),
      );
    }
  }

  Stream<HomeState> _mapPaginatePostsToState() async* {
    yield state.copyWith(status: HomeStatus.paginating);
    try {
      final lastPostId = state.posts.isNotEmpty ? state.posts.last.id : null;

      final posts = await _postRepo.getUserFeed(
        userId: _authBloc.state.user.uid,
        lastPostId: lastPostId,
      );
      final updatedPosts = List<Post>.from(state.posts)..addAll(posts);

      final likedPostIds = await _postRepo.getLikedPostIds(
        userId: _authBloc.state.user.uid,
        posts: posts,
      );
      _likedPostsCubit.updateLikedPosts(postIds: likedPostIds);

      yield state.copyWith(posts: updatedPosts, status: HomeStatus.loaded);
    } catch (err) {
      // print(err);
      yield state.copyWith(
        status: HomeStatus.error,
        failure: const Failure(message: 'Unable to load feed..'),
      );
    }
  }
}
