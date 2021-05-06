import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/failure_model.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepo;
  final StorageRepository _storageRepo;
  final AuthBloc _authBloc;

  CreatePostCubit({
    @required PostRepository postRepository,
    @required StorageRepository storageRepository,
    @required AuthBloc authBloc,
  })  : _postRepo = postRepository,
        _storageRepo = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final postImageUrl =
          await _storageRepo.uploadPostImage(image: state.postImage);

      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(),
      );

      await _postRepo.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));
      reset();
    } catch (err) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          failure: const Failure(message: 'Unable to create post.'),
        ),
      );
    }
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
