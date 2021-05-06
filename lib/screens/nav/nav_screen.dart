import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squadup_v3/enums/enums.dart';
import 'package:squadup_v3/screens/nav/cubit/bottom_nav_bar_cubit.dart';
import 'package:squadup_v3/screens/nav/widgets/bottom_nav_bar.dart';
import 'package:squadup_v3/widgets/tab_navigator.dart';

class NavScreen extends StatelessWidget {
  static const String routeName = '/nav';

  static Route route() {
    return PageRouteBuilder(
      // Paints over the splash screen instantly
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(), child: NavScreen()),
    );
  }

  final Map<BottomNavBarItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavBarItem.home: GlobalKey<NavigatorState>(),
    BottomNavBarItem.search: GlobalKey<NavigatorState>(),
    BottomNavBarItem.createPost: GlobalKey<NavigatorState>(),
    BottomNavBarItem.notifications: GlobalKey<NavigatorState>(),
    BottomNavBarItem.profile: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavBarItem, IconData> items = const {
    BottomNavBarItem.home: Icons.home_rounded,
    BottomNavBarItem.search: Icons.search,
    BottomNavBarItem.createPost: Icons.add_a_photo,
    BottomNavBarItem.notifications: Icons.notifications,
    BottomNavBarItem.profile: Icons.account_circle_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<BottomNavBarCubit, BottomNavBarState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: items
                  .map((item, _) => MapEntry(
                        item,
                        _buildOffstageNavigator(
                            item, item == state.selectedItem),
                      ))
                  .values
                  .toList(),
            ),
            bottomNavigationBar: BottomNavBar(
              onTap: (index) {
                final selectedItem = BottomNavBarItem.values[index];
                _selectBottomNavBarItem(
                  context,
                  selectedItem,
                  selectedItem == state.selectedItem,
                );
              },
              items: items,
              selectedItem: state.selectedItem,
            ),
          );
        },
      ),
    );
  }

  void _selectBottomNavBarItem(
      BuildContext context, BottomNavBarItem selectedItem, bool isSameItem) {
    if (isSameItem) {
      // if user navigated to the comments screen from the home screen and
      // presses the home button on the nav bar again it will pop everything else
      // but the home screen off the stack
      navigatorKeys[selectedItem]
          .currentState
          .popUntil((route) => route.isFirst);
    }
    context.read<BottomNavBarCubit>().updateSelectedItem(selectedItem);
  }

  Widget _buildOffstageNavigator(
    BottomNavBarItem currentItem,
    bool isSelected,
  ) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem],
        navBarItem: currentItem,
      ),
    );
  }
}
