import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
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
            // 0. RESTAURANT HERO PHOTO BANNER (Matching Kirana Store Banner Structure)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withValues(alpha: 0.14),
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
                              AppColors.restaurantPrimary.withValues(alpha: 0.85),
                              AppColors.restaurantPrimary.withValues(alpha: 0.35),
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
                              color: Colors.white.withValues(alpha: 0.25),
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

            // 1. REDESIGNED COMPACT INFORMATION-RICH RESTAURANT METRIC CARDS
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.05 : 0.58,
                  children: [
                    _RestaurantMetricCard(
                      value: '₹${state.restaurantRevenueToday.toStringAsFixed(0)}',
                      label: 'Revenue Recovered',
                      subtitle: 'Recovered through food rescue',
                      badgeText: '↑ +16% Today',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.restaurantPrimary,
                      visualWidget: _RestaurantRevenueSparklineVisual(
                        color: AppColors.restaurantPrimary,
                        totalText: '₹${(state.restaurantRevenueToday / 1000).toStringAsFixed(1)}K',
                      ),
                    ),
                    _RestaurantMetricCard(
                      value: '${state.restaurantSavedMealsToday}',
                      label: 'Meals Saved',
                      subtitle: 'Redirected to NGOs & buyers',
                      badgeText: '+18 today',
                      icon: Icons.volunteer_activism_rounded,
                      color: AppColors.success,
                      visualWidget: _MealsSavedDistributionVisual(
                        color: AppColors.success,
                        totalMeals: state.restaurantSavedMealsToday,
                      ),
                    ),
                    _RestaurantMetricCard(
                      value: '${state.restaurantWasteKgToday.toStringAsFixed(0)} kg',
                      label: 'Waste Prevented',
                      subtitle: 'Kitchen food waste diverted',
                      badgeText: '-24% waste',
                      icon: Icons.eco_rounded,
                      color: AppColors.warning,
                      visualWidget: _WastePreventedVisual(
                        color: AppColors.warning,
                        wasteKg: state.restaurantWasteKgToday,
                      ),
                    ),
                    _RestaurantMetricCard(
                      value: '86',
                      label: 'Orders Served',
                      subtitle: 'Active customer & rescue orders',
                      badgeText: '↑ 86 Orders',
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFF4F46A5),
                      visualWidget: const _RestaurantOrdersBarSparkline(color: Color(0xFF4F46A5)),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // 2. PRIMARY CTA — ADD SURPLUS FOOD BATCH
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddSurplusScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.restaurantPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                label: const Text(
                  '+ ADD SURPLUS FOOD BATCH',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. 📦 ACTIVE SURPLUS STATUS & NGO MATCHING ALERT CARD (Matching Kirana Alert Pattern)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.restaurantPrimary.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.restaurantPrimary.withValues(alpha: 0.08),
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
                          color: AppColors.restaurantPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.inventory_2_rounded, color: AppColors.restaurantPrimary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          '📦 ACTIVE SURPLUS & NGO DISPATCH',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.restaurantPrimary,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${state.surplusItems.length} active surplus batches ready for distribution.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Live connection active with Helping Hands Foundation & 3 local verified NGOs.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => onNavigateTab(1),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('MANAGE SURPLUS BATCHES NOW', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.restaurantPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. 🤖 AI KITCHEN WASTE FORECAST & DEMAND PREDICTION (Matching Kirana AI Card Pattern)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.aiAccent.withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aiAccent.withValues(alpha: 0.08),
                    blurRadius: 16,
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
                          gradient: LinearGradient(
                            colors: [
                              AppColors.aiAccent.withValues(alpha: 0.2),
                              AppColors.aiAccent.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.aiAccent.withValues(alpha: 0.3)),
                        ),
                        child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: const [
                                Flexible(
                                  child: Text(
                                    '🤖 AI KITCHEN WASTE FORECAST',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.aiAccent,
                                      letterSpacing: 0.8,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 6),
                                _LiveDot(),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tomorrow\'s Predicted Surplus: 16 kg',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
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
                      color: AppColors.restaurantBg.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.critical.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Risk Impact',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.critical,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Potential Waste Loss: ~₹1,250 if unmanaged.',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildForecastRow('Prepared Rice Batch', '8 kg at risk', 0.8),
                        const SizedBox(height: 6),
                        _buildForecastRow('Curry & Gravy', '5 kg at risk', 0.5),
                        const SizedBox(height: 6),
                        _buildForecastRow('Salad & Breads', '3 kg at risk', 0.3),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.restaurantPrimary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'AI Strategy',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.restaurantPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'AI Action Recommendation: Reduce Friday rice preparation by 12% based on historical demand patterns.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.restaurantPrimary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AI Inventory Plan applied! Prep target adjusted -12%.')),
                        );
                      },
                      icon: const Icon(Icons.bolt_rounded, size: 18, color: AppColors.restaurantPrimary),
                      label: const Text('PLAN INVENTORY WITH AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.restaurantPrimary,
                        side: const BorderSide(color: AppColors.restaurantPrimary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: AppColors.restaurantPrimary.withValues(alpha: 0.04),
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

  Widget _buildForecastRow(String item, String val, double factor) {
    return Row(
      children: [
        SizedBox(
          width: 105,
          child: Text(
            item,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: factor,
                backgroundColor: AppColors.restaurantPrimary.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.restaurantPrimary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(val, style: const TextStyle(color: AppColors.critical, fontWeight: FontWeight.bold, fontSize: 11)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// COMPACT POLISHED RESTAURANT DASHBOARD METRIC CARD (Kirana Design System)
// -----------------------------------------------------------------------------
class _RestaurantMetricCard extends StatelessWidget {
  final String value;
  final String label;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color color;
  final Widget visualWidget;

  const _RestaurantMetricCard({
    required this.value,
    required this.label,
    required this.subtitle,
    required this.badgeText,
    required this.icon,
    required this.color,
    required this.visualWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon Container + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
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

          const SizedBox(height: 8),

          // Main Metric Section
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
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
          const SizedBox(height: 2),
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

          const SizedBox(height: 10),

          // Prominent Visualization Area (Occupies ~40% of Card Height)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              ),
              child: visualWidget,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// VISUAL WIDGET 1: REVENUE RECOVERY SPARKLINE
// -----------------------------------------------------------------------------
class _RestaurantRevenueSparklineVisual extends StatelessWidget {
  final Color color;
  final String totalText;

  const _RestaurantRevenueSparklineVisual({required this.color, this.totalText = '₹4.3K'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _RestaurantSparklinePainter(color: color),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: Text(
                'Lunch • Midday • Dinner',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '↑ +16%',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RestaurantSparklinePainter extends CustomPainter {
  final Color color;
  _RestaurantSparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.22, size.height * 0.68),
      Offset(size.width * 0.45, size.height * 0.60),
      Offset(size.width * 0.70, size.height * 0.30),
      Offset(size.width * 0.88, size.height * 0.38),
      Offset(size.width, size.height * 0.10),
    ];

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
        colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.0)],
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// VISUAL WIDGET 2: MEALS SAVED DISTRIBUTION PROGRESS
// -----------------------------------------------------------------------------
class _MealsSavedDistributionVisual extends StatelessWidget {
  final Color color;
  final int totalMeals;

  const _MealsSavedDistributionVisual({required this.color, required this.totalMeals});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMealRow('NGO DONATION', '12 meals', AppColors.ngoPrimary, 0.67),
        _buildMealRow('DISCOUNT SALE', '6 meals', AppColors.restaurantPrimary, 0.33),
        const Divider(height: 4, thickness: 0.5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              child: Text(
                'Goal: 18/25 Target',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                '72% Goal',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.success),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMealRow(String label, String countStr, Color barColor, double factor) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: barColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 5,
              child: LinearProgressIndicator(
                value: factor,
                backgroundColor: barColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          flex: 3,
          child: Text(
            countStr,
            style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// VISUAL WIDGET 3: WASTE PREVENTED BREAKDOWN
// -----------------------------------------------------------------------------
class _WastePreventedVisual extends StatelessWidget {
  final Color color;
  final double wasteKg;

  const _WastePreventedVisual({required this.color, required this.wasteKg});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            const Flexible(
              child: Text(
                'DIVERTED:',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.warning),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 5,
                  child: LinearProgressIndicator(
                    value: 0.82,
                    backgroundColor: AppColors.warning.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '82%',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.warning),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Rice', style: TextStyle(fontSize: 7, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('11 kg', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary)),
                  ],
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.border),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Curries', style: TextStyle(fontSize: 7, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('8 kg', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.warning)),
                  ],
                ),
              ),
              Container(width: 1, height: 16, color: AppColors.border),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Breads', style: TextStyle(fontSize: 7, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('5 kg', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.success)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text(
          '58 kg CO₂ Offset Today',
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// VISUAL WIDGET 4: HOURLY ORDERS BAR SPARKLINE
// -----------------------------------------------------------------------------
class _RestaurantOrdersBarSparkline extends StatelessWidget {
  final Color color;
  const _RestaurantOrdersBarSparkline({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [0.45, 0.35, 0.60, 0.95, 0.70];
    final times = ['12PM', '3PM', '6PM', '8PM', '10PM'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(heights.length, (index) {
              final h = heights[index];
              final isHighest = h >= 0.9;
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isHighest)
                      const Text('32', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5))),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: h,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHighest ? color : color.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: times
              .map((t) => Text(t, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w600, color: AppColors.textSecondary)))
              .toList(),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              child: Text(
                'Rush: 7–9 PM',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF4F46A5)),
              ),
            ),
            Flexible(
              child: Text(
                '18 ord/hr',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// LIVE DOT INDICATOR
// -----------------------------------------------------------------------------
class _LiveDot extends StatelessWidget {
  const _LiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.aiAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.aiAccent,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

