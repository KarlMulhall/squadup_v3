import 'package:flutter/material.dart';

import 'package:squadup_v3/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavBarItem, IconData> items;
  final BottomNavBarItem selectedItem;
  final Function(int) onTap;
  const BottomNavBar({
    Key key,
    @required this.items,
    @required this.selectedItem,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.blueGrey[800],
      showSelectedLabels: true,
      showUnselectedLabels: false,
      selectedItemColor: Colors.tealAccent[400],
      unselectedItemColor: Colors.indigoAccent[100],
      currentIndex: BottomNavBarItem.values.indexOf(selectedItem),
      onTap: onTap,
      items: items
          .map(
            (item, icon) => MapEntry(
              item.toString(),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(icon, size: 30.0),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
