import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/role_header.dart';
import 'vendor_home_tab.dart';
import 'vendor_deals_tab.dart';
import 'vendor_history_tab.dart';
import 'vendor_savings_tab.dart';
import 'vendor_profile_tab.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
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
                  VendorHomeTab(onNavigateTab: (idx) => setState(() => _currentIndex = idx)),
                  const VendorDealsTab(),
                  const VendorHistoryTab(),
                  const VendorSavingsTab(),
                  const VendorProfileTab(),
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
        selectedItemColor: AppColors.vendorPrimary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_outlined), activeIcon: Icon(Icons.local_offer), label: 'DEALS'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'HISTORY'),
          BottomNavigationBarItem(icon: Icon(Icons.savings_outlined), activeIcon: Icon(Icons.savings), label: 'SAVINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'PROFILE'),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentIndex) {
      case 0:
        return 'FreshBuy Buyers Market 🛒';
      case 1:
        return 'Near-Expiry Inventory Deals';
      case 2:
        return 'Purchase History';
      case 3:
        return 'Procurement Savings';
      case 4:
        return 'Vendor Account';
      default:
        return 'Vendor Dashboard';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Buy discounted near-expiry stock from Kirana stores';
      case 1:
        return '30-50% discounted grocery stock from local retailers';
      case 2:
        return 'Traceable purchase receipts & order tracking';
      case 3:
        return 'Cost savings & stock recovery metrics';
      case 4:
        return 'Manage profile & buying preferences';
      default:
        return '';
    }
  }
}
