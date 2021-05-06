import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:squadup_v3/enums/enums.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit()
      : super(BottomNavBarState(selectedItem: BottomNavBarItem.home));

  void updateSelectedItem(BottomNavBarItem item) {
    if (item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
