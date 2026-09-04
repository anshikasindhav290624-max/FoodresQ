import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import 'deal_detail_screen.dart';

class VendorHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const VendorHomeTab({super.key, required this.onNavigateTab});

  String _getGroceryImageUrl(int index) {
    switch (index % 3) {
      case 0:
        return AppImage.groceryTomatoes;
      case 1:
        return AppImage.groceryMilk;
      case 2:
        return AppImage.groceryRice;
      default:
        return AppImage.groceryVeggies;
    }
  }

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
            // ─────────────────────────────────────────────────────────────────
            // 0. VENDOR MARKETPLACE HERO BANNER
            // ─────────────────────────────────────────────────────────────────
            Container(
              height: 140,
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
                              AppColors.vendorPrimary.withValues(alpha: 0.88),
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
                              'WHOLESALE DISCOUNT MARKETPLACE • BUYER HUB',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Consumer<AppState>(
                            builder: (_, s, __) => Text(
                              s.vendorName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
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

            // ─────────────────────────────────────────────────────────────────
            // 1. POLISHED KPI METRIC CARDS (Kirana-matching style)
            // ─────────────────────────────────────────────────────────────────
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
                    _VendorMetricCard(
                      value: '₹${state.vendorMoneySaved.toStringAsFixed(0)}',
                      label: 'Money Saved',
                      subtitle: 'Saved through discounted deals',
                      badgeText: '↑ +18% vs prior',
                      icon: Icons.savings_rounded,
                      color: AppColors.success,
                      visualWidget: _VendorSparklineVisual(
                        color: AppColors.success,
                        totalText: '₹${(state.vendorMoneySaved / 1000).toStringAsFixed(1)}K',
                      ),
                    ),
                    _VendorMetricCard(
                      value: '₹${state.vendorTotalPurchases.toStringAsFixed(0)}',
                      label: 'Total Purchases',
                      subtitle: 'Spent on wholesale stock',
                      badgeText: 'Procurement',
                      icon: Icons.shopping_cart_rounded,
                      color: AppColors.vendorPrimary,
                      visualWidget: _VendorPurchaseBarSparkline(color: AppColors.vendorPrimary),
                    ),
                    _VendorMetricCard(
                      value: '${state.vendorOrdersCount}',
                      label: 'Orders Placed',
                      subtitle: 'Completed B2B orders',
                      badgeText: '↑ Direct Kirana',
                      icon: Icons.inventory_2_rounded,
                      color: const Color(0xFF4F46A5),
                      visualWidget: _VendorOrdersVisual(
                        color: const Color(0xFF4F46A5),
                        ordersCount: state.vendorOrdersCount,
                      ),
                    ),
                    _VendorMetricCard(
                      value: '${state.discountOffers.length}',
                      label: 'Active Deals',
                      subtitle: 'Near-expiry offers available',
                      badgeText: 'Up to 30% OFF',
                      icon: Icons.local_offer_rounded,
                      color: AppColors.warning,
                      visualWidget: _VendorDealsVisual(
                        color: AppColors.warning,
                        offers: state.discountOffers,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // 2. ACTIVE DEALS ALERT CARD (mirrors Kirana expiry alert)
            // ─────────────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.vendorPrimary.withValues(alpha: 0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.vendorPrimary.withValues(alpha: 0.08),
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
                          color: AppColors.vendorPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: AppColors.vendorPrimary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '🛒 DEALS MARKETPLACE LIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.vendorPrimary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${state.discountOffers.length} near-expiry wholesale deals available now.',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated savings: ₹${state.vendorMoneySaved.toStringAsFixed(0)} • Up to 30% off MRP',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => onNavigateTab(1),
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('BROWSE ALL NEAR-EXPIRY DEALS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vendorPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // 3. RECOMMENDED B2B DEALS FEED
            // ─────────────────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recommended B2B Deals',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(1),
                  child: const Text(
                    'View All →',
                    style: TextStyle(color: AppColors.vendorPrimary, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...state.discountOffers.asMap().entries.take(2).map((entry) {
              final index = entry.key;
              final offer = entry.value;
              final imageUrl = _getGroceryImageUrl(index);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    AppImage(
                      url: imageUrl,
                      width: 72,
                      height: 72,
                      borderRadius: 14,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text(
                            '${offer.kiranaName} • ${offer.distanceKm} km away',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '₹${offer.originalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.vendorPrimary,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${offer.discountPercent}% OFF',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DealDetailScreen(offer: offer)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vendorPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('BUY', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PRIVATE WIDGET: _VendorMetricCard — mirrors _KiranaMetricCard exactly
// ─────────────────────────────────────────────────────────────────────────────
class _VendorMetricCard extends StatelessWidget {
  final String value;
  final String label;
  final String subtitle;
  final String badgeText;
  final IconData icon;
  final Color color;
  final Widget visualWidget;

  const _VendorMetricCard({
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
          // Top Row: Icon + Badge
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

          // Metric
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

          // Visualization Area
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

// ─────────────────────────────────────────────────────────────────────────────
// VISUAL: Savings sparkline area chart
// ─────────────────────────────────────────────────────────────────────────────
class _VendorSparklineVisual extends StatelessWidget {
  final Color color;
  final String totalText;

  const _VendorSparklineVisual({required this.color, this.totalText = '₹6.4K'});

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
              'May   Jun   Jul   Aug',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            Text(
              '↑ +18% Trend',
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISUAL: Purchase bar sparkline
// ─────────────────────────────────────────────────────────────────────────────
class _VendorPurchaseBarSparkline extends StatelessWidget {
  final Color color;
  const _VendorPurchaseBarSparkline({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [0.45, 0.65, 0.5, 0.80, 0.95];
    final labels = ['May', 'Jun', 'Jul', 'Aug', 'Sep'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(heights.length, (i) {
              final h = heights[i];
              final isHighest = h >= 0.9;
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isHighest)
                      Text('₹${(28.5 * h).toStringAsFixed(0)}K',
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: color)),
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
          children: labels
              .map((t) => Text(t, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w600, color: AppColors.textSecondary)))
              .toList(),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Peak: Sep', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: color)),
            const Text('↑ Growing', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISUAL: Orders radial progress
// ─────────────────────────────────────────────────────────────────────────────
class _VendorOrdersVisual extends StatelessWidget {
  final Color color;
  final int ordersCount;

  const _VendorOrdersVisual({required this.color, required this.ordersCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildOrderRow('COMPLETED', '$ordersCount', color, 0.88),
        _buildOrderRow('IN TRANSIT', '2', AppColors.warning, 0.15),
        _buildOrderRow('PENDING', '1', AppColors.textSecondary, 0.08),
        const Divider(height: 4, thickness: 0.5),
        Text(
          '$ordersCount orders completed • 3 active',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildOrderRow(String label, String count, Color c, double factor) {
    return Row(
      children: [
        SizedBox(
          width: 58,
          child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: c)),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: factor,
                backgroundColor: c.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(c),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VISUAL: Deals category breakdown
// ─────────────────────────────────────────────────────────────────────────────
class _VendorDealsVisual extends StatelessWidget {
  final Color color;
  final List<dynamic> offers;

  const _VendorDealsVisual({required this.color, required this.offers});

  @override
  Widget build(BuildContext context) {
    // Count by category from real discountOffers data
    final Map<String, int> catCount = {};
    for (final o in offers) {
      catCount[o.category] = (catCount[o.category] ?? 0) + 1;
    }
    final entries = catCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(3).toList();
    final total = offers.length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...top.map((e) {
          final factor = total > 0 ? e.value / total : 0.0;
          return _buildCatRow(e.key, '${e.value}', color, factor);
        }),
        const Divider(height: 4, thickness: 0.5),
        Text(
          '$total deals • ${catCount.length} categories',
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildCatRow(String label, String count, Color c, double factor) {
    final short = label.length > 8 ? '${label.substring(0, 8)}…' : label;
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(short, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: c)),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: factor,
                backgroundColor: c.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(c),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE: Sparkline CustomPainter (rising trend)
// ─────────────────────────────────────────────────────────────────────────────
class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.2, size.height * 0.70),
      Offset(size.width * 0.4, size.height * 0.75),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.42),
      Offset(size.width, size.height * 0.10),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final cp1 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p1.dy);
      final cp2 = Offset(p1.dx + (p2.dx - p1.dx) / 2, p2.dy);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(points.last, 4.0, Paint()..color = Colors.white);
    canvas.drawCircle(points.last, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
