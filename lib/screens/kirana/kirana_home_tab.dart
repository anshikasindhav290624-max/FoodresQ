import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/subtle_background_animation.dart';
import 'create_discount_screen.dart';

class KiranaHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const KiranaHomeTab({super.key, required this.onNavigateTab});

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
            // 0. KIRANA STORE HERO BANNER
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kiranaPrimary.withOpacity(0.12),
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
                              'LOCAL STORE INVENTORY RECOVERY HUB',
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
                            'Sharma General Store',
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

            // 1. KPI CARDS GRID (PROMINENT NUMBERS)
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
                  color: AppColors.kiranaPrimary,
                  badgeText: 'Total',
                ),
                MetricCard(
                  value: '${state.kiranaExpiringProducts}',
                  label: 'Expiring Stock',
                  emoji: '⏳',
                  color: AppColors.warning,
                  badgeText: 'Within 3 days',
                ),
                MetricCard(
                  value: '₹${state.kiranaPotentialLoss.toStringAsFixed(0)}',
                  label: 'Potential Loss',
                  emoji: '⚠️',
                  color: AppColors.critical,
                  badgeText: 'At-Risk',
                ),
                MetricCard(
                  value: '₹8,450',
                  label: 'Today\'s Sales',
                  emoji: '🧾',
                  color: const Color(0xFF4F46A5),
                  badgeText: '24 Orders',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. ⚠ EXPIRING SOON WARNING ALERT
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '⚠ EXPIRING SOON ALERT',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.warning, letterSpacing: 1.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${state.kiranaExpiringProducts} products expire within 3 days.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'At-risk inventory value: ₹${state.kiranaPotentialLoss.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => onNavigateTab(1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kiranaPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('MANAGE EXPIRING INVENTORY NOW', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. 🤖 AI EXPIRY DETECTION & DISCOUNT RECOMMENDATION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.aiAccent.withOpacity(0.4), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.aiAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('🤖 AI HIGH RISK EXPIRY DETECTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.aiAccent, letterSpacing: 1.0)),
                            Text('12 Full Cream Milk Packs Expire Tomorrow', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Potential Loss: ₹360 if left unsold.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  const Text('AI Action Recommendation: Publish 30% Discount Offer (₹21/pack) to local Vendor buyers.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kiranaPrimary)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDiscountScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.kiranaPrimary,
                        side: const BorderSide(color: AppColors.kiranaPrimary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('CREATE DISCOUNT OFFER WITH AI', style: TextStyle(fontWeight: FontWeight.w800)),
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
}
