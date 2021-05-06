import 'package:squadup_v3/models/models.dart';

abstract class BasePostRepository {

  //create methods
  Future<void> createPost({Post post});
  Future<void> createComment({Post post, Comment comment});
  void createLike({Post post, String userId});

  //get methods
  Stream<List<Future<Post>>> getUserPosts({String userId});
  Stream<List<Future<Comment>>> getPostComments({String postId});
  Future<List<Post>> getUserFeed({String userId, String lastPostId});
  Future<Set<String>> getLikedPostIds({String userId, List<Post> posts});

  //delete methods
  void deleteLike({String postId, String userId});
}
