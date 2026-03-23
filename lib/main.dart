import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/storage_service.dart';
import 'controllers/auth_controller.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());

    return GetMaterialApp(
      title: 'UniFOund',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFC),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF1E293B)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: Obx(() {
        if (authController.isLoading.value) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0D9488),
              ),
            ),
          );
        }

        if (authController.token.value.isNotEmpty) {
          return const MainScaffold();
        }

        return const AuthScreen();
      }),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentIndex = 0;

  // Using IndexedStack to preserve screen states
  final List<Widget> screens = [
    const HomeScreen(),
    const PostScreen(),
    const InventoryScreen(),
    const ProfileScreen(),
  ];

  void _onNavTap(int index) {
    if (currentIndex == index) {
      // If tapping the same tab, you could implement scroll to top or refresh
      return;
    }

    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// Inventory/Items Screen (placeholder for now)
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final isAdmin = authController.isAdmin.value;

      return Scaffold(
        appBar: AppBar(
          title: Text(isAdmin ? 'All Items' : 'My Items'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: Color(0xFF0D9488),
              ),
              SizedBox(height: 16),
              Text(
                'Inventory Screen',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Coming soon...',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
