import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_header.dart';
import 'restaurant_home_tab.dart';
import 'restaurant_surplus_tab.dart';
import 'restaurant_history_tab.dart';
import 'restaurant_analytics_tab.dart';
import 'restaurant_profile_tab.dart';

import 'package:provider/provider.dart';
import '../../state/app_state.dart';

class RestaurantMainScreen extends StatefulWidget {
  const RestaurantMainScreen({super.key});

  @override
  State<RestaurantMainScreen> createState() => _RestaurantMainScreenState();
}

class _RestaurantMainScreenState extends State<RestaurantMainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AppState>(context, listen: false).setRole(UserRole.restaurant);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            RoleHeader(
              role: UserRole.restaurant,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.8), width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (idx) => setState(() => _currentIndex = idx),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.restaurantPrimary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: 22), activeIcon: Icon(Icons.home, size: 22), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined, size: 22), activeIcon: Icon(Icons.inventory_2, size: 22), label: 'SURPLUS'),
            BottomNavigationBarItem(icon: Icon(Icons.history_outlined, size: 22), activeIcon: Icon(Icons.history, size: 22), label: 'HISTORY'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_outlined, size: 22), activeIcon: Icon(Icons.analytics, size: 22), label: 'ANALYTICS'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline, size: 22), activeIcon: Icon(Icons.person, size: 22), label: 'PROFILE'),
          ],
        ),
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
