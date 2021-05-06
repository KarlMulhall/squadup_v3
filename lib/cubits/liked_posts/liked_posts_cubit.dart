import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'liked_posts_state.dart';

class LikedPostsCubit extends Cubit<LikedPostsState> {
  final PostRepository _postRepo;
  final AuthBloc _authBloc;

  LikedPostsCubit({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepo = postRepository,
        _authBloc = authBloc,
        super(LikedPostsState.initial());

  void updateLikedPosts({@required Set<String> postIds}) {
    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds),
      ),
    );
  }

  void likePost({@required Post post}) {
    _postRepo.createLike(post: post, userId: _authBloc.state.user.uid);

    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
          ..add(post.id),
      ),
    );
  }

  void unlikePost({@required Post post}) {
    _postRepo.deleteLike(
        postId: post.id, userId: _authBloc.state.user.uid);

    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
          ..remove(post.id),
      ),
    );
  }

  void clearAllLikedPosts() {
    emit(LikedPostsState.initial());
  }
}
