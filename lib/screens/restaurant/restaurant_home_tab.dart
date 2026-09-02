import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';
import 'add_surplus_screen.dart';

class RestaurantHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const RestaurantHomeTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. RESTAURANT HERO PHOTO BANNER
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withOpacity(0.12),
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
                              'SURPLUS RECOVERY & REVENUE MANAGEMENT',
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
                            'Urban Tadka Restaurant',
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

            // 1. KPI CARDS GRID (LARGE NUMERIC PRESENTATION)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
              children: [
                MetricCard(
                  value: '₹${state.restaurantRevenueToday.toStringAsFixed(0)}',
                  label: 'Revenue Recovered',
                  emoji: '💰',
                  color: AppColors.restaurantPrimary,
                  badgeText: 'Today',
                ),
                MetricCard(
                  value: '${state.restaurantSavedMealsToday}',
                  label: 'Meals Saved',
                  emoji: '🍱',
                  color: AppColors.success,
                  badgeText: '+18 today',
                ),
                MetricCard(
                  value: '${state.restaurantWasteKgToday.toStringAsFixed(0)} kg',
                  label: 'Waste Prevented',
                  emoji: '♻️',
                  color: AppColors.warning,
                  badgeText: '-24% waste',
                ),
                MetricCard(
                  value: '86',
                  label: 'Orders Served',
                  emoji: '🧾',
                  color: const Color(0xFF4F46A5),
                  badgeText: 'Active',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. PRIMARY CTA — ADD SURPLUS
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddSurplusScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.restaurantPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text(
                  '+ ADD SURPLUS FOOD BATCH',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. 🤖 AI WASTE FORECAST CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.aiAccent.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aiAccent.withOpacity(0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.aiAccent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '🤖 AI WASTE FORECAST & PREDICTION',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.aiAccent, letterSpacing: 1.0),
                            ),
                            Text(
                              'Tomorrow\'s Predicted Surplus: 16 kg',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.restaurantBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildForecastRow('Prepared Rice Batch', '8 kg at risk'),
                        const SizedBox(height: 4),
                        _buildForecastRow('Curry & Gravy', '5 kg at risk'),
                        const SizedBox(height: 4),
                        _buildForecastRow('Salad & Breads', '3 kg at risk'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 18),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'AI Recommendation: Reduce Friday rice preparation by 12% based on historical demand patterns.',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI Inventory Plan applied! Prep target adjusted -12%.')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.restaurantPrimary,
                        side: const BorderSide(color: AppColors.restaurantPrimary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('PLAN INVENTORY NOW', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastRow(String item, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        Text(val, style: const TextStyle(color: AppColors.critical, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
