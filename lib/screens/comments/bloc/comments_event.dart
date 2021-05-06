part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends CommentsEvent {
  final Post post;

  const FetchComments({@required this.post});

  @override
  List<Object> get props => [post];
}

class UpdateComments extends CommentsEvent {
  final List<Comment> comments;

  const UpdateComments({@required this.comments});

  @override
  List<Object> get props => [comments];
}

class PostComment extends CommentsEvent {
  final String content;

  const PostComment({@required this.content});

  @override
  List<Object> get props => [content];
}