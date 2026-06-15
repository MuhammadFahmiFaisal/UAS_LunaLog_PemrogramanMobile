import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/main_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String main = '/main';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        main: (context) => const MainScreen(),
      };
}
