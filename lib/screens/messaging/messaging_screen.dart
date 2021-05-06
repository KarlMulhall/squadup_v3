import 'package:flutter/material.dart';
import 'package:squadup_v3/screens/chat_search/search_chat_users_screen.dart';

class MessagingScreen extends StatelessWidget {
  static const String routeName = '/messaging';
  
  // static Route route({@required MessagingScreenArgs args}) {
  //   return MaterialPageRoute(
  //     settings: const RouteSettings(name: routeName),
  //     builder: (context) => BlocProvider<MessagingCubit>(
  //       create: (_) => MessagingCubit(
  //         userRepository: context.read<UserRepository>(),
  //         storageRepository: context.read<StorageRepository>(),
  //         authBloc: args.context.read<AuthBloc>(),
  //       ),
  //       child: MessagingScreen(),
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchChatUsersScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Messaging'),
      ),
    );
  }
}
