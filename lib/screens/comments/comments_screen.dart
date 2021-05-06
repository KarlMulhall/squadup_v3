import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/models/models.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:squadup_v3/screens/comments/bloc/comments_bloc.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/widgets/error_dialog.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';
import 'package:intl/intl.dart';

class CommentsScreenArgs {
  final Post post;

  const CommentsScreenArgs({@required this.post});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';

  static Route route({@required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (context) => CommentsBloc(
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(FetchComments(post: args.post)),
        child: CommentsScreen(),
      ),
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentsStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Comments')),
          body: ListView.builder(
            padding: const EdgeInsets.only(bottom: 60.0),
            itemCount: state.comments.length,
            itemBuilder: (BuildContext context, int index) {
              final comment = state.comments[index];
              return ListTile(
                leading: UserProfileImage(
                  radius: 22.0,
                  profileImageUrl: comment.author.profileImageUrl,
                ),
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: comment.author.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1DE9B6),
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: comment.content,
                        style: const TextStyle(color: Color(0xFF7986CB)),
                      ),
                    ],
                  ),
                ),
                
                subtitle: Text(
                  DateFormat.yMd().add_jm().format(comment.dateTime),
                  style: TextStyle(
                    color: Colors.indigo[300],
                    fontWeight: FontWeight.w300,
                  ),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  ProfileScreen.routeName,
                  arguments: ProfileScreenArgs(userId: comment.author.id),
                ),  
              );
            },
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == CommentsStatus.submitting)
                  const LinearProgressIndicator(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Write a comment...'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.indigo[300],
                      onPressed: () {
                        final content = _commentController.text.trim();
                        if (content.isNotEmpty) {
                          context
                              .read<CommentsBloc>()
                              .add(PostComment(content: content));
                          _commentController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
