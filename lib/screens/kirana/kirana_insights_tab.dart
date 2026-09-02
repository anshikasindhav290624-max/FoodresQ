import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';

class KiranaInsightsTab extends StatelessWidget {
  const KiranaInsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.kirana,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kirana Store Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kiranaPrimary.withOpacity(0.12),
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
                        url: AppImage.kiranaStore,
                        borderRadius: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.kiranaPrimary.withOpacity(0.85),
                              AppColors.kiranaPrimary.withOpacity(0.35),
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
                            'KIRANA RECOVERY ANALYTICS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Revenue Recovery & Waste Reduction',
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

            // Visual Flow Diagram (Inventory -> Near Expiry -> AI Discount -> Vendor Purchase -> Loss Prevented)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kiranaPrimary.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kiranaPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Expiry Recovery Cycle', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFlowStage('🏪 Inventory', '140 Items', Colors.grey.shade700),
                      _buildFlowArrow(),
                      _buildFlowStage('⏳ Near Expiry', '12 Items', AppColors.warning),
                      _buildFlowArrow(),
                      _buildFlowStage('🤖 AI Discount', '30% Off', AppColors.aiAccent),
                      _buildFlowArrow(),
                      _buildFlowStage('💰 Recovered', '₹12,800', AppColors.kiranaPrimary),
                    ],
                  ),
                ],
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
                  value: '₹${state.kiranaRevenueRecovered.toStringAsFixed(0)}',
                  label: 'Revenue Recovered',
                  emoji: '💰',
                  color: AppColors.success,
                  badgeText: '+24% this mo',
                ),
                MetricCard(
                  value: '86 kg',
                  label: 'Waste Prevented',
                  emoji: '♻️',
                  color: AppColors.kiranaPrimary,
                  badgeText: 'Near-Expiry',
                ),
                MetricCard(
                  value: '₹6,400',
                  label: 'Near-Expiry Sales',
                  emoji: '🏷️',
                  color: AppColors.warning,
                  badgeText: 'Direct B2B',
                ),
                MetricCard(
                  value: '23%',
                  label: 'Inventory Loss ↓',
                  emoji: '📉',
                  color: const Color(0xFF4F46A5),
                  badgeText: 'Reduced',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Monthly Value Recovery Chart
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
                  const Text('Monthly Value Recovery (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('May', 0.45),
                      _buildBar('Jun', 0.65),
                      _buildBar('Jul', 0.8),
                      _buildBar('Aug', 0.9),
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

  Widget _buildBar(String month, double val) {
    return Column(
      children: [
        Container(height: 100 * val, width: 22, decoration: BoxDecoration(color: AppColors.kiranaPrimary, borderRadius: BorderRadius.circular(6))),
        const SizedBox(height: 6),
        Text(month, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
