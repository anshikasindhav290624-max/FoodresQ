import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';

class NgoImpactTab extends StatelessWidget {
  const NgoImpactTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Photo Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ngoPrimary.withOpacity(0.12),
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
                        url: AppImage.ngoCommunity,
                        borderRadius: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.ngoPrimary.withOpacity(0.85),
                              AppColors.ngoPrimary.withOpacity(0.35),
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
                            'ECOSYSTEM IMPACT OVERVIEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Cumulative Food Recovery',
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
                  value: '${state.totalMealsSaved}',
                  label: 'Meals Saved',
                  emoji: '🍱',
                  color: AppColors.ngoPrimary,
                  badgeText: '+14%',
                ),
                MetricCard(
                  value: '${state.peopleServed}',
                  label: 'People Served',
                  emoji: '🤝',
                  color: AppColors.success,
                  badgeText: 'Verified',
                ),
                MetricCard(
                  value: '${state.foodDivertedKg.toStringAsFixed(0)} kg',
                  label: 'Food Diverted',
                  emoji: '♻️',
                  color: AppColors.warning,
                  badgeText: 'Waste-Free',
                ),
                MetricCard(
                  value: '${state.successfulPickups}',
                  label: 'Pickups Done',
                  emoji: '🚚',
                  color: AppColors.aiAccent,
                  badgeText: '100% Rate',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weekly Trend Bar Chart
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Weekly Meals Rescued Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('+14% vs last week', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Mon', 0.5),
                      _buildBar('Tue', 0.7),
                      _buildBar('Wed', 0.4),
                      _buildBar('Thu', 0.85),
                      _buildBar('Fri', 0.6),
                      _buildBar('Sat', 0.95),
                      _buildBar('Sun', 0.75),
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

  Widget _buildBar(String day, double heightFactor) {
    return Column(
      children: [
        Container(
          height: 100 * heightFactor,
          width: 18,
          decoration: BoxDecoration(
            color: AppColors.ngoPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
