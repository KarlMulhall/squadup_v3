part of 'home_bloc.dart';

enum HomeStatus { initial, loading, loaded, paginating, error }

class HomeState extends Equatable {
  final List<Post> posts;
  final HomeStatus status;
  final Failure failure;

  const HomeState({
    @required this.posts,
    @required this.status,
    @required this.failure,
  });

  factory HomeState.initial() {
    return const HomeState(
      posts: [],
      status: HomeStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [posts, status, failure];

  HomeState copyWith({
    List<Post> posts,
    HomeStatus status,
    Failure failure,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
