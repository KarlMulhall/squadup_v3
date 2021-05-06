import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostRepository _postRepo;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Comment>>> _commentsSub;

  CommentsBloc({
    @required PostRepository postRepository,
    @required AuthBloc authBloc,
  })  : _postRepo = postRepository,
        _authBloc = authBloc,
        super(CommentsState.initial());

  Future<void> close() {
    _commentsSub.cancel();
    return super.close();
  }

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    if (event is FetchComments) {
      yield* _mapFetchCommentsToState(event);
    } else if (event is UpdateComments) {
      yield* _mapUpdateCommentsToState(event);
    } else if (event is PostComment) {
      yield* _mapPostCommentToState(event);
    }
  }

  Stream<CommentsState> _mapFetchCommentsToState(
    FetchComments event,
  ) async* {
    yield state.copyWith(status: CommentsStatus.loading);
    try {
      _commentsSub?.cancel();
      _commentsSub = _postRepo
          .getPostComments(postId: event.post.id)
          .listen((comments) async {
        final allComments = await Future.wait(comments);
        add(UpdateComments(comments: allComments));
      });

      yield state.copyWith(post: event.post, status: CommentsStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(
          message: 'Unable to load this posts comments',
        ),
      );
    }
  }

  Stream<CommentsState> _mapUpdateCommentsToState(
    UpdateComments event,
  ) async* {
    yield state.copyWith(comments: event.comments);
  }

  Stream<CommentsState> _mapPostCommentToState(
    PostComment event,
  ) async* {
    yield state.copyWith(status: CommentsStatus.submitting);
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final comment = Comment(
        postId: state.post.id,
        author: author,
        content: event.content,
        dateTime: DateTime.now(),
      );

      await _postRepo.createComment(post: state.post, comment: comment);

      yield state.copyWith(status: CommentsStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: CommentsStatus.error,
        failure: const Failure(
          message: 'Unable to posts comment',
        ),
      );
    }
  }
}
