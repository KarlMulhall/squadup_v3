import 'package:flutter_bloc/flutter_bloc.dart';

// class for observing and printing any changed to the Bloc event
// or print the error to the debug console
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) async {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}
