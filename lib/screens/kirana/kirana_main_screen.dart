import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_header.dart';
import 'kirana_home_tab.dart';
import 'kirana_inventory_tab.dart';
import 'kirana_history_tab.dart';
import 'kirana_insights_tab.dart';
import 'kirana_profile_tab.dart';

class KiranaMainScreen extends StatefulWidget {
  const KiranaMainScreen({super.key});

  @override
  State<KiranaMainScreen> createState() => _KiranaMainScreenState();
}

class _KiranaMainScreenState extends State<KiranaMainScreen> {
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
                  KiranaHomeTab(onNavigateTab: (idx) => setState(() => _currentIndex = idx)),
                  const KiranaInventoryTab(),
                  const KiranaHistoryTab(),
                  const KiranaInsightsTab(),
                  const KiranaProfileTab(),
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
        selectedItemColor: AppColors.kiranaPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'INVENTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'HISTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.insights_outlined), activeIcon: Icon(Icons.insights), label: 'INSIGHTS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Sharma General Store 🏪';
      case 1:
        return 'At-Risk Inventory';
      case 2:
        return 'Recovery Sales History';
      case 3:
        return 'Revenue Recovery Insights';
      case 4:
        return 'Kirana Store Profile';
      default:
        return 'Kirana Dashboard';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Recover value from near-expiry products';
      case 1:
        return 'Manage products expiring within 1-3 days';
      case 2:
        return 'Completed discount sales to Vendor buyers';
      case 3:
        return 'Track loss prevention & recovered revenue';
      case 4:
        return 'Store information & verification';
      default:
        return '';
    }
  }
}
