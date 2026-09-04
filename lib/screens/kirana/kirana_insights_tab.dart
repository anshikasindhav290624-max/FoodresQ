import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/subtle_background_animation.dart';
import 'create_discount_screen.dart';

class KiranaInsightsTab extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const KiranaInsightsTab({super.key, this.onNavigateTab});

  @override
  State<KiranaInsightsTab> createState() => _KiranaInsightsTabState();
}

class _KiranaInsightsTabState extends State<KiranaInsightsTab> {
  String _selectedPeriod = 'Last 7 days';

  static const Map<String, _InsightsRangeData> _rangeDataMap = {
    'Last 7 days': _InsightsRangeData(
      label: 'Last 7 days',
      comparisonBadge: '↑ 24% vs prev 7 days',
      revenueStr: '₹3,450',
      revenueVal: 3450.0,
      nearExpirySalesStr: '₹1,800',
      nearExpirySalesVal: 1800.0,
      wastePreventedStr: '22 kg',
      wastePreventedKg: 22,
      wasteTargetKg: 25,
      wastePercent: 0.88,
      inventoryLossStr: '18% ↓',
      inventoryLossPercent: 18,
      retentionPercent: 0.82,
      bestPeriod: 'Saturday',
      growthPercent: '+24%',
      trendLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      trendRatios: [0.3, 0.45, 0.4, 0.65, 0.6, 0.95, 0.8],
      barLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      barValueStrs: ['₹320', '₹480', '₹410', '₹650', '₹580', '₹950', '₹760'],
      barRatios: [0.34, 0.51, 0.43, 0.68, 0.61, 1.0, 0.8],
      yLabels: ['₹1K', '₹800', '₹600', '₹400', '₹200', '₹0'],
    ),
    'Last 30 days': _InsightsRangeData(
      label: 'Last 30 days',
      comparisonBadge: '↑ 18% vs prev 30 days',
      revenueStr: '₹12,800',
      revenueVal: 12800.0,
      nearExpirySalesStr: '₹6,400',
      nearExpirySalesVal: 6400.0,
      wastePreventedStr: '86 kg',
      wastePreventedKg: 86,
      wasteTargetKg: 100,
      wastePercent: 0.86,
      inventoryLossStr: '23% ↓',
      inventoryLossPercent: 23,
      retentionPercent: 0.77,
      bestPeriod: 'Week 4',
      growthPercent: '+18%',
      trendLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      trendRatios: [0.4, 0.6, 0.78, 1.0],
      barLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      barValueStrs: ['₹2,400', '₹3,100', '₹3,500', '₹3,800'],
      barRatios: [0.63, 0.81, 0.92, 1.0],
      yLabels: ['₹4K', '₹3K', '₹2K', '₹1K', '₹0'],
    ),
    'Last 90 days': _InsightsRangeData(
      label: 'Last 90 days',
      comparisonBadge: '↑ 31% vs prev 90 days',
      revenueStr: '₹32,500',
      revenueVal: 32500.0,
      nearExpirySalesStr: '₹16,200',
      nearExpirySalesVal: 16200.0,
      wastePreventedStr: '240 kg',
      wastePreventedKg: 240,
      wasteTargetKg: 280,
      wastePercent: 0.85,
      inventoryLossStr: '28% ↓',
      inventoryLossPercent: 28,
      retentionPercent: 0.72,
      bestPeriod: 'August',
      growthPercent: '+31%',
      trendLabels: ['June', 'July', 'August'],
      trendRatios: [0.55, 0.78, 1.0],
      barLabels: ['June', 'July', 'August'],
      barValueStrs: ['₹8,500', '₹11,200', '₹12,800'],
      barRatios: [0.66, 0.875, 1.0],
      yLabels: ['₹14K', '₹10K', '₹6K', '₹2K', '₹0'],
    ),
    'This month': _InsightsRangeData(
      label: 'This month',
      comparisonBadge: '↑ 24% vs last month',
      revenueStr: '₹12,800',
      revenueVal: 12800.0,
      nearExpirySalesStr: '₹6,400',
      nearExpirySalesVal: 6400.0,
      wastePreventedStr: '86 kg',
      wastePreventedKg: 86,
      wasteTargetKg: 100,
      wastePercent: 0.86,
      inventoryLossStr: '23% ↓',
      inventoryLossPercent: 23,
      retentionPercent: 0.77,
      bestPeriod: 'Week 4',
      growthPercent: '+24%',
      trendLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      trendRatios: [0.42, 0.65, 0.82, 1.0],
      barLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      barValueStrs: ['₹2,400', '₹3,100', '₹3,500', '₹3,800'],
      barRatios: [0.63, 0.81, 0.92, 1.0],
      yLabels: ['₹4K', '₹3K', '₹2K', '₹1K', '₹0'],
    ),
    'Last month': _InsightsRangeData(
      label: 'Last month',
      comparisonBadge: '↑ 15% vs prev month',
      revenueStr: '₹10,200',
      revenueVal: 10200.0,
      nearExpirySalesStr: '₹5,100',
      nearExpirySalesVal: 5100.0,
      wastePreventedStr: '72 kg',
      wastePreventedKg: 72,
      wasteTargetKg: 90,
      wastePercent: 0.80,
      inventoryLossStr: '26% ↓',
      inventoryLossPercent: 26,
      retentionPercent: 0.74,
      bestPeriod: 'Week 3',
      growthPercent: '+15%',
      trendLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      trendRatios: [0.35, 0.6, 0.9, 0.75],
      barLabels: ['Wk 1', 'Wk 2', 'Wk 3', 'Wk 4'],
      barValueStrs: ['₹2,100', '₹2,900', '₹3,400', '₹1,800'],
      barRatios: [0.62, 0.85, 1.0, 0.53],
      yLabels: ['₹4K', '₹3K', '₹2K', '₹1K', '₹0'],
    ),
    'This year': _InsightsRangeData(
      label: 'This year',
      comparisonBadge: '↑ 42% vs last year',
      revenueStr: '₹84,600',
      revenueVal: 84600.0,
      nearExpirySalesStr: '₹42,000',
      nearExpirySalesVal: 42000.0,
      wastePreventedStr: '580 kg',
      wastePreventedKg: 580,
      wasteTargetKg: 650,
      wastePercent: 0.89,
      inventoryLossStr: '32% ↓',
      inventoryLossPercent: 32,
      retentionPercent: 0.68,
      bestPeriod: 'August',
      growthPercent: '+42%',
      trendLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
      trendRatios: [0.25, 0.35, 0.45, 0.5, 0.6, 0.72, 0.85, 1.0],
      barLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
      barValueStrs: ['₹6.2k', '₹7.5k', '₹8.9k', '₹9.8k', '₹10.4k', '₹11.5k', '₹12.1k', '₹12.8k'],
      barRatios: [0.48, 0.58, 0.69, 0.76, 0.81, 0.89, 0.94, 1.0],
      yLabels: ['₹14K', '₹10K', '₹6K', '₹2K', '₹0'],
    ),
  };

