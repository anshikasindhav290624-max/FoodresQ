import 'dart:math' as math;
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
  int? _hoveredBarIndex;

  // Derived savings data across 6 months based on real vendorMoneySaved total
  List<double> _getMonthlySavings(double total) {
    // Distribute total across 6 months with a realistic upward trend
    final factors = [0.08, 0.12, 0.14, 0.17, 0.20, 0.29];
    return factors.map((f) => total * f).toList();
  }

  List<String> get _monthLabels => ['Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep'];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final monthlySavings = _getMonthlySavings(state.vendorMoneySaved);
    final maxSaving = monthlySavings.reduce(math.max);

    // Category breakdown from real discountOffers data
    final Map<String, double> catSavings = {};
    for (final o in state.discountOffers) {
      final saving = o.originalPrice - o.discountedPrice;
      catSavings[o.category] = (catSavings[o.category] ?? 0) + saving;
    }
    final totalCatSaving = catSavings.values.fold(0.0, (a, b) => a + b);
    final catEntries = catSavings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────────────
            // 0. SAVINGS HERO BANNER
            // ─────────────────────────────────────────────────────────────────
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withValues(alpha: 0.12),
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
                              AppColors.vendorPrimary.withValues(alpha: 0.90),
                              AppColors.vendorPrimary.withValues(alpha: 0.30),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 14,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROCUREMENT SAVINGS & ANALYTICS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white70,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${state.vendorMoneySaved.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '+18% this month',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Total Money Saved on Wholesale Purchases',
                            style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // 1. 4 COMPACT KPI CARDS
            // ─────────────────────────────────────────────────────────────────
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.2 : 1.55,
                  children: [
                    _SavingsKpiTile(
                      value: '₹${state.vendorMoneySaved.toStringAsFixed(0)}',
                      label: 'Total Saved',
                      badge: '+18% MoM',
                      icon: Icons.savings_rounded,
                      color: AppColors.success,
                    ),
                    _SavingsKpiTile(
                      value: '${state.vendorNearExpiryBought} kg',
                      label: 'Near-Expiry Bought',
                      badge: 'Recovered',
                      icon: Icons.recycling_rounded,
                      color: AppColors.vendorPrimary,
                    ),
                    _SavingsKpiTile(
                      value: '32%',
                      label: 'Avg Discount',
                      badge: 'Wholesale',
                      icon: Icons.percent_rounded,
                      color: AppColors.warning,
                    ),
                    _SavingsKpiTile(
                      value: '${state.vendorOrdersCount}',
                      label: 'Orders Done',
                      badge: 'Direct B2B',
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xFF4F46A5),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // 2. MONTHLY SAVINGS TREND CHART (Interactive)
            // ─────────────────────────────────────────────────────────────────
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Savings Trend',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Money saved per month (₹)',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
                        ),
                        child: const Text(
                          '↑ +18% Avg',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.success),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Interactive bar chart
                  SizedBox(
                    height: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(monthlySavings.length, (i) {
                        final v = monthlySavings[i];
                        final heightFactor = maxSaving > 0 ? v / maxSaving : 0.0;
                        final isHovered = _hoveredBarIndex == i;
                        final isHighest = v == maxSaving;

                        return Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setState(() => _hoveredBarIndex = i),
                            onTapUp: (_) => setState(() => _hoveredBarIndex = null),
                            child: MouseRegion(
                              onEnter: (_) => setState(() => _hoveredBarIndex = i),
                              onExit: (_) => setState(() => _hoveredBarIndex = null),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isHovered || isHighest)
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 3),
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.vendorPrimary,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '₹${v.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white),
                                        ),
                                      ),
                                    Flexible(
                                      child: FractionallySizedBox(
                                        heightFactor: heightFactor.clamp(0.05, 1.0),
                                        alignment: Alignment.bottomCenter,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            color: isHovered || isHighest
                                                ? AppColors.vendorPrimary
                                                : AppColors.vendorPrimary.withValues(alpha: 0.38),
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _monthLabels[i],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isHighest ? FontWeight.w900 : FontWeight.w600,
                                        color: isHighest ? AppColors.vendorPrimary : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // 3. PURCHASE CATEGORY SAVINGS BREAKDOWN
            // ─────────────────────────────────────────────────────────────────
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
                        'Savings by Category',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.vendorBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.vendorSecondary),
                        ),
                        child: Text(
                          '${catEntries.length} Categories',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.vendorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Discount value saved per purchase category',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  if (catEntries.isEmpty)
                    const Center(
                      child: Text(
                        'No purchase data yet',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    ...catEntries.map((e) {
                      final factor = totalCatSaving > 0 ? e.value / totalCatSaving : 0.0;
                      final colors = [
                        AppColors.vendorPrimary,
                        AppColors.success,
                        AppColors.warning,
                        const Color(0xFF4F46A5),
                        AppColors.info,
                      ];
                      final colorIdx = catEntries.indexOf(e) % colors.length;
                      final barColor = colors[colorIdx];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(color: barColor, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      e.key,
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${e.value.toStringAsFixed(0)} (${(factor * 100).toStringAsFixed(0)}%)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: barColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: SizedBox(
                                height: 8,
                                child: LinearProgressIndicator(
                                  value: factor,
                                  backgroundColor: barColor.withValues(alpha: 0.12),
                                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // 4. RECENT SAVINGS / PURCHASE TRANSACTIONS
            // ─────────────────────────────────────────────────────────────────
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
                  const Text(
                    'Recent Purchase Savings',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Savings from your completed wholesale orders',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  if (state.transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.vendorBg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.receipt_long_outlined, color: AppColors.vendorPrimary, size: 32),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'No purchases yet',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const Text(
                              'Your savings will appear here after your first deal',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...state.transactions.take(5).map((txn) => _buildTransactionRow(txn)),

                  // Show deals from discountOffers as preview savings when no real txns
                  if (state.transactions.isEmpty) ...[
                    const Divider(),
                    const Text(
                      'Available savings on current deals:',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    ...state.discountOffers.take(4).map((o) => _buildOfferSavingRow(o)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(dynamic txn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.vendorBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.vendorSecondary.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.savings_outlined, color: AppColors.success, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.itemTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(txn.impactSummary,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Saved', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              Text(txn.status,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferSavingRow(dynamic offer) {
    final saving = offer.originalPrice - offer.discountedPrice;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.vendorPrimary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_offer_outlined, color: AppColors.vendorPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                Text('${offer.kiranaName} • ${offer.discountPercent}% off',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Per unit', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              Text(
                '₹${saving.toStringAsFixed(0)} off',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COMPACT KPI TILE (Savings tab — simpler than home cards, no Expanded visual)
// ─────────────────────────────────────────────────────────────────────────────
class _SavingsKpiTile extends StatelessWidget {
  final String value;
  final String label;
  final String badge;
  final IconData icon;
  final Color color;

  const _SavingsKpiTile({
    required this.value,
    required this.label,
    required this.badge,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: color),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
