import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_header.dart';
import 'restaurant_home_tab.dart';
import 'restaurant_surplus_tab.dart';
import 'restaurant_history_tab.dart';
import 'restaurant_analytics_tab.dart';
import 'restaurant_profile_tab.dart';

class RestaurantMainScreen extends StatefulWidget {
  const RestaurantMainScreen({super.key});

  @override
  State<RestaurantMainScreen> createState() => _RestaurantMainScreenState();
}

class _RestaurantMainScreenState extends State<RestaurantMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            RoleHeader(
              title: _getHeaderTitle(),
              subtitle: _getHeaderSubtitle(),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  RestaurantHomeTab(onNavigateTab: (idx) => setState(() => _currentIndex = idx)),
                  const RestaurantSurplusTab(),
                  const RestaurantHistoryTab(),
                  const RestaurantAnalyticsTab(),
                  const RestaurantProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.restaurantPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory_2), label: 'SURPLUS'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'HISTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined), activeIcon: Icon(Icons.analytics), label: 'ANALYTICS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Urban Tadka Restaurant 🍽️';
      case 1:
        return 'Surplus Management';
      case 2:
        return 'Recovery History';
      case 3:
        return 'Waste Analytics';
      case 4:
        return 'Restaurant Profile';
      default:
        return 'Restaurant Dashboard';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Manage food surplus & recover value';
      case 1:
        return 'Active surplus batches & matching status';
      case 2:
        return 'Past donations and market sales';
      case 3:
        return 'Track cost savings and waste reduction';
      case 4:
        return 'Account settings & credentials';
      default:
        return '';
    }
  }
}
