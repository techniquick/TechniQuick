import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/user.dart';
import '../../../pages/my_orders.dart';
import '../../../pages/supplier/add_item_supplier.dart';
import '../../../pages/home_screen.dart';
import '../../../pages/client/tech_order.dart';
import '../../../pages/technican/new_tech_orders_screen.dart';
import 'bottom_nav_bar_state.dart';

class BottomBarCubit extends Cubit<BottomBarStates> {
  BottomBarCubit() : super(BottomBarInitState());

  static BottomBarCubit get(BuildContext context) => BlocProvider.of(context);
  late TabController tabController;
  int selectedIndex = 0;
  List<Widget> pageList = const [];
  late BaseUser _user;
  BaseUser get user => _user;
  set updateUser(BaseUser newUser) => _user = newUser;

  List<Widget> getByUserType() {
    switch (_user.type) {
      case UserType.client:
        return clientScreens;
      case UserType.supplier:
        return supScreens;
      case UserType.technician:
        return techScreens;
    }
  }

  List<Widget> supScreens = [
    const HomePage(),
    const AddSuppliesForm(),
    const MyOrdersScreen(),
  ];
  List<Widget> clientScreens = [
    const HomePage(),
    const TechOrder(),
    const MyOrdersScreen(),
  ];
  List<Widget> techScreens = [
    const HomePage(),
    const NewTechOrders(),
    const MyOrdersScreen(),
  ];
  void selectMain() {
    emit(BottomBarInitState());
    selectedIndex = 0;
    tabController.animateTo(0);
    emit(ChangeBottomBarState());
  }

  void changeBottomBar(index) {
    if (index == selectedIndex) return;
    emit(BottomBarInitState());
    selectedIndex = index;
    tabController.animateTo(selectedIndex);
    emit(ChangeBottomBarState());
  }
}