  _InsightsRangeData get _currentData => _rangeDataMap[_selectedPeriod] ?? _rangeDataMap['Last 7 days']!;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final rangeData = _currentData;

    return SubtleBackgroundAnimation(
      role: UserRole.kirana,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAGE HEADER WITH POLISHED INTERACTIVE PERIOD SELECTOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Revenue Recovery Insights',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Revenue Recovery & Waste Reduction',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  initialValue: _selectedPeriod,
                  onSelected: (val) {
                    setState(() {
                      _selectedPeriod = val;
                    });
                  },
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  itemBuilder: (context) {
                    final options = [
                      'Last 7 days',
                      'Last 30 days',
                      'Last 90 days',
                      'This month',
                      'Last month',
                      'This year',
                    ];
                    return options.map((opt) {
                      final isSelected = opt == _selectedPeriod;
                      return PopupMenuItem<String>(
                        value: opt,
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                              size: 16,
                              color: isSelected ? AppColors.kiranaPrimary : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              opt,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? AppColors.kiranaPrimary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.kiranaPrimary.withOpacity(0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kiranaPrimary.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.kiranaPrimary),
                        const SizedBox(width: 6),
                        Text(
                          _selectedPeriod,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColors.kiranaPrimary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // SECTION 1 — KPI OVERVIEW (REACTIVE TO DATE RANGE)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.25 : 0.84,
                  children: [
                    _KpiCard(
                      title: 'REVENUE RECOVERED',
                      value: rangeData.revenueStr,
                      subtitle: 'Recovered through food rescue',
                      badgeText: rangeData.comparisonBadge,
                      icon: Icons.payments_rounded,
                      color: AppColors.success,
                      visual: _KpiSparklineVisual(color: AppColors.success, points: rangeData.trendRatios),
                    ),
                    _KpiCard(
                      title: 'NEAR-EXPIRY SALES',
                      value: rangeData.nearExpirySalesStr,
                      subtitle: 'Revenue from near-expiry stock',
                      badgeText: 'Direct B2B',
                      icon: Icons.storefront_rounded,
                      color: AppColors.warning,
                      visual: _KpiBarVisual(color: AppColors.warning, ratios: rangeData.barRatios),
                    ),
                    _KpiCard(
                      title: 'WASTE PREVENTED',
                      value: rangeData.wastePreventedStr,
                      subtitle: 'Surplus inventory saved',
                      badgeText: '${(rangeData.wastePercent * 100).toInt()}% of target',
                      icon: Icons.eco_rounded,
                      color: AppColors.kiranaPrimary,
                      visual: _KpiRingVisual(color: AppColors.kiranaPrimary, percent: rangeData.wastePercent),
                    ),
                    _KpiCard(
                      title: 'INVENTORY LOSS',
                      value: rangeData.inventoryLossStr,
                      subtitle: 'Reduction in overall spoilage',
                      badgeText: '${(rangeData.retentionPercent * 100).toInt()}% retention',
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF4F46A5),
                      visual: _KpiProgressVisual(color: const Color(0xFF4F46A5), progress: rangeData.retentionPercent),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // SECTION 2 — REVENUE RECOVERY TREND (REACTIVE LARGE CHART)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey('trend_${_selectedPeriod}'),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
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
                            Text(
                              'Revenue Recovery Trend',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Recovered value generated from surplus inventory',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            rangeData.comparisonBadge,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _RevenueTrendChartPainter(
                          color: AppColors.kiranaPrimary,
                          labels: rangeData.trendLabels,
                          ratios: rangeData.trendRatios,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SECTIONS 3, 4 & 5 — DEEP-DIVE ANALYTICS CARDS (REACTIVE)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildWastePreventionCard(rangeData)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildNearExpirySalesCard(rangeData)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInventoryLossCard(rangeData)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildWastePreventionCard(rangeData),
                      const SizedBox(height: 12),
                      _buildNearExpirySalesCard(rangeData),
                      const SizedBox(height: 12),
                      _buildInventoryLossCard(rangeData),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // SECTION 6 — MONTHLY RECOVERY PERFORMANCE (REACTIVE GRAPH & FOOTER)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey('bar_${_selectedPeriod}'),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Monthly Recovery Performance',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'How recovered value changed over time',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            rangeData.comparisonBadge,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.success),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Bar Chart CustomPaint
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _MonthlyBarChartPainter(rangeData: rangeData),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3-Column Summary Footer
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.kiranaBg.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border.withOpacity(0.8)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildFooterSummaryCard('Highest Recovery', rangeData.revenueStr, AppColors.kiranaPrimary),
                          ),
                          Container(height: 32, width: 1, color: AppColors.border),
                          Expanded(
                            child: _buildFooterSummaryCard('Best Period', rangeData.bestPeriod, AppColors.textPrimary),
                          ),
                          Container(height: 32, width: 1, color: AppColors.border),
                          Expanded(
                            child: _buildFooterSummaryCard('Growth', rangeData.growthPercent, AppColors.success),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SECTION 7 — AI RECOVERY RECOMMENDATION
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.aiAccent.withOpacity(0.12),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                          color: AppColors.aiAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'AI Recovery Recommendation',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${state.kiranaExpiringProducts} products are approaching expiry in ${rangeData.label}. Prioritize dairy and packaged foods for B2B recovery to maximize recoverable value.',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (widget.onNavigateTab != null) {
                          widget.onNavigateTab!(1);
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDiscountScreen()));
                        }
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('View At-Risk Inventory →', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kiranaPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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

  // WASTE PREVENTION CARD
  Widget _buildWastePreventionCard(_InsightsRangeData data) {
    final remainingKg = data.wasteTargetKg - data.wastePreventedKg;
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Waste Prevention', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.kiranaPrimary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.kiranaPrimary, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.wastePreventedStr,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.kiranaPrimary),
          ),
          const Text('Waste Prevented', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Target: ${data.wasteTargetKg} kg', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('${(data.wastePercent * 100).toInt()}% achieved', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.kiranaPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: data.wastePercent,
                backgroundColor: AppColors.kiranaPrimary.withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.kiranaPrimary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$remainingKg kg remaining to target',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // NEAR-EXPIRY SALES CARD
  Widget _buildNearExpirySalesCard(_InsightsRangeData data) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Near-Expiry Sales', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Direct B2B deals', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.warning)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Revenue recovered before products expired', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Text(
            data.nearExpirySalesStr,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.warning),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(
              data.barLabels.take(4).length,
              (index) {
                final lbl = data.barLabels[index];
                final ratio = data.barRatios[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: _buildHorizontalBar(lbl, ratio, AppColors.warning),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Best performing period: ${data.bestPeriod}',
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  // INVENTORY LOSS CARD
  Widget _buildInventoryLossCard(_InsightsRangeData data) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Text('Inventory Loss Reduction', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46A5).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Reduced', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF4F46A5))),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Reduction in overall spoilage', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                data.inventoryLossStr,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_downward_rounded, color: AppColors.success, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Previous loss', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: 0.30,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade500),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Current loss', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: data.inventoryLossPercent / 100.0,
                backgroundColor: const Color(0xFF4F46A5).withOpacity(0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F46A5)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(30 - data.inventoryLossPercent)} percentage points improved',
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.success),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalBar(String month, double val, Color color) {
    return Row(
      children: [
        SizedBox(width: 32, child: Text(month, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: val,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSummaryCard(String title, String val, Color valColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: valColor),
        ),
      ],
    );
  }
}

// KPI CARD WIDGET
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color color;
  final Widget visual;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.color,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 26,
            width: double.infinity,
            child: visual,
          ),
        ],
      ),
    );
  }
}

// KPI VISUAL PAINTERS & WIDGETS
class _KpiSparklineVisual extends StatelessWidget {
  final Color color;
  final List<double> points;
  const _KpiSparklineVisual({required this.color, required this.points});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(color: color, pointsData: points),
      child: const SizedBox.expand(),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  final List<double> pointsData;
  _SparklinePainter({required this.color, required this.pointsData});

