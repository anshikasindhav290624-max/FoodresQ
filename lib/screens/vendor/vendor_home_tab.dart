import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';
import 'deal_detail_screen.dart';

class VendorHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const VendorHomeTab({super.key, required this.onNavigateTab});

  String _getGroceryImageUrl(int index) {
    switch (index % 3) {
      case 0:
        return AppImage.groceryTomatoes;
      case 1:
        return AppImage.groceryMilk;
      case 2:
        return AppImage.groceryRice;
      default:
        return AppImage.groceryVeggies;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. VENDOR PURCHASING HERO BANNER
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppImage(
                        url: AppImage.vendorWholesale,
                        borderRadius: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.vendorPrimary.withOpacity(0.85),
                              AppColors.vendorPrimary.withOpacity(0.35),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'WHOLESALE DISCOUNT MARKETPLACE • BUYER HUB',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'FreshBuy Wholesale Traders',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. KPI CARDS GRID (PROMINENT NUMBERS & SAVINGS)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                MetricCard(
                  value: '₹${state.vendorMoneySaved.toStringAsFixed(0)}',
                  label: 'Money Saved',
                  emoji: '💰',
                  color: AppColors.success,
                  badgeText: 'Total Savings',
                ),
                MetricCard(
                  value: '₹${state.vendorTotalPurchases.toStringAsFixed(0)}',
                  label: 'Total Purchases',
                  emoji: '🛒',
                  color: AppColors.vendorPrimary,
                  badgeText: 'Spent',
                ),
                MetricCard(
                  value: '${state.vendorOrdersCount}',
                  label: 'Orders Placed',
                  emoji: '📦',
                  color: const Color(0xFF4F46A5),
                  badgeText: 'Completed',
                ),
                MetricCard(
                  value: '${state.discountOffers.length}',
                  label: 'Active Deals',
                  emoji: '🏷️',
                  color: AppColors.warning,
                  badgeText: 'Up to 30% OFF',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. PRIMARY CTA BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => onNavigateTab(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vendorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.search, size: 22),
                label: const Text(
                  'FIND NEAR-EXPIRY DEALS MARKETPLACE',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. RECENT DEALS FEED WITH PRODUCT PHOTOGRAPHY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recommended B2B Deals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                TextButton(onPressed: () => onNavigateTab(1), child: const Text('View All →')),
              ],
            ),
            const SizedBox(height: 8),
            ...state.discountOffers.asMap().entries.take(2).map((entry) {
              final index = entry.key;
              final offer = entry.value;
              final imageUrl = _getGroceryImageUrl(index);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AppImage(
                      url: imageUrl,
                      width: 72,
                      height: 72,
                      borderRadius: 14,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${offer.kiranaName} • ${offer.distanceKm} km away', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('₹${offer.originalPrice.toStringAsFixed(0)}', style: const TextStyle(decoration: TextDecoration.lineThrough, fontSize: 12, color: Colors.grey)),
                              const SizedBox(width: 6),
                              Text('₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.vendorPrimary, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DealDetailScreen(offer: offer)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vendorPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text('BUY', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
