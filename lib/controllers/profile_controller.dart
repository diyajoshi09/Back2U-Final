import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final authController = Get.find<AuthController>();

  final RxList<UniversityItem> myItems = <UniversityItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString filterType = 'all'.obs; // 'all', 'lost', 'found', 'claimed'

  @override
  void onInit() {
    super.onInit();
    if (!authController.isAdmin.value) {
      fetchMyItems();
    }
  }

  Future<void> fetchMyItems() async {
    if (authController.isAdmin.value) return;

    try {
      isLoading.value = true;

      String? type;
      if (filterType.value == 'lost') type = 'lost';
      if (filterType.value == 'found') type = 'found';

      String? claimed;
      if (filterType.value == 'claimed') claimed = 'true';

      final items = await ApiService.getUserItems(
        token: authController.token.value,
        type: type,
        claimed: claimed,
      );

      myItems.value = items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load your items: ${_parseError(e)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    try {
      isRefreshing.value = true;
      await fetchMyItems();
    } finally {
      isRefreshing.value = false;
    }
  }

  void setFilter(String filter) {
    if (filterType.value == filter) return;
    filterType.value = filter;
    fetchMyItems();
  }

  List<UniversityItem> get lostItems {
    return myItems.where((item) => item.itemType == 'lost' && !item.isClaimed).toList();
  }

  List<UniversityItem> get foundItems {
    return myItems.where((item) => item.itemType == 'found' && !item.isClaimed).toList();
  }

  List<UniversityItem> get claimedItems {
    return myItems.where((item) => item.isClaimed).toList();
  }

  int get totalPosts => myItems.length;
  int get activePosts => myItems.where((item) => !item.isClaimed).length;
  int get claimedPosts => myItems.where((item) => item.isClaimed).length;

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiService.updateProfile(
        token: authController.token.value,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (response['success'] == true) {
        await authController.refreshProfile();

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0D9488),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${_parseError(e)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMyItem(String itemId) async {
    try {
      await ApiService.deleteItem(
        token: authController.token.value,
        itemId: itemId,
      );

      myItems.removeWhere((item) => item.id == itemId);

      Get.snackbar(
        'Success',
        'Item deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete item: ${_parseError(e)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> markItemAsClaimed(String itemId) async {
    try {
      await ApiService.updateItem(
        token: authController.token.value,
        itemId: itemId,
        data: {
          'is_claimed': true,
          'claimed_at': DateTime.now().toIso8601String(),
        },
      );

      // Update local item
      final index = myItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        myItems[index] = UniversityItem(
          id: myItems[index].id,
          userId: myItems[index].userId,
          categoryId: myItems[index].categoryId,
          itemType: myItems[index].itemType,
          itemName: myItems[index].itemName,
          description: myItems[index].description,
          location: myItems[index].location,
          dateLostFound: myItems[index].dateLostFound,
          images: myItems[index].images,
          isClaimed: true,
          isActive: myItems[index].isActive,
          createdAt: myItems[index].createdAt,
          user: myItems[index].user,
          category: myItems[index].category,
        );
        myItems.refresh();
      }

      Get.snackbar(
        'Success',
        'Item marked as claimed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update item: ${_parseError(e)}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _parseError(dynamic error) {
    String errorMsg = error.toString();
    if (errorMsg.startsWith('Exception: ')) {
      errorMsg = errorMsg.substring(11);
    }
    return errorMsg;
  }
}
