import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
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
                    color: AppColors.kiranaPrimary.withValues(alpha: 0.12),
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
                              AppColors.kiranaPrimary.withValues(alpha: 0.85),
                              AppColors.kiranaPrimary.withValues(alpha: 0.35),
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

            // 1. REDESIGNED POLISHED RETAIL DASHBOARD METRIC CARDS
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
                    _KiranaMetricCard(
                      value: '₹${state.kiranaRevenueRecovered.toStringAsFixed(0)}',
                      label: 'Revenue Recovered',
                      subtitle: 'Recovered through food rescue',
                      badgeText: '↑ +18% vs prior',
                      icon: Icons.trending_up_rounded,
                      color: AppColors.kiranaPrimary,
                      visualWidget: _SparklineVisual(
                        color: AppColors.kiranaPrimary,
                        totalText: '₹${(state.kiranaRevenueRecovered / 1000).toStringAsFixed(1)}K',
                      ),
                    ),
                    _KiranaMetricCard(
                      value: '${state.kiranaExpiringProducts}',
                      label: 'Expiring Stock',
                      subtitle: 'Products expiring within 3 days',
                      badgeText: 'Act Soon',
                      icon: Icons.access_time_rounded,
                      color: AppColors.warning,
                      visualWidget: _ExpiringStockVisual(
                        color: AppColors.warning,
                        totalCount: state.kiranaExpiringProducts,
                      ),
                    ),
                    _KiranaMetricCard(
                      value: '₹${state.kiranaPotentialLoss.toStringAsFixed(0)}',
                      label: 'Potential Loss',
                      subtitle: 'Value at risk from unsold stock',
                      badgeText: 'High Risk',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.critical,
                      visualWidget: _PotentialLossVisual(
                        color: AppColors.critical,
                        lossAmount: state.kiranaPotentialLoss,
                      ),
                    ),
                    _KiranaMetricCard(
                      value: '₹8,450',
                      label: 'Today\'s Sales',
                      subtitle: 'Sales generated today',
                      badgeText: '↑ 24 Orders',
                      icon: Icons.storefront_rounded,
                      color: const Color(0xFF4F46A5),
                      visualWidget: const _HourlySalesBarSparkline(color: Color(0xFF4F46A5)),
                    ),
                  ],
                );
              },
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
                    color: AppColors.warning.withValues(alpha: 0.12),
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
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '⚠ EXPIRING SOON ALERT',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.warning,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${state.kiranaExpiringProducts} products expire within 3 days.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'At-risk inventory value: ₹${state.kiranaPotentialLoss.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => onNavigateTab(1),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('MANAGE EXPIRING INVENTORY NOW', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
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
            const SizedBox(height: 20),

            // 3. 🤖 AI EXPIRY DETECTION & DISCOUNT RECOMMENDATION
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
                              children: [
                                Text(
                                  '🤖 AI HIGH RISK EXPIRY DETECTION',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.aiAccent,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(width: 6),
                                _LiveDot(),
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              '12 Full Cream Milk Packs Expire Tomorrow',
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
                      color: AppColors.kiranaBg.withValues(alpha: 0.5),
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
                            const Text(
                              'Potential Loss: ₹360 if left unsold.',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.kiranaPrimary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'AI Strategy',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.kiranaPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'AI Action Recommendation: Publish 30% Discount Offer (₹21/pack) to local Vendor buyers.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kiranaPrimary,
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDiscountScreen()));
                      },
                      icon: const Icon(Icons.bolt_rounded, size: 18, color: AppColors.kiranaPrimary),
                      label: const Text('CREATE DISCOUNT OFFER WITH AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.kiranaPrimary,
                        side: const BorderSide(color: AppColors.kiranaPrimary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: AppColors.kiranaPrimary.withValues(alpha: 0.04),
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
}

class _KiranaMetricCard extends StatelessWidget {
  final String value;
  final String label;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color color;
  final Widget visualWidget;

  const _KiranaMetricCard({
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

class _SparklineVisual extends StatelessWidget {
  final Color color;
  final String totalText;

  const _SparklineVisual({required this.color, this.totalText = '₹12.8K'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _SparklinePainter(color: color),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'May    Jun    Jul    Aug',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            Text(
              '↑ +18% Trend',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.kiranaPrimary),
            ),
          ],
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.75),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.45),
      Offset(size.width, size.height * 0.1),
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

class _ExpiringStockVisual extends StatelessWidget {
  final Color color;
  final int totalCount;

  const _ExpiringStockVisual({required this.color, this.totalCount = 12});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildExpiryRow('TODAY (24h)', '1 item', AppColors.critical, 0.2),
        _buildExpiryRow('1–2 DAYS', '3 items', AppColors.warning, 0.5),
        _buildExpiryRow('3 DAYS', '8 items', const Color(0xFFEAB308), 0.85),
        const Divider(height: 4, thickness: 0.5),
        const Text(
          '12 items need attention • Prioritize 3 high-risk',
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildExpiryRow(String label, String countStr, Color barColor, double factor) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(
            label,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: barColor),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: factor,
                backgroundColor: barColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          countStr,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _PotentialLossVisual extends StatelessWidget {
  final Color color;
  final double lossAmount;

  const _PotentialLossVisual({required this.color, this.lossAmount = 2850.0});

  @override
  Widget build(BuildContext context) {
    final recoverable = (lossAmount * 0.72).toStringAsFixed(0);
    final remainingRisk = (lossAmount * 0.28).toStringAsFixed(0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Risk Exposure Bar
        Row(
          children: [
            const Text(
              'RISK EXPOSURE:',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.critical),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: AppColors.critical.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.critical),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'HIGH',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.critical),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recoverable (AI Deals)', style: TextStyle(fontSize: 7, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text('₹$recoverable', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.kiranaPrimary)),
                ],
              ),
              Container(width: 1, height: 16, color: AppColors.border),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Remaining Risk', style: TextStyle(fontSize: 7, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  Text('₹$remainingRisk', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.critical)),
                ],
              ),
            ],
          ),
        ),
        const Text(
          'Inventory ➔ Expiry ➔ Financial Loss',
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _HourlySalesBarSparkline extends StatelessWidget {
  final Color color;
  const _HourlySalesBarSparkline({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [0.35, 0.55, 0.40, 0.95, 0.60];
    final times = ['9AM', '12PM', '3PM', '6PM', '9PM'];

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
                      const Text('₹2.4K', style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5))),
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
            Text('Peak: 3 PM–6 PM', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color(0xFF4F46A5))),
            Text('Avg ₹1.2K/hr', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

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

