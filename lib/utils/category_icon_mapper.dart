import 'package:flutter/material.dart';

class CategoryIconMapper {
  static const Map<String, IconData> _iconMap = {
    'visibility': Icons.visibility,
    'smartphone': Icons.smartphone,
    'backpack': Icons.backpack,
    'book': Icons.book,
    'calculate': Icons.calculate,
    'umbrella': Icons.umbrella,
    'wallet': Icons.account_balance_wallet, // or Icons.wallet if you prefer
    'badge': Icons.badge,
    'water_drop': Icons.water_drop,
    'usb': Icons.usb,
    'key': Icons.key,
    'watch': Icons.watch,
    'headphones': Icons.headphones,
    'laptop': Icons.laptop,
    'category': Icons.category,
    'diamond': Icons.diamond, // or Icons.diamond_outlined
  };

  static IconData fromName(String? name) {
    if (name == null) return Icons.category;
    return _iconMap[name] ?? Icons.category;
  }
}
