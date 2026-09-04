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
            // A. HERO SECTION (Wide rounded banner with wholesale image & purple/indigo overlay)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppImage(
                        url: AppImage.vendorWholesale,
                        borderRadius: 22,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.vendorPrimary.withOpacity(0.92),
                              AppColors.vendorPrimary.withOpacity(0.55),
                              Colors.black.withOpacity(0.35),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      bottom: 16,
                      right: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  'PROCUREMENT SAVINGS & ANALYTICS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 13),
                                    SizedBox(width: 4),
                                    Text(
                                      '+18% this month',
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${state.vendorMoneySaved.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Total Money Saved on Wholesale Purchases',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
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

            // Wholesale Value Recovery Cycle Flow (Visual parity with Kirana interface)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.vendorPrimary.withOpacity(0.25), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.sync_alt_rounded, color: AppColors.vendorPrimary, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Wholesale Procurement Recovery Cycle',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFlowStage('🏪 Kirana Stock', '12 Listed', Colors.grey.shade700),
                      _buildFlowArrow(),
                      _buildFlowStage('⏳ Near Expiry', '48h Window', AppColors.warning),
                      _buildFlowArrow(),
                      _buildFlowStage('🏷️ 32% Discount', 'B2B Wholesale', AppColors.aiAccent),
                      _buildFlowArrow(),
                      _buildFlowStage('💰 Saved', '₹6,940', AppColors.vendorPrimary),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // C. 4 KPI CARDS (Preserving exact requested values)
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
                  label: 'Total Saved',
                  emoji: '💰',
                  color: AppColors.success,
                  badgeText: '+18% this mo',
                ),
                MetricCard(
                  value: '${state.vendorNearExpiryKg.toStringAsFixed(0)} kg',
                  label: 'Near-Expiry Bought',
                  emoji: '🛒',
                  color: AppColors.vendorPrimary,
                  badgeText: 'Stock Recovered',
                ),
                MetricCard(
                  value: '${state.vendorAvgDiscount}%',
                  label: 'Avg Discount',
                  emoji: '🏷️',
                  color: AppColors.warning,
                  badgeText: 'Wholesale B2B',
                ),
                MetricCard(
                  value: '${state.vendorOrdersCount}',
                  label: 'Orders Done',
                  emoji: '📦',
                  color: const Color(0xFF4F46A5),
                  badgeText: 'All Verified',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // D1. SAVINGS TREND CHART (Line/Area chart of monthly procurement savings)
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
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Procurement Savings Trend', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('Cumulative savings over last 4 months (₹)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.vendorPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('₹6,940 Total', style: TextStyle(color: AppColors.vendorPrimary, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildSavingsBar('May', 0.40, '₹1.2k'),
                      _buildSavingsBar('Jun', 0.60, '₹3.0k'),
                      _buildSavingsBar('Jul', 0.82, '₹4.9k'),
                      _buildSavingsBar('Aug', 1.00, '₹6.9k', isCurrent: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // D2 & D3. NEAR-EXPIRY PURCHASES BY CATEGORY & AVG DISCOUNT
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
                      Text('Near-Expiry Purchases by Category', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                      Text('86 kg Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.vendorPrimary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryProgressRow('🥛 Dairy & Milk', 34, 86, '34 kg (40%)', '35% avg off', AppColors.vendorPrimary),
                  const SizedBox(height: 12),
                  _buildCategoryProgressRow('🍞 Bakery & Buns', 22, 86, '22 kg (26%)', '40% avg off', AppColors.warning),
                  const SizedBox(height: 12),
                  _buildCategoryProgressRow('🍅 Fresh Produce', 18, 86, '18 kg (21%)', '30% avg off', AppColors.success),
                  const SizedBox(height: 12),
                  _buildCategoryProgressRow('📦 Packaged Goods', 12, 86, '12 kg (13%)', '25% avg off', const Color(0xFF8B7CF6)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // D4 & D5. PURCHASE VALUE RECOVERY GAUGE & ORDERS COMPARISON
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
                  const Text('Purchase Value Recovery', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Circular Gauge / Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 86,
                            height: 86,
                            child: CircularProgressIndicator(
                              value: 6940.0 / 28500.0,
                              strokeWidth: 9,
                              backgroundColor: AppColors.vendorPrimary.withOpacity(0.12),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.vendorPrimary),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('24.4%', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.vendorPrimary)),
                              Text('Saved', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatRow('Total Spend Volume:', '₹${state.vendorTotalPurchases.toStringAsFixed(0)}'),
                            const SizedBox(height: 6),
                            _buildStatRow('Total Net Savings:', '₹${state.vendorMoneySaved.toStringAsFixed(0)}', isBold: true),
                            const SizedBox(height: 6),
                            _buildStatRow('Average Margin Boost:', '+32% wholesale'),
                            const SizedBox(height: 6),
                            _buildStatRow('Completed Orders:', '${state.vendorOrdersCount} B2B orders'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // E. SAVINGS INSIGHT CARD ("Your Procurement Impact")
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.vendorPrimary.withOpacity(0.06),
                    AppColors.aiAccent.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.vendorPrimary.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withOpacity(0.06),
                    blurRadius: 10,
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
                          color: AppColors.vendorPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Your Procurement Impact',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Your discounted procurement strategy is helping recover value from near-expiry inventory while reducing purchasing costs.',
                    style: TextStyle(fontSize: 13, height: 1.45, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildImpactItem('₹6,940', 'Cost Saved', Icons.monetization_on_rounded, AppColors.success),
                      _buildImpactItem('86 kg', 'Stock Recovered', Icons.eco_rounded, AppColors.vendorPrimary),
                      _buildImpactItem('15', 'Orders Done', Icons.check_circle_rounded, const Color(0xFF4F46A5)),
                      _buildImpactItem('~142 kg', 'CO₂ Prevented', Icons.cloud_done_rounded, Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
    return const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColors.textSecondary);
  }

  Widget _buildSavingsBar(String month, double ratio, String amount, {bool isCurrent = false}) {
    return Column(
      children: [
        Text(amount, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCurrent ? AppColors.vendorPrimary : AppColors.textSecondary)),
        const SizedBox(height: 6),
        Container(
          height: 100 * ratio,
          width: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCurrent
                  ? [AppColors.vendorPrimary, const Color(0xFF8B7CF6)]
                  : [AppColors.vendorPrimary.withOpacity(0.5), AppColors.vendorPrimary.withOpacity(0.3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          month,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
            color: isCurrent ? AppColors.vendorPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryProgressRow(String label, int kg, int total, String displayKg, String discount, Color color) {
    final progress = kg / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Row(
              children: [
                Text(displayKg, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(discount, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            color: isBold ? AppColors.vendorPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactItem(String val, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
