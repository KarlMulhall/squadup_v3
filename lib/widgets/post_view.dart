import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/screens/comments/comments_screen.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';
import 'package:squadup_v3/extensions/datetime_extension.dart';

class PostView extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final VoidCallback onLike;
  final bool recentlyLiked;

  const PostView({
    Key key,
    @required this.post,
    @required this.isLiked,
    @required this.onLike,
    this.recentlyLiked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.tealAccent[400],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              ProfileScreen.routeName,
              arguments: ProfileScreenArgs(userId: post.author.id),
            ),
            child: Row(
              children: [
                UserProfileImage(
                  radius: 18.0,
                  profileImageUrl: post.author.profileImageUrl,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    post.author.username,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1DE9B6),
                    ),
                  ),
                ),
                Text(
                  post.date.timeAgo(),
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: onLike,
          child: CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 2.25,
            width: double.infinity,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: isLiked
                  ? const Icon(Icons.thumb_up, color: Color(0xFF1DE9B6))
                  : const Icon(
                      Icons.thumb_up_outlined,
                      color: Color(0xFF8C9EFF),
                    ),
              onPressed: onLike,
            ),
            Text(
              '${recentlyLiked ? post.likes + 1 : post.likes} likes',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color(0xFF1DE9B6),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.chat_rounded,
                color: Color(0xFF8C9EFF),
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                CommentsScreen.routeName,
                arguments: CommentsScreenArgs(post: post),
              ),
            ),
            Text(
              'Comment',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color(0xFF1DE9B6),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.author.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0,
                        color: Color(0xFF1DE9B6),
                      ),
                    ),
                    const TextSpan(
                      text: '\n',
                    ),
                    TextSpan(
                      text: post.caption,
                      style: TextStyle(
                        color: Colors.indigo[200],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
        Divider(
          color: Colors.tealAccent[400],
        ),
      ],
    );
  }
}
