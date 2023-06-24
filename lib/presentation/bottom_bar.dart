import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/presentation/cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import '../core/constant.dart';
import '../model/user.dart';
import 'cubit_controller/auth/nav_bar/bottom_nav_bar_state.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key, required this.user}) : super(key: key);
  final BaseUser user;
  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    context.read<BottomBarCubit>().updateUser = widget.user;
    context.read<BottomBarCubit>().tabController = TabController(
      length: 5,
      vsync: this,
    );
    if (widget.user.type == UserType.supplier) {
      items = [
        const TabItem(
          icon: Icons.home,
        ),
        const TabItem(
          icon: Icons.add,
        ),
        const TabItem(
          icon: Icons.calendar_today,
        ),
      ];
    }
    if (widget.user.type == UserType.technician) {
      items = [
        const TabItem(
          icon: Icons.home,
        ),
        const TabItem(
          icon: Icons.work,
        ),
        const TabItem(
          icon: Icons.calendar_today,
        ),
      ];
    }
    if (widget.user.type == UserType.client) {
      items = [
        const TabItem(
          icon: Icons.home,
        ),
        const TabItem(
          icon: Icons.search,
        ),
        const TabItem(
          icon: Icons.calendar_today,
        ),
      ];
    }
  }

  List<TabItem> items = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomBarCubit, BottomBarStates>(
      builder: (context, state) {
        final cubit = context.watch<BottomBarCubit>();
        return Scaffold(
          body: cubit.getByUserType()[cubit.selectedIndex],
          bottomNavigationBar: ConvexAppBar(
            controller: cubit.tabController,
            items: items,
            initialActiveIndex: cubit.selectedIndex,
            onTap: (c) => cubit.changeBottomBar(c),
            backgroundColor: Colors.white,
            color: Colors.grey,
            activeColor: darkerColor,
            style: TabStyle.fixedCircle,
          ),
        );
      },
    );
  }
}
