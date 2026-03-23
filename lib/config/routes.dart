import 'package:get/get.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/post_screen.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String post = '/post';

  static List<GetPage> routes = [
    GetPage(
      name: auth,
      page: () => AuthScreen(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: post,
      page: () => PostScreen(),
    ),
  ];
}
