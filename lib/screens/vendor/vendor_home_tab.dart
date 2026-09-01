import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'deal_detail_screen.dart';

class VendorHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const VendorHomeTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. KPI CARDS GRID
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildKpi('Total Purchases', '₹${state.vendorTotalPurchases.toStringAsFixed(0)}', Icons.shopping_bag, AppColors.vendorPrimary),
              _buildKpi('Orders Placed', '${state.vendorOrdersCount}', Icons.receipt_long, AppColors.info),
              _buildKpi('Money Saved', '₹${state.vendorMoneySaved.toStringAsFixed(0)}', Icons.savings, AppColors.success),
              _buildKpi('Deals Found', '${state.discountOffers.length}', Icons.local_offer, AppColors.warning),
            ],
          ),
          const SizedBox(height: 20),

          // 2. PRIMARY CTA BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onNavigateTab(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.vendorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.search, size: 24),
              label: const Text(
                'FIND NEAR-EXPIRY DEALS MARKETPLACE',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. RECENT DEALS FEED
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recommended B2B Deals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              TextButton(onPressed: () => onNavigateTab(1), child: const Text('View All →')),
            ],
          ),
          const SizedBox(height: 8),
          ...state.discountOffers.take(2).map((offer) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.vendorBg, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.local_offer, color: AppColors.vendorPrimary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${offer.kiranaName} • ${offer.distanceKm} km', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('₹${offer.originalPrice.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey)),
                              const SizedBox(width: 6),
                              Text('₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.vendorPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DealDetailScreen(offer: offer)));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.vendorPrimary),
                      child: const Text('BUY'),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildKpi(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
