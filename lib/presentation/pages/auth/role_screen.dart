import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:techni_quick/core/util/navigator.dart';

import '../../../core/util/images.dart';
import '../../../injection.dart';
import '../../../model/user.dart';
import 'login_screen.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logo,
              height: 200,
            ),
            GestureDetector(
              onTap: () {
                sl<AppNavigator>()
                    .push(screen: const LoginScreen(type: UserType.client));
              },
              child: buildOptionContainer(
                tr('user'),
                Icons.person,
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                sl<AppNavigator>()
                    .push(screen: const LoginScreen(type: UserType.technician));
              },
              child: buildOptionContainer(
                tr('technican'),
                Icons.build,
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                sl<AppNavigator>()
                    .push(screen: const LoginScreen(type: UserType.supplier));
              },
              child: buildOptionContainer(
                tr('supplier'),
                Icons.shopping_cart,
                Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildOptionContainer(String title, IconData icon, Color color) {
    return Container(
      height: 75,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 16),
          Icon(
            icon,
            color: Colors.orange,
            size: 35,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