  @override
  void paint(Canvas canvas, Size size) {
    if (pointsData.isEmpty) return;

    final points = <Offset>[];
    for (int i = 0; i < pointsData.length; i++) {
      final x = (size.width / (pointsData.length - 1)) * i;
      final y = size.height * (1.0 - pointsData[i] * 0.85);
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.35), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = color;
    final outerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(points.last, 4.0, outerDotPaint);
    canvas.drawCircle(points.last, 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _KpiBarVisual extends StatelessWidget {
  final Color color;
  final List<double> ratios;
  const _KpiBarVisual({required this.color, required this.ratios});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: ratios.map((h) {
        final isHighest = h >= 0.9;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.5),
            height: 24 * h,
            decoration: BoxDecoration(
              color: isHighest ? color : color.withOpacity(0.35),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _KpiRingVisual extends StatelessWidget {
  final Color color;
  final double percent;
  const _KpiRingVisual({required this.color, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: CustomPaint(
            painter: _RingPainter(color: color, percent: percent),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(percent * 100).toInt()}% Target',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final Color color;
  final double percent;
  _RingPainter({required this.color, required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final bgPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 deg
      2 * 3.14159 * percent,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _KpiProgressVisual extends StatelessWidget {
  final Color color;
  final double progress;
  const _KpiProgressVisual({required this.color, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spoilage Reduced',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: color),
            ),
            Text(
              '${(progress * 100).toInt()}% Retention',
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

// LARGE TREND CHART PAINTER
class _RevenueTrendChartPainter extends CustomPainter {
  final Color color;
  final List<String> labels;
  final List<double> ratios;

  _RevenueTrendChartPainter({
    required this.color,
    required this.labels,
    required this.ratios,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double paddingLeft = 36.0;
    final double paddingBottom = 24.0;
    final double chartWidth = size.width - paddingLeft;
    final double chartHeight = size.height - paddingBottom;

    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final textStyle = const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500);

    final yLabels = ['Max', '75%', '50%', '0%'];
    for (int i = 0; i < 4; i++) {
      final y = (chartHeight / 3) * i;
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: yLabels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final points = <Offset>[];
    for (int i = 0; i < labels.length; i++) {
      final x = paddingLeft + (chartWidth / (labels.length - 1)) * i;
      final y = chartHeight * (1.0 - ratios[i] * 0.85);
      points.add(Offset(x, y));

      final textSpan = TextSpan(text: labels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, chartHeight + 6));
    }

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.lineTo(points.first.dx, chartHeight);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.25), color.withOpacity(0.01)],
      ).createShader(Rect.fromLTWH(paddingLeft, 0, chartWidth, chartHeight));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    for (final p in points) {
      final outerDot = Paint()..color = Colors.white;
      final innerDot = Paint()..color = color;
      canvas.drawCircle(p, 4.5, outerDot);
      canvas.drawCircle(p, 3.0, innerDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// MONTHLY BAR CHART PAINTER
class _MonthlyBarChartPainter extends CustomPainter {
  final _InsightsRangeData rangeData;

  _MonthlyBarChartPainter({required this.rangeData});

  @override
  void paint(Canvas canvas, Size size) {
    final double paddingLeft = 44.0;
    final double paddingBottom = 28.0;
    final double paddingTop = 28.0;
    final double chartWidth = size.width - paddingLeft;
    final double chartHeight = size.height - paddingBottom - paddingTop;

    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final textStyle = const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w500);
    final valueTextStyle = const TextStyle(fontSize: 10.5, color: AppColors.textPrimary, fontWeight: FontWeight.w800);
    final highlightValueTextStyle = const TextStyle(fontSize: 10.5, color: AppColors.kiranaPrimary, fontWeight: FontWeight.w900);
    final labelTextStyle = const TextStyle(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w700);

    // Y-Axis Grid lines & labels
    final yLabels = rangeData.yLabels;
    final int gridSteps = yLabels.length - 1;
    for (int i = 0; i <= gridSteps; i++) {
      final y = paddingTop + (chartHeight / gridSteps) * i;
      canvas.drawLine(Offset(paddingLeft, y), Offset(size.width, y), gridPaint);

      final textSpan = TextSpan(text: yLabels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    final barLabels = rangeData.barLabels;
    final barValueStrs = rangeData.barValueStrs;
    final barRatios = rangeData.barRatios;

    final int itemCount = barLabels.length;
    final double barWidth = ((chartWidth / itemCount) * 0.45).clamp(18.0, 48.0);

    for (int i = 0; i < itemCount; i++) {
      final double groupCenterX = paddingLeft + (chartWidth / itemCount) * (i + 0.5);
      final double barLeft = groupCenterX - barWidth / 2;
      final double barRight = groupCenterX + barWidth / 2;

      final double valRatio = barRatios[i];
      final double barHeight = chartHeight * valRatio;
      final double barTop = paddingTop + (chartHeight - barHeight);
      final double barBottom = paddingTop + chartHeight;

      final bool isHighest = valRatio >= 0.95;

      final Paint barPaint = Paint();
      if (isHighest) {
        barPaint.shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.kiranaPrimary,
            AppColors.kiranaPrimary.withOpacity(0.85),
          ],
        ).createShader(Rect.fromLTRB(barLeft, barTop, barRight, barBottom));
      } else {
        barPaint.color = AppColors.kiranaPrimary.withOpacity(0.3 + (i * 0.08).clamp(0.0, 0.4));
      }

      final RRect barRRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(barLeft, barTop, barRight, barBottom),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      );
      canvas.drawRRect(barRRect, barPaint);

      // Value label above bar
      final valSpan = TextSpan(text: barValueStrs[i], style: isHighest ? highlightValueTextStyle : valueTextStyle);
      final valPainter = TextPainter(text: valSpan, textDirection: TextDirection.ltr);
      valPainter.layout();
      valPainter.paint(canvas, Offset(groupCenterX - valPainter.width / 2, barTop - 18));

      // Month/Day label under bar
      final labelSpan = TextSpan(text: barLabels[i], style: labelTextStyle);
      final labelPainter = TextPainter(text: labelSpan, textDirection: TextDirection.ltr);
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(groupCenterX - labelPainter.width / 2, barBottom + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// DATA MODEL FOR DATE RANGE
class _InsightsRangeData {
  final String label;
  final String comparisonBadge;
  final String revenueStr;
  final double revenueVal;
  final String nearExpirySalesStr;
  final double nearExpirySalesVal;
  final String wastePreventedStr;
  final int wastePreventedKg;
  final int wasteTargetKg;
  final double wastePercent;
  final String inventoryLossStr;
  final int inventoryLossPercent;
  final double retentionPercent;
  final String bestPeriod;
  final String growthPercent;
  final List<String> trendLabels;
  final List<double> trendRatios;
  final List<String> barLabels;
  final List<String> barValueStrs;
  final List<double> barRatios;
  final List<String> yLabels;

  const _InsightsRangeData({
    required this.label,
    required this.comparisonBadge,
    required this.revenueStr,
    required this.revenueVal,
    required this.nearExpirySalesStr,
    required this.nearExpirySalesVal,
    required this.wastePreventedStr,
    required this.wastePreventedKg,
    required this.wasteTargetKg,
    required this.wastePercent,
    required this.inventoryLossStr,
    required this.inventoryLossPercent,
    required this.retentionPercent,
    required this.bestPeriod,
    required this.growthPercent,
    required this.trendLabels,
    required this.trendRatios,
    required this.barLabels,
    required this.barValueStrs,
    required this.barRatios,
    required this.yLabels,
  });
}


