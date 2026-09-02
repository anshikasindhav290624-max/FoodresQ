import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';

class NgoImpactTab extends StatefulWidget {
  const NgoImpactTab({super.key});

  @override
  State<NgoImpactTab> createState() => _NgoImpactTabState();
}

class _NgoImpactTabState extends State<NgoImpactTab> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // Dynamic metrics based on period selection
    final periodMultiplier = _selectedPeriod == 'This Week'
        ? 0.25
        : (_selectedPeriod == 'This Year' ? 12.0 : 1.0);

    final mealsSaved = (state.totalMealsSaved * periodMultiplier).round();
    final peopleServed = (state.peopleServed * periodMultiplier).round();
    final foodDivertedKg = (state.foodDivertedKg * periodMultiplier).round();
    final pickupsDone = (state.successfulPickups * periodMultiplier).round();

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER WITH PERIOD SELECTOR (UNCHANGED)
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
                          'Social Impact Dashboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Measurable metrics: meals saved & beneficiaries served',
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
                          color: AppColors.ngoBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.ngoPrimary.withValues(alpha: 0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedPeriod,
                            isDense: true,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.ngoPrimary, size: 18),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ngoPrimary,
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

            // 2. MAIN IMPACT SUMMARY — REDESIGNED THREE DISTINCT METRIC BOXES
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 750;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMealsSavedBox(mealsSaved)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildPeopleServedBox(peopleServed)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildFoodDivertedBox(foodDivertedKg)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildMealsSavedBox(mealsSaved),
                      const SizedBox(height: 12),
                      _buildPeopleServedBox(peopleServed),
                      const SizedBox(height: 12),
                      _buildFoodDivertedBox(foodDivertedKg),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // 3. IMPACT BREAKDOWN ("Where Your Impact Goes") — UNCHANGED
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
                        'Where Your Impact Goes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Distribution Breakdown',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.ngoPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownRow('🍲 Community Meals', 0.45, '45%', '${(mealsSaved * 0.45).round()} meals', AppColors.ngoPrimary),
                  const SizedBox(height: 12),
                  _buildBreakdownRow('👨‍👩‍👧‍👦 Families Supported', 0.30, '30%', '${(mealsSaved * 0.30).round()} meals', AppColors.success),
                  const SizedBox(height: 12),
                  _buildBreakdownRow('🏢 Local Shelters', 0.15, '15%', '${(mealsSaved * 0.15).round()} meals', AppColors.warning),
                  const SizedBox(height: 12),
                  _buildBreakdownRow('🍳 Community Kitchens', 0.10, '10%', '${(mealsSaved * 0.10).round()} meals', const Color(0xFF4F46A5)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. WEEKLY MEALS RESCUED TREND — UNCHANGED
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
                          Text('Weekly Meals Rescued', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          SizedBox(height: 2),
                          Text('Daily verified meal recovery volume', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '+14% vs last week',
                          style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Analytics Bar Chart Grid
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
                            _buildModernBar('Mon', '210', 0.55),
                            _buildModernBar('Tue', '280', 0.72),
                            _buildModernBar('Wed', '160', 0.42),
                            _buildModernBar('Thu', '340', 0.88),
                            _buildModernBar('Fri', '240', 0.62),
                            _buildModernBar('Sat', '390', 1.00),
                            _buildModernBar('Sun', '300', 0.78),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. IMPACT HIGHLIGHT — UNCHANGED
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ngoPrimary.withValues(alpha: 0.12),
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
                        url: AppImage.ngoCommunity,
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
                              AppColors.ngoPrimary.withValues(alpha: 0.65),
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'YOUR IMPACT THIS MONTH',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$mealsSaved meals rescued  •  $foodDivertedKg kg diverted  •  $peopleServed people served',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '“Every successful pickup helps turn surplus food into meals for people who need them.”',
                            style: TextStyle(fontSize: 11, color: Colors.white70, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 6. ENVIRONMENTAL IMPACT — UNCHANGED
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
                  const Text(
                    'Waste Reduction & Eco Impact',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEcoTile('♻️', '$foodDivertedKg kg', 'Food Diverted from Waste'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildEcoTile('🌱', '${(foodDivertedKg * 2.5).round()} kg', 'CO₂ Emissions Prevented'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildEcoTile('🚚', '$pickupsDone', 'Rescue Pickups Completed'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 7. RECENT IMPACT ACTIVITY — UNCHANGED
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Recent Impact Activity',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Verified Ledger',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem('🟢 Pickup completed', '35 meals rescued from Urban Tadka', '2 hours ago'),
                  const Divider(height: 16),
                  _buildActivityItem('🟢 Food distributed', '35 beneficiaries served at Koramangala Center', '3 hours ago'),
                  const Divider(height: 16),
                  _buildActivityItem('🟢 Restaurant surplus rescued', '20 meals collected from The Green Bowl', 'Yesterday'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // REDESIGNED BOX 1 — MEALS SAVED (WITH MINI AREA SPARKLINE CHART)
  Widget _buildMealsSavedBox(int mealsSaved) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.ngoPrimary.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.ngoPrimary.withValues(alpha: 0.06),
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
                  Text('🍱', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Meals Saved',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.ngoPrimary),
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
                  '+14% vs last period',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$mealsSaved',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          // Mini Area Sparkline Chart Visual Representation
          SizedBox(
            height: 48,
            width: double.infinity,
            child: CustomPaint(
              painter: _AreaSparklinePainter(color: AppColors.ngoPrimary),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Meals rescued from becoming food waste',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // REDESIGNED BOX 2 — PEOPLE SERVED (WITH RADIAL PROGRESS RING VISUAL)
  Widget _buildPeopleServedBox(int peopleServed) {
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
                children: const [
                  Text('🤝', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'People Served',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5)),
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
                  '+11% vs last period',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success),
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
                      '$peopleServed',
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
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF4F46A5)),
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
                        color: const Color(0xFF4F46A5),
                      ),
                    ),
                    const Text(
                      '86%',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF4F46A5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'People reached through rescued food',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // REDESIGNED BOX 3 — FOOD DIVERTED (WITH SEGMENTED HORIZONTAL PROGRESS BAR VISUAL)
  Widget _buildFoodDivertedBox(int foodDivertedKg) {
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
                children: const [
                  Text('♻️', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text(
                    'Food Diverted',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.warning),
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
                  '+16% vs last period',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$foodDivertedKg kg',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          // Segmented Horizontal Bar Visual Representation
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  children: [
                    Expanded(flex: 45, child: Container(height: 8, color: AppColors.ngoPrimary)),
                    const SizedBox(width: 2),
                    Expanded(flex: 35, child: Container(height: 8, color: AppColors.warning)),
                    const SizedBox(width: 2),
                    Expanded(flex: 20, child: Container(height: 8, color: const Color(0xFF4F46A5))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('🍱 Prepared 45%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  Text('🥦 Fresh 35%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  Text('🌾 Staples 20%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Food recovered instead of wasted',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String label, double factor, String percent, String countStr, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            Text('$percent ($countStr)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: factor,
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildModernBar(String day, String valStr, double heightFactor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.ngoPrimary,
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
          width: 22,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.ngoPrimary,
                AppColors.ngoPrimary.withValues(alpha: 0.65),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildEcoTile(String emoji, String val, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.ngoBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ngoPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(val, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String status, String title, String time) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.success)),
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

// Custom Painter for Box 1: Meals Saved Area Sparkline Curve
class _AreaSparklinePainter extends CustomPainter {
  final Color color;

  _AreaSparklinePainter({required this.color});

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

// Custom Painter for Box 2: People Served Radial Progress Ring
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
