import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/blocs/auth/auth_bloc.dart';
import 'package:squadup_v3/blocs/simple_bloc_observer.dart';
import 'package:squadup_v3/config/custom_router.dart';
import 'package:squadup_v3/cubits/liked_posts/liked_posts_cubit.dart';
import 'package:squadup_v3/cubits/player_stats/player_stats_cubit.dart';
import 'package:squadup_v3/models/user_data.dart';
import 'package:squadup_v3/repositories/auth/auth_repository.dart';
import 'package:squadup_v3/repositories/notification/notification_repository.dart';
import 'package:squadup_v3/repositories/player/player_repository.dart';
import 'package:squadup_v3/repositories/post/post_repository.dart';
import 'package:squadup_v3/repositories/storage/storage_repository.dart';
import 'package:squadup_v3/repositories/user/user_repository.dart';
import 'package:squadup_v3/screens/splash/splash_screen.dart';
import 'package:squadup_v3/services/database_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // sets stringify to constant true if the app is compiled in debug mode
  EquatableConfig.stringify = kDebugMode;

  // sets the apps bloc observer to the "SimpleBlocObserver" in lib/blocs
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

// Providers to be able to access these repositories and blocs anywhere in the
// app.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // AuthRepository().logOut();
    // context.read<AuthRepository>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserData(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
      ],
      // Provides all the repositories to the app
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (_) => AuthRepository(),
          ),
          RepositoryProvider<UserRepository>(
            create: (_) => UserRepository(),
          ),
          RepositoryProvider<StorageRepository>(
            create: (_) => StorageRepository(),
          ),
          RepositoryProvider<PostRepository>(
            create: (_) => PostRepository(),
          ),
          RepositoryProvider<PlayerRepository>(
            create: (_) => PlayerRepository(),
          ),
          RepositoryProvider<NotificationRepository>(
            create: (_) => NotificationRepository(),
          ),
        ],
        // provides all of the blocs to the app
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<PlayerStatsCubit>(
              create: (context) => PlayerStatsCubit(
                // authBloc: context.read<AuthBloc>(),
                playerRepository: context.read<PlayerRepository>(),
              ),
            ),
            BlocProvider<LikedPostsCubit>(
              create: (context) => LikedPostsCubit(
                authBloc: context.read<AuthBloc>(),
                // userRepository: context.read<UserRepository>(),
                postRepository: context.read<PostRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'SquadUp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              scaffoldBackgroundColor: Color(0xFF263238),
              appBarTheme: AppBarTheme(
                  brightness: Brightness.dark,
                  color: Color(0xFF263238),
                  iconTheme: const IconThemeData(color: Color(0xFF1DE9B6)),
                  textTheme: const TextTheme(
                      headline6: TextStyle(
                    color: Color(0xFF1DE9B6),
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                  ))),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onGenerateRoute: CustomRouter.onGenerateRoute,
            initialRoute: SplashScreen.routeName,
          ),
        ),
      ),
    );
  }
}
