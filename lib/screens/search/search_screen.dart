import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/screens/search/cubit/search_cubit.dart';
import 'package:squadup_v3/widgets/center_text.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              hintText: 'Search...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  context.read<SearchCubit>().clearSearch();
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchStatus.error:
                return CenterText(text: state.failure.message);
              case SearchStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SearchStatus.loaded:
                return state.users.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = state.users[index];
                          return ListTile(
                            leading: UserProfileImage(
                              profileImageUrl: user.profileImageUrl,
                              radius: 22.0,
                            ),
                            title: Text(
                              user.username,
                              style: const TextStyle(
                                  fontSize: 16.0, color: Color(0xFF1DE9B6),),
                            ),
                            onTap: () => Navigator.of(context).pushNamed(
                                ProfileScreen.routeName,
                                arguments: ProfileScreenArgs(userId: user.id)),
                          );
                        },
                      )
                    : CenterText(text: 'No users found...');
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
