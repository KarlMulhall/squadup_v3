import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/screens/chat_search/cubit/search_chat_users_cubit.dart';
import 'package:squadup_v3/screens/profile/profile_screen.dart';
import 'package:squadup_v3/widgets/center_text.dart';
import 'package:squadup_v3/widgets/user_profile_image.dart';

class SearchChatUsersScreen extends StatefulWidget {
  static const String routeName = '/chatSearch';

  @override
  _SearchChatUsersScreenState createState() => _SearchChatUsersScreenState();
}

class _SearchChatUsersScreenState extends State<SearchChatUsersScreen> {
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
                  context.read<SearchChatUsersCubit>().clearSearch();
                  _textController.clear();
                },
              ),
            ),
            textInputAction: TextInputAction.search,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<SearchChatUsersCubit>().searchUsers(value.trim());
              }
            },
          ),
        ),
        body: BlocBuilder<SearchChatUsersCubit, SearchChatUsersState>(
          builder: (context, state) {
            switch (state.status) {
              case SearchChatUsersStatus.error:
                return CenterText(text: state.failure.message);
              case SearchChatUsersStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case SearchChatUsersStatus.loaded:
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
                              style: const TextStyle(fontSize: 16.0),
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/blocs.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/models/user_data.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/services/database_service.dart';
import 'package:provider/provider.dart';

class SearchChatUsersScreen extends StatefulWidget {
  @override
  _SearchChatUsersScreenState createState() => _SearchChatUsersScreenState();
}

class _SearchChatUsersScreenState extends State<SearchChatUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  List<User> _selectedUsers = [];
  String currentUserId;

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search',
              prefixIcon: Icon(
                Icons.search,
                size: 30.0,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  print(currentUserId);
                },
              ),
              filled: true,
            ),
            onSubmitted: (input) async {
              if (input.trim().isNotEmpty) {
                List<User> users =
                    await Provider.of<DatabaseService>(context, listen: false)
                        .searchUsers(currentUserId, input);
              }
            },
          )
        ],
      ),
    );
  }

  String _clearSearch() {}
}
*/
