import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_header.dart';
import 'ngo_home_tab.dart';
import 'ngo_available_tab.dart';
import 'ngo_history_tab.dart';
import 'ngo_impact_tab.dart';
import 'ngo_profile_tab.dart';

class NgoMainScreen extends StatefulWidget {
  const NgoMainScreen({super.key});

  @override
  State<NgoMainScreen> createState() => _NgoMainScreenState();
}

class _NgoMainScreenState extends State<NgoMainScreen> {
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
                  NgoHomeTab(onNavigateTab: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  }),
                  const NgoAvailableTab(),
                  const NgoHistoryTab(),
                  const NgoImpactTab(),
                  const NgoProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.ngoPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood_outlined), activeIcon: Icon(Icons.fastfood), label: 'AVAILABLE'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'HISTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'IMPACT'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Good Evening, Helping Hands ❤️';
      case 1:
        return 'Nearby Surplus Food';
      case 2:
        return 'Food Recovery History';
      case 3:
        return 'Social Impact Dashboard';
      case 4:
        return 'NGO Account & Trust';
      default:
        return 'NGO Dashboard';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Rescue & distribute surplus food to people in need';
      case 1:
        return 'Real-time surplus listings from verified restaurants';
      case 2:
        return 'Complete record of accepted and completed distributions';
      case 3:
        return 'Measurable metrics: meals saved & beneficiaries served';
      case 4:
        return 'Manage profile & view performance score';
      default:
        return '';
    }
  }
}
