import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';

class VendorSavingsTab extends StatelessWidget {
  const VendorSavingsTab({super.key});

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
            // Vendor Hero Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withOpacity(0.12),
                    blurRadius: 12,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'PROCUREMENT SAVINGS & ANALYTICS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Wholesale Purchase Savings',
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

            // 4 Grid Metric Cards
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
                  badgeText: '+18% this mo',
                ),
                MetricCard(
                  value: '86 kg',
                  label: 'Inventory Bought',
                  emoji: '🛒',
                  color: AppColors.vendorPrimary,
                  badgeText: 'Near-Expiry',
                ),
                MetricCard(
                  value: '32%',
                  label: 'Average Discount',
                  emoji: '🏷️',
                  color: AppColors.warning,
                  badgeText: 'Wholesale',
                ),
                MetricCard(
                  value: '${state.vendorOrdersCount}',
                  label: 'Orders Completed',
                  emoji: '📦',
                  color: const Color(0xFF4F46A5),
                  badgeText: 'Direct Kirana',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Money Saved Trend Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly Money Saved Trend (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('May', 0.4),
                      _buildBar('Jun', 0.6),
                      _buildBar('Jul', 0.8),
                      _buildBar('Aug', 0.95),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String month, double val) {
    return Column(
      children: [
        Container(height: 100 * val, width: 22, decoration: BoxDecoration(color: AppColors.vendorPrimary, borderRadius: BorderRadius.circular(6))),
        const SizedBox(height: 6),
        Text(month, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
