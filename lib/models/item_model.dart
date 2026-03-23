class UniversityItem {
  final String id;
  final String userId;
  final String categoryId;
  final String itemType; // 'lost' or 'found'
  final String itemName;
  final String? description;
  final String location;
  final String dateLostFound;
  final List<ItemImage> images;
  final bool isClaimed;
  final bool isActive;
  final String createdAt;
  final User? user;
  final Category? category;

  UniversityItem({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.itemType,
    required this.itemName,
    this.description,
    required this.location,
    required this.dateLostFound,
    required this.images,
    required this.isClaimed,
    required this.isActive,
    required this.createdAt,
    this.user,
    this.category,
  });

  factory UniversityItem.fromJson(Map<String, dynamic> json) {
    return UniversityItem(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      itemType: json['item_type'] ?? 'lost',
      itemName: json['item_name'] ?? '',
      description: json['description'],
      location: json['location'] ?? '',
      dateLostFound: json['date_lost_found'] ?? '',
      images: (json['images'] as List?)?.map((e) => ItemImage.fromJson(e)).toList() ?? [],
      isClaimed: json['is_claimed'] ?? false,
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? '',
      user: json['users'] != null ? User.fromJson(json['users']) : null,
      category: json['categories'] != null ? Category.fromJson(json['categories']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'item_type': itemType,
      'item_name': itemName,
      'description': description,
      'location': location,
      'date_lost_found': dateLostFound,
      'images': images.map((e) => e.toJson()).toList(),
      'is_claimed': isClaimed,
      'is_active': isActive,
    };
  }
}

class ItemImage {
  final String fileId;
  final String url;
  final String thumbnailUrl;

  ItemImage({
    required this.fileId,
    required this.url,
    required this.thumbnailUrl,
  });

  factory ItemImage.fromJson(Map<String, dynamic> json) {
    return ItemImage(
      fileId: json['file_id'] ?? '',
      url: json['url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file_id': fileId,
      'url': url,
      'thumbnail_url': thumbnailUrl,
    };
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
    };
  }
}

class Category {
  final String id;
  final String name;
  final String iconName;
  final bool isActive;

  Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      iconName: json['icon_name'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'is_active': isActive,
    };
  }
}

class AdminStats {
  final int totalUsers;
  final int totalItems;
  final int lostItems;
  final int foundItems;
  final int claimedItems;
  final int totalCategories;

  AdminStats({
    required this.totalUsers,
    required this.totalItems,
    required this.lostItems,
    required this.foundItems,
    required this.claimedItems,
    required this.totalCategories,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      totalUsers: json['total_users'] ?? 0,
      totalItems: json['total_items'] ?? 0,
      lostItems: json['lost_items'] ?? 0,
      foundItems: json['found_items'] ?? 0,
      claimedItems: json['claimed_items'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
    );
  }
}
