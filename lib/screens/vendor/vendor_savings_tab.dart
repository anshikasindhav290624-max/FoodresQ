import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';

class VendorSavingsTab extends StatefulWidget {
  const VendorSavingsTab({super.key});

  @override
  State<VendorSavingsTab> createState() => _VendorSavingsTabState();
}

class _VendorSavingsTabState extends State<VendorSavingsTab> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // Dynamic metrics based on period selection
    final periodMultiplier = _selectedPeriod == 'This Week'
        ? 0.25
        : (_selectedPeriod == 'This Year' ? 12.0 : 1.0);

    final totalSaved = (state.vendorMoneySaved * periodMultiplier).round();
    final nearExpiryKg = (state.vendorNearExpiryKg * periodMultiplier).round();
    final ordersCount = (state.vendorOrdersCount * periodMultiplier).round();
    final double avgDiscount = state.vendorAvgDiscount.toDouble();
    final totalSpend = (state.vendorTotalPurchases * periodMultiplier).round();

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER WITH PERIOD SELECTOR (MATCHING NGO DESIGN)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Procurement Savings',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Cost savings & stock recovery metrics',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Compact Reporting Period Selector
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.vendorBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.vendorPrimary.withValues(alpha: 0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.vendorPrimary, size: 18),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.vendorPrimary,
                            ),
                            items: ['This Week', 'This Month', 'This Year'].map((p) {
                              return DropdownMenuItem(value: p, child: Text(p));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedPeriod = val);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Last updated: Just now',
                        style: TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. MAIN SAVINGS BANNER (IMAGE BANNER WITH GRADIENT OVERLAY)
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withValues(alpha: 0.16),
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
                              Colors.black.withValues(alpha: 0.85),
                              AppColors.vendorPrimary.withValues(alpha: 0.75),
                              AppColors.vendorPrimary.withValues(alpha: 0.45),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                ),
                                child: const Text(
                                  'PROCUREMENT SAVINGS & ANALYTICS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.95),
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
                          const SizedBox(height: 8),
                          Text(
                            '₹$totalSaved',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
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

            // 3. WHOLESALE PROCUREMENT RECOVERY CYCLE (RESPONSIVE)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.vendorBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.sync_alt_rounded, color: AppColors.vendorPrimary, size: 16),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Wholesale Procurement Recovery Cycle',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.vendorPrimary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '4 Stages',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.vendorPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 520;
                      if (isCompact) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildStageItem('🏪 Kirana Stock', '12 Listed', Colors.grey.shade700)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
                                ),
                                Expanded(child: _buildStageItem('⏳ Near Expiry', '48h Window', AppColors.warning)),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Center(
                                child: Icon(Icons.arrow_downward_rounded, size: 14, color: AppColors.textSecondary),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(child: _buildStageItem('🏷️ 32% Discount', 'B2B Wholesale', AppColors.aiAccent)),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
                                ),
                                Expanded(child: _buildStageItem('💰 Saved', '₹6,940', AppColors.vendorPrimary)),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(child: _buildStageItem('🏪 Kirana Stock', '12 Listed', Colors.grey.shade700)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary),
                            ),
                            Expanded(child: _buildStageItem('⏳ Near Expiry', '48h Window', AppColors.warning)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary),
                            ),
                            Expanded(child: _buildStageItem('🏷️ 32% Discount', 'B2B Wholesale', AppColors.aiAccent)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary),
                            ),
                            Expanded(child: _buildStageItem('💰 Saved', '₹6,940', AppColors.vendorPrimary)),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. KEY SAVINGS METRICS (MATCHING NGO SUMMARY CARD STYLE)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 750;
                if (isWide) {
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildTotalSavedBox(totalSaved)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildNearExpiryBox(nearExpiryKg)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildAvgDiscountCard(avgDiscount)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildOrdersDoneCard(ordersCount)),
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTotalSavedBox(totalSaved),
                      const SizedBox(height: 12),
                      _buildNearExpiryBox(nearExpiryKg),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildAvgDiscountCard(avgDiscount)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildOrdersDoneCard(ordersCount)),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // 5. NEAR-EXPIRY PURCHASES BY CATEGORY
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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
                      Text(
                        'Near-Expiry Purchases by Category',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        '86 kg Total',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.vendorPrimary),
                      ),
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

            // 6. PROCUREMENT SAVINGS TREND (BAR CHART WITH BACKGROUND GRID)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                          Text('Procurement Savings Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('Cumulative savings over last 4 months (₹)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '+18% vs prev month',
                          style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Background Grid Divider Lines & Modern Bars
                  Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Divider(height: 1, color: AppColors.border),
                            Divider(height: 1, color: AppColors.border),
                            Divider(height: 1, color: AppColors.border),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildModernBar('May', '₹1.2k', 0.40, false),
                            _buildModernBar('Jun', '₹3.0k', 0.60, false),
                            _buildModernBar('Jul', '₹4.9k', 0.82, false),
                            _buildModernBar('Aug', '₹6.9k', 1.00, true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7. PURCHASE VALUE RECOVERY GAUGE & STATS
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                      const Text(
                        'Purchase Value Recovery',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.vendorPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '₹6,940 / ₹28,500',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.vendorPrimary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Circular Gauge
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 86,
                            height: 86,
                            child: CircularProgressIndicator(
                              value: 6940.0 / 28500.0,
                              strokeWidth: 9,
                              backgroundColor: AppColors.vendorPrimary.withValues(alpha: 0.12),
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
                            _buildStatRow('Total Spend Volume:', '₹$totalSpend'),
                            const SizedBox(height: 6),
                            _buildStatRow('Total Net Savings:', '₹$totalSaved', isBold: true),
                            const SizedBox(height: 6),
                            _buildStatRow('Average Margin Boost:', '+${avgDiscount.toStringAsFixed(0)}% wholesale'),
                            const SizedBox(height: 6),
                            _buildStatRow('Completed Orders:', '$ordersCount B2B orders'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 8. SAVINGS INSIGHT / IMPACT CARD ("Your Procurement Impact")
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
                  const SizedBox(height: 12),
                  const Text(
                    'Your discounted procurement strategy is helping recover value from near-expiry inventory while reducing purchasing costs.',
                    style: TextStyle(fontSize: 12, height: 1.45, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 500;
                      if (isCompact) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildEcoTile('💰', '₹6,940', 'Cost Saved')),
                                const SizedBox(width: 8),
                                Expanded(child: _buildEcoTile('🛒', '86 kg', 'Stock Recovered')),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(child: _buildEcoTile('📦', '15', 'Orders Done')),
                                const SizedBox(width: 8),
                                Expanded(child: _buildEcoTile('🌱', '~142 kg', 'CO₂ Prevented')),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(child: _buildEcoTile('💰', '₹6,940', 'Cost Saved')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildEcoTile('🛒', '86 kg', 'Stock Recovered')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildEcoTile('📦', '15', 'Orders Done')),
                            const SizedBox(width: 8),
                            Expanded(child: _buildEcoTile('🌱', '~142 kg', 'CO₂ Prevented')),
                          ],
                        );
                      }
                    },
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

  // RECOVERY CYCLE STAGE TILE
  Widget _buildStageItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // REDESIGNED BOX 1 — TOTAL SAVED (WITH MINI AREA SPARKLINE CHART)
  Widget _buildTotalSavedBox(int totalSaved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.06),
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
              Row(
                children: const [
                  Text('💰', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Total Saved',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.success),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+18% this mo',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '₹$totalSaved',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: CustomPaint(
              painter: _SavingsSparklinePainter(color: AppColors.success),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Total wholesale procurement savings',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // REDESIGNED BOX 2 — NEAR-EXPIRY BOUGHT (WITH RADIAL PROGRESS RING)
  Widget _buildNearExpiryBox(int nearExpiryKg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.vendorPrimary.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.vendorPrimary.withValues(alpha: 0.06),
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
              Row(
                children: const [
                  Text('🛒', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Near-Expiry Bought',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.vendorPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.vendorPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Stock Recovered',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.vendorPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$nearExpiryKg kg',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '86% capacity target reached',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.vendorPrimary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(48, 48),
                      painter: _RadialProgressPainter(
                        progress: 0.86,
                        color: AppColors.vendorPrimary,
                      ),
                    ),
                    const Text(
                      '86%',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.vendorPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Discounted surplus rescued from Kirana',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // BOX 3 — AVG DISCOUNT
  Widget _buildAvgDiscountCard(double avgDiscount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.06),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('🏷️', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text(
                    'Avg Discount',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.warning),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Wholesale B2B',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.warning),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${avgDiscount.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: avgDiscount / 100.0,
              minHeight: 6,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Average savings off MRP',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // BOX 4 — ORDERS DONE
  Widget _buildOrdersDoneCard(int ordersCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF4F46A5).withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46A5).withValues(alpha: 0.06),
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('📦', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 6),
                  Text(
                    'Orders Done',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5)),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'All Verified',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$ordersCount',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1.0,
              minHeight: 6,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '100% verified fulfillment',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // CATEGORY PROGRESS ROW
  Widget _buildCategoryProgressRow(String label, int kg, int total, String displayKg, String discount, Color color) {
    final progress = kg / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Row(
              children: [
                Text(displayKg, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
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
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // MODERN BAR CHART BAR
  Widget _buildModernBar(String month, String valStr, double heightFactor, bool isCurrent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isCurrent ? AppColors.vendorPrimary : Colors.grey.shade600,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            valStr,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 100 * heightFactor,
          width: 26,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCurrent
                  ? [
                      AppColors.vendorPrimary,
                      const Color(0xFF8B7CF6),
                    ]
                  : [
                      AppColors.vendorPrimary.withValues(alpha: 0.5),
                      AppColors.vendorPrimary.withValues(alpha: 0.25),
                    ],
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
            color: isCurrent ? AppColors.vendorPrimary : AppColors.textSecondary,
            fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // STAT ROW
  Widget _buildStatRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
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

  // ECO TILE
  Widget _buildEcoTile(String emoji, String val, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.vendorBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.vendorPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Box 1: Area Sparkline Curve
class _SavingsSparklinePainter extends CustomPainter {
  final Color color;

  _SavingsSparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [0.2, 0.45, 0.35, 0.7, 0.6, 0.95];
    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (points.length - 1);

    path.moveTo(0, size.height * (1 - points[0]));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, size.height * (1 - points[0]));

    for (int i = 1; i < points.length; i++) {
      final x = i * stepX;
      final y = size.height * (1 - points[i]);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Fill Gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Line Paint
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // End Point Circle Dot
    final endX = size.width;
    final endY = size.height * (1 - points.last);
    canvas.drawCircle(Offset(endX, endY), 4, Paint()..color = color);
    canvas.drawCircle(Offset(endX, endY), 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Painter for Box 2: Radial Progress Ring
class _RadialProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadialProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6) / 2;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 degrees
      2 * 3.14159 * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
