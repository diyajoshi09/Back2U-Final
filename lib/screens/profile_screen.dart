import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final profileController = Get.put(ProfileController());

    return Obx(() {
      final user = authController.user.value;
      final admin = authController.admin.value;
      final isAdmin = authController.isAdmin.value;

      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF0D9488),
                  child: Text(
                    isAdmin
                        ? admin!.fullName[0].toUpperCase()
                        : user!.firstName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isAdmin ? admin!.fullName : user!.fullName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isAdmin ? admin!.email : user!.email,
                  style: const TextStyle(color: Colors.grey),
                ),
                if (!isAdmin) ...[
                  const SizedBox(height: 8),
                  Text(
                    'ID: ${user!.universityId}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // My Items (for students only)
          if (!isAdmin) ...[
            const Text(
              'My Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            profileController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : profileController.myItems.isEmpty
                ? Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('No items posted yet', style: TextStyle(color: Colors.grey)),
              ),
            )
                : Column(
              children: profileController.myItems.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.itemName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              item.location,
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: item.itemType == 'found' ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.itemType.toUpperCase(),
                          style: TextStyle(
                            color: item.itemType == 'found' ? Colors.green : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Logout Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                authController.logout();
                Get.offAll(() => const AuthScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      );
    });
  }
}
