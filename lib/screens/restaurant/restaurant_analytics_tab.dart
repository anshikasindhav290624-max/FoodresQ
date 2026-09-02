import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';

class RestaurantAnalyticsTab extends StatelessWidget {
  const RestaurantAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kitchen Analytics Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withOpacity(0.12),
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
                        url: AppImage.restaurantKitchen,
                        borderRadius: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.restaurantPrimary.withOpacity(0.85),
                              AppColors.restaurantPrimary.withOpacity(0.35),
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
                            'KITCHEN RECOVERY ANALYTICS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Food Waste & Cost Reduction',
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

            // Visual Flow Graphics Diagram (Prepared -> Surplus -> Recovered -> Waste Prevented)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.restaurantPrimary.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Food Value Recovery Pipeline', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFlowStage('🍳 Prepared', '540 kg', Colors.grey.shade700),
                      _buildFlowArrow(),
                      _buildFlowStage('📦 Surplus', '48 kg', AppColors.warning),
                      _buildFlowArrow(),
                      _buildFlowStage('♻️ Recovered', '42 kg', AppColors.restaurantPrimary),
                      _buildFlowArrow(),
                      _buildFlowStage('🌱 Prevented', '34 kg', AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid Metric Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: const [
                MetricCard(
                  value: '32%',
                  label: 'Waste Reduction',
                  emoji: '📉',
                  color: AppColors.success,
                  badgeText: '-12% this mo',
                ),
                MetricCard(
                  value: '₹18,400',
                  label: 'Cost Saved',
                  emoji: '💰',
                  color: AppColors.restaurantPrimary,
                  badgeText: 'Recovered',
                ),
                MetricCard(
                  value: '1,820',
                  label: 'Meals Recovered',
                  emoji: '🍱',
                  color: Color(0xFF4F46A5),
                  badgeText: 'Social Impact',
                ),
                MetricCard(
                  value: '450 kg',
                  label: 'Diverted Mass',
                  emoji: '♻️',
                  color: AppColors.aiAccent,
                  badgeText: 'Eco-Friendly',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Waste Reduction Trend
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
                  const Text('Monthly Waste Reduction Trend', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartCol('Week 1', 0.9, Colors.red.shade300),
                      _buildChartCol('Week 2', 0.7, Colors.amber.shade400),
                      _buildChartCol('Week 3', 0.5, AppColors.restaurantPrimary),
                      _buildChartCol('Week 4', 0.35, AppColors.success),
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

  Widget _buildFlowStage(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }

  Widget _buildFlowArrow() {
    return const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary);
  }

  Widget _buildChartCol(String label, double val, Color color) {
    return Column(
      children: [
        Container(
          height: 100 * val,
          width: 24,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
