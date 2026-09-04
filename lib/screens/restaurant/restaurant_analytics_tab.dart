import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';

class RestaurantAnalyticsTab extends StatefulWidget {
  const RestaurantAnalyticsTab({super.key});

  @override
  State<RestaurantAnalyticsTab> createState() => _RestaurantAnalyticsTabState();
}

class _RestaurantAnalyticsTabState extends State<RestaurantAnalyticsTab> {
  String _selectedPeriod = 'This Month';
  int _selectedPipelineStage = 2; // 0: Prepared, 1: Surplus, 2: Recovered, 3: Prevented
  int? _selectedTrendIndex; // Hover/tap on Food Waste Trend chart
  int _selectedDonutIndex = 0; // 0: Prepared Meals, 1: Curries, 2: Breads, 3: Salads
  int? _selectedBarIndex; // Hover/tap on Revenue Recovery bars

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // Dynamic multiplier based on reporting period
    final periodMultiplier = _selectedPeriod == 'This Week'
        ? 0.25
        : (_selectedPeriod == 'Last 3 Months' ? 3.0 : 1.0);

    final revenueRecovered = (18400 * periodMultiplier).round();
    final mealsSaved = (1820 * periodMultiplier).round();
    final foodDivertedKg = (450 * periodMultiplier).round();
    final co2PreventedKg = (foodDivertedKg * 2.5).round();
    final waterSavedL = (foodDivertedKg * 400).round();

    // Dynamic pipeline masses
    final preparedKg = (540 * periodMultiplier).round();
    final surplusKg = (48 * periodMultiplier).round();
    final recoveredKg = (42 * periodMultiplier).round();
    final preventedKg = (34 * periodMultiplier).round();

    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -----------------------------------------------------------------
            // 1. TOP HEADER WITH INTERACTIVE REPORTING PERIOD SELECTOR
            // -----------------------------------------------------------------
            _buildPeriodHeader(state),
            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // 2. KITCHEN ANALYTICS HERO BANNER
            // -----------------------------------------------------------------
            _buildHeroBanner(revenueRecovered, foodDivertedKg),
            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // 3. MAIN KPI SUMMARY METRIC CARDS (4 HIGH-DENSITY POLISHED CARDS)
            // -----------------------------------------------------------------
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 750;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRevenueSavedBox(revenueRecovered)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildWasteReductionBox()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMealsRescuedBox(mealsSaved)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildFoodDivertedBox(foodDivertedKg, co2PreventedKg)),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildRevenueSavedBox(revenueRecovered)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildWasteReductionBox()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMealsRescuedBox(mealsSaved)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFoodDivertedBox(foodDivertedKg, co2PreventedKg)),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 4. CIRCULAR REWARDS ECOSYSTEM (PART 2 & PART 3)
            // -----------------------------------------------------------------
            _buildCircularRewardsSection(state),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 5. INTERACTIVE FOOD VALUE RECOVERY PIPELINE
            // -----------------------------------------------------------------
            _buildInteractivePipeline(preparedKg, surplusKg, recoveredKg, preventedKg),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 6. FOOD WASTE TREND: GENERATED VS RECOVERED (DUAL LINE/AREA CHART)
            // -----------------------------------------------------------------
            _buildFoodWasteTrendCard(),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 7. FOOD RECOVERY BREAKDOWN (INTERACTIVE DONUT CHART)
            // -----------------------------------------------------------------
            _buildRecoveryBreakdownCard(foodDivertedKg),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 8. REVENUE RECOVERY OVER TIME (INTERACTIVE BAR CHART)
            // -----------------------------------------------------------------
            _buildRevenueRecoveryChartCard(),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 9. ENVIRONMENTAL & RESOURCE CONSERVATION SUMMARY
            // -----------------------------------------------------------------
            _buildEcoResourceImpactCard(foodDivertedKg, co2PreventedKg, waterSavedL, mealsSaved),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 10. KITCHEN WASTE INTELLIGENCE INSIGHTS
            // -----------------------------------------------------------------
            _buildKitchenInsightsCard(),
            const SizedBox(height: 20),

            // -----------------------------------------------------------------
            // 11. RECENT AUDIT & RECOVERY LEDGER
            // -----------------------------------------------------------------
            _buildRecentActivityLedger(state),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. TOP HEADER WITH PERIOD SELECTOR
  // ===========================================================================
  Widget _buildPeriodHeader(AppState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.2),
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
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.restaurantPrimary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🍽️', style: TextStyle(fontSize: 11)),
                          SizedBox(width: 4),
                          Text(
                            'RESTAURANT INTELLIGENCE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.restaurantPrimary,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⭐', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 3),
                          Text(
                            '${state.restaurantPoints} pts',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kitchen Waste Intelligence',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Data-driven food recovery, cost savings & circular rewards',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.restaurantBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.restaurantPrimary.withValues(alpha: 0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.restaurantPrimary, size: 18),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.restaurantPrimary,
                    ),
                    items: ['This Week', 'This Month', 'Last 3 Months'].map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedPeriod = val;
                          _selectedTrendIndex = null;
                          _selectedBarIndex = null;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Live sync active',
                    style: TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. HERO BANNER
  // ===========================================================================
  Widget _buildHeroBanner(int revenueRecovered, int foodDivertedKg) {
    return Container(
      height: 124,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.restaurantPrimary.withValues(alpha: 0.18),
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
                      Colors.black.withValues(alpha: 0.88),
                      AppColors.restaurantPrimary.withValues(alpha: 0.55),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'KITCHEN RECOVERY & CIRCULAR REWARDS',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          'Zero-Waste Kitchen Intelligence',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '₹$revenueRecovered Saved',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$foodDivertedKg kg diverted from landfill • 88% overall recovery efficiency',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 3. MAIN KPI SUMMARY METRIC CARDS
  // ===========================================================================

  // KPI 1: Cost Saved (with Mini Area Sparkline)
  Widget _buildRevenueSavedBox(int revenueRecovered) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.restaurantPrimary.withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.restaurantPrimary.withValues(alpha: 0.06),
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
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('💰', style: TextStyle(fontSize: 15)),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Cost Saved',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '+18%',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹$revenueRecovered',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            width: double.infinity,
            child: CustomPaint(
              painter: _AreaSparklinePainter(color: AppColors.restaurantPrimary),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Recovered surplus value',
            style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // KPI 2: Waste Reduction (with Radial Progress Ring)
  Widget _buildWasteReductionBox() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('📉', style: TextStyle(fontSize: 15)),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Reduction',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.success),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '-12%',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '32%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Goal: 40%',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.success),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(36, 36),
                      painter: _RadialProgressPainter(
                        progress: 0.80, // 32% of 40% goal = 80% achieved
                        color: AppColors.success,
                      ),
                    ),
                    const Text(
                      '80%',
                      style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: AppColors.success),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Targeting 40% zero waste',
            style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // KPI 3: Meals Rescued (with Distribution Bar)
  Widget _buildMealsRescuedBox(int mealsSaved) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.25), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.06),
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
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🍱', style: TextStyle(fontSize: 15)),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Meals Saved',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF7C3AED)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Impact',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF7C3AED)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$mealsSaved',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(flex: 65, child: Container(height: 6, color: const Color(0xFF7C3AED))),
                const SizedBox(width: 2),
                Expanded(flex: 35, child: Container(height: 6, color: AppColors.restaurantPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('65% NGO', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
              Text('35% Near-Expiry', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.restaurantPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Distributed to verified shelters',
            style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // KPI 4: Food Diverted (with Progress Bar & Landfill Metric)
  Widget _buildFoodDivertedBox(int foodDivertedKg, int co2PreventedKg) {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('♻️', style: TextStyle(fontSize: 15)),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Diverted Mass',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.warning),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '88% Saved',
                  style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$foodDivertedKg kg',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.88,
              minHeight: 6,
              backgroundColor: AppColors.warning.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text('Landfill Goal', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
              ),
              Text('$co2PreventedKg kg CO₂', style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.success)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Zero landfill redirection',
            style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. CIRCULAR REWARDS ECOSYSTEM (PART 2 & PART 3)
  // ===========================================================================
  Widget _buildCircularRewardsSection(AppState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('⭐', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FoodResQ Circular Rewards',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Tier: ${state.rewardTierEmoji} ${state.rewardTierName}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFD97706)),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${state.restaurantPoints} Points',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFD97706)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Circular Flow Visual Representation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.restaurantBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.sync_rounded, color: AppColors.restaurantPrimary, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'CONNECTED CIRCULAR LOOP',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary, letterSpacing: 0.8),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLoopStep('🍽️ RESTAURANT', 'Surplus Food', AppColors.restaurantPrimary),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
                    _buildLoopStep('🤝 NGO', 'Rescues Food', AppColors.ngoPrimary),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
                    _buildLoopStep('⭐ REWARDS', '+10 pts/kg', const Color(0xFFD97706)),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textSecondary),
                    _buildLoopStep('🏪 KIRANA', 'Discount Buy', AppColors.success),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Tier Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tier Progress: ${state.rewardTierName}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  Text(
                    state.pointsToNextTier > 0
                        ? '${state.pointsToNextTier} pts to next tier'
                        : 'Max Tier Reached!',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFD97706)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.tierProgress.clamp(0.05, 1.0),
                  minHeight: 7,
                  backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD97706)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Points Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildRewardStat('Earned This Month', '+${state.pointsEarnedThisMonth} pts', AppColors.success),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRewardStat('Points Redeemed', '${state.pointsRedeemedTotal} pts', const Color(0xFFD97706)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRewardStat('Extra Saved', '₹${state.restaurantPointsDiscountSaved.toStringAsFixed(0)}', AppColors.restaurantPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Two Action Buttons: Points History & Kirana Marketplace Redemption
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showPointsHistoryDialog(context, state),
                  icon: const Icon(Icons.history_rounded, size: 16),
                  label: const Text('POINTS HISTORY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFD97706),
                    side: const BorderSide(color: Color(0xFFF59E0B), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showKiranaMarketplaceDialog(context, state),
                  icon: const Icon(Icons.storefront_rounded, size: 16),
                  label: const Text('REDEEM ON KIRANA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoopStep(String role, String label, Color color) {
    return Column(
      children: [
        Text(
          role,
          style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: color),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRewardStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 1),
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Dialog: Points History
  void _showPointsHistoryDialog(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (c, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text('⭐', style: TextStyle(fontSize: 22)),
                      SizedBox(width: 8),
                      Text(
                        'FoodResQ Points Ledger',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Current Balance: ${state.restaurantPoints} pts  •  Tier: ${state.rewardTierEmoji} ${state.rewardTierName}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFD97706)),
              ),
              const Divider(height: 24),
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  itemCount: state.pointHistory.length,
                  separatorBuilder: (c, i) => const Divider(height: 16),
                  itemBuilder: (c, i) {
                    final item = state.pointHistory[i];
                    final isEarned = item.isEarned;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isEarned ? AppColors.success.withValues(alpha: 0.12) : AppColors.critical.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isEarned ? Icons.add_rounded : Icons.remove_rounded,
                            color: isEarned ? AppColors.success : AppColors.critical,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                  ),
                                  Text(
                                    isEarned ? '+${item.points} pts' : '${item.points} pts',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: isEarned ? AppColors.success : AppColors.critical,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.quantityStr,
                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                                  ),
                                  Text(
                                    '${item.timestamp.day}/${item.timestamp.month} ${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog: Kirana Near-Expiry Marketplace (Point Redemption)
  void _showKiranaMarketplaceDialog(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final offers = state.discountOffers.where((o) => !o.isPurchased).toList();
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            minChildSize: 0.5,
            expand: false,
            builder: (c, scrollCtrl) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text('🏪', style: TextStyle(fontSize: 22)),
                          SizedBox(width: 8),
                          Text(
                            'Kirana Near-Expiry Deals',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Redeem 500 FoodResQ Points for ₹100 extra OFF',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${state.restaurantPoints} pts available',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFD97706)),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Expanded(
                    child: offers.isEmpty
                        ? const Center(child: Text('No near-expiry inventory right now.'))
                        : ListView.separated(
                            controller: scrollCtrl,
                            itemCount: offers.length,
                            separatorBuilder: (c, i) => const SizedBox(height: 12),
                            itemBuilder: (c, i) {
                              final offer = offers[i];
                              final originalTotal = offer.originalPrice * offer.availableQuantity;
                              final kiranaPrice = offer.discountedPrice * offer.availableQuantity;
                              const pointsToUse = 500;
                              const pointsDiscount = 100.0;
                              final finalPrice = (kiranaPrice - pointsDiscount).clamp(0.0, double.infinity);
                              final hasEnoughPoints = state.restaurantPoints >= pointsToUse;

                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border, width: 1.2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            offer.productName,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.success.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '${offer.discountPercent}% KIRANA OFF',
                                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.success),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Store: ${offer.kiranaName}  •  ${offer.availableQuantity} ${offer.unit} available',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.restaurantBg,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Original: ₹${originalTotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: AppColors.textSecondary)),
                                              Text('Kirana: ₹${kiranaPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text('-₹100 (500 pts)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                                              Text(
                                                'Final: ₹${finalPrice.toStringAsFixed(0)}',
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.success),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: !hasEnoughPoints
                                            ? null
                                            : () {
                                                final result = state.redeemPointsForKiranaOffer(
                                                  offer: offer,
                                                  pointsToUse: pointsToUse,
                                                );
                                                Navigator.pop(ctx);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(result['message'] as String),
                                                    backgroundColor: AppColors.success,
                                                  ),
                                                );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: hasEnoughPoints ? const Color(0xFFD97706) : Colors.grey.shade300,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                        ),
                                        child: Text(
                                          hasEnoughPoints
                                              ? '⭐ REDEEM 500 PTS & BUY (₹${finalPrice.toStringAsFixed(0)})'
                                              : 'Not enough FoodResQ Points (Need 500)',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ===========================================================================
  // 5. INTERACTIVE FOOD VALUE RECOVERY PIPELINE
  // ===========================================================================
  Widget _buildInteractivePipeline(int preparedKg, int surplusKg, int recoveredKg, int preventedKg) {
    final stages = [
      {
        'title': 'Prepared',
        'mass': '$preparedKg kg',
        'rate': '100%',
        'icon': '🍳',
        'color': Colors.grey.shade700,
        'info': 'Baseline kitchen volume cooked daily across lunch and dinner services.',
        'action': 'Monitor kitchen forecasting to trim portion surplus.'
      },
      {
        'title': 'Surplus',
        'mass': '$surplusKg kg',
        'rate': '8.9%',
        'icon': '📦',
        'color': AppColors.warning,
        'info': 'Unsold safe food identified at end of active service windows.',
        'action': 'Activate automated 8-minute cascading to NGO partners.'
      },
      {
        'title': 'Recovered',
        'mass': '$recoveredKg kg',
        'rate': '87.5%',
        'icon': '♻️',
        'color': AppColors.restaurantPrimary,
        'info': 'Surplus food matched with verified local NGOs and discount flash buyers.',
        'action': 'Achieving 87.5% recovery rate — ₹18,400 commercial value recovered.'
      },
      {
        'title': 'Prevented',
        'mass': '$preventedKg kg',
        'rate': '81.0%',
        'icon': '🌱',
        'color': AppColors.success,
        'info': 'Food diverted completely from municipal landfills, preventing methane generation.',
        'action': 'Offset 1,125 kg CO₂ and earned FoodResQ Reward Points.'
      },
    ];

    final currentStage = stages[_selectedPipelineStage];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                      color: AppColors.restaurantPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.account_tree_rounded, color: AppColors.restaurantPrimary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Food Value Recovery Pipeline',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Tap stage for details',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal 4-Stage Flow Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textSecondary);
              }
              final stageIndex = index ~/ 2;
              final stage = stages[stageIndex];
              final isSelected = _selectedPipelineStage == stageIndex;
              final color = stage['color'] as Color;

              return Expanded(
                child: InkWell(
                  onTap: () => setState(() => _selectedPipelineStage = stageIndex),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? color : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(stage['icon'] as String, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          stage['title'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? color : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            stage['mass'] as String,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Interactive Stage Inspector Drawer Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (currentStage['color'] as Color).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: (currentStage['color'] as Color).withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (currentStage['color'] as Color).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(currentStage['icon'] as String, style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stage: ${currentStage['title']} (${currentStage['mass']})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: currentStage['color'] as Color,
                            ),
                          ),
                          Text(
                            'Conversion: ${currentStage['rate']}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: currentStage['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentStage['info'] as String,
                        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '💡 Action: ${currentStage['action']}',
                        style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 6. FOOD WASTE TREND: GENERATED VS RECOVERED (DUAL LINE/AREA CHART)
  // ===========================================================================
  Widget _buildFoodWasteTrendCard() {
    // Dynamic series data based on period
    final List<String> labels;
    final List<double> generated;
    final List<double> recovered;

    if (_selectedPeriod == 'This Week') {
      labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      generated = [12.0, 15.0, 9.0, 18.0, 14.0, 22.0, 16.0];
      recovered = [10.5, 13.0, 8.0, 16.0, 12.5, 19.5, 14.0];
    } else if (_selectedPeriod == 'Last 3 Months') {
      labels = ['June', 'July', 'August'];
      generated = [180.0, 165.0, 145.0];
      recovered = [142.0, 140.0, 132.0];
    } else {
      // This Month (4 Weeks)
      labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      generated = [48.0, 42.0, 36.0, 31.0];
      recovered = [38.0, 36.0, 32.0, 28.0];
    }

    final selectedIdx = _selectedTrendIndex ?? (labels.length - 1);
    final selLabel = labels[selectedIdx];
    final selGen = generated[selectedIdx];
    final selRec = recovered[selectedIdx];
    final selRate = ((selRec / selGen) * 100).round();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Food Waste & Recovery Trend',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Waste Generated vs Food Rescued',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '88% Avg Recovery',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.success),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Chart Legend & Tooltip readout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.critical, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Generated Waste', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(width: 12),
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('Food Recovered', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.restaurantBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.restaurantPrimary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '$selLabel: $selRec / $selGen kg ($selRate%)',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.restaurantPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart Canvas Container
          SizedBox(
            height: 140,
            width: double.infinity,
            child: GestureDetector(
              onTapDown: (details) {
                final boxWidth = context.size?.width ?? 300;
                final tapX = details.localPosition.dx;
                final index = (tapX / (boxWidth / labels.length)).clamp(0, labels.length - 1).floor();
                setState(() => _selectedTrendIndex = index);
              },
              child: CustomPaint(
                painter: _DualSeriesTrendPainter(
                  labels: labels,
                  series1: generated,
                  series2: recovered,
                  color1: AppColors.critical,
                  color2: AppColors.success,
                  selectedIndex: selectedIdx,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Bottom Period Label Taps
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(labels.length, (i) {
              final isSel = selectedIdx == i;
              return InkWell(
                onTap: () => setState(() => _selectedTrendIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.restaurantPrimary.withValues(alpha: 0.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                      color: isSel ? AppColors.restaurantPrimary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. FOOD RECOVERY BREAKDOWN (INTERACTIVE DONUT CHART)
  // ===========================================================================
  Widget _buildRecoveryBreakdownCard(int foodDivertedKg) {
    final categories = [
      {'name': 'Prepared Meals', 'pct': 0.42, 'mass': (foodDivertedKg * 0.42).round(), 'color': AppColors.restaurantPrimary, 'icon': '🍱'},
      {'name': 'Curries & Gravy', 'pct': 0.28, 'mass': (foodDivertedKg * 0.28).round(), 'color': AppColors.warning, 'icon': '🍛'},
      {'name': 'Breads & Bakery', 'pct': 0.18, 'mass': (foodDivertedKg * 0.18).round(), 'color': const Color(0xFF7C3AED), 'icon': '🥖'},
      {'name': 'Salads & Sides', 'pct': 0.12, 'mass': (foodDivertedKg * 0.12).round(), 'color': AppColors.success, 'icon': '🥗'},
    ];

    final currentCat = categories[_selectedDonutIndex.clamp(0, categories.length - 1)];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                'Food Recovery Breakdown',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
              ),
              Text(
                'By Kitchen Category',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.restaurantPrimary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Distribution of recovered items salvaged from kitchen operations',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 18),

          // Donut & Breakdown Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;
              final donutWidget = SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _DonutChartPainter(
                        categories: categories,
                        selectedIndex: _selectedDonutIndex,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${((currentCat['pct'] as double) * 100).round()}%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: currentCat['color'] as Color,
                          ),
                        ),
                        Text(
                          '${currentCat['mass']} kg',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              final listWidget = Column(
                children: List.generate(categories.length, (i) {
                  final cat = categories[i];
                  final isSel = _selectedDonutIndex == i;
                  final color = cat['color'] as Color;
                  return InkWell(
                    onTap: () => setState(() => _selectedDonutIndex = i),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSel ? color.withValues(alpha: 0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSel ? color : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Text(cat['icon'] as String, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cat['name'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                                color: isSel ? color : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '${((cat['pct'] as double) * 100).round()}% (${cat['mass']} kg)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );

              if (isWide) {
                return Row(
                  children: [
                    donutWidget,
                    const SizedBox(width: 24),
                    Expanded(child: listWidget),
                  ],
                );
              } else {
                return Column(
                  children: [
                    donutWidget,
                    const SizedBox(height: 16),
                    listWidget,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 8. REVENUE RECOVERY OVER TIME (INTERACTIVE BAR CHART)
  // ===========================================================================
  Widget _buildRevenueRecoveryChartCard() {
    final weeks = [
      {'label': 'Week 1', 'val': 3800, 'factor': 0.72},
      {'label': 'Week 2', 'val': 4400, 'factor': 0.83},
      {'label': 'Week 3', 'val': 4900, 'factor': 0.92},
      {'label': 'Week 4', 'val': 5300, 'factor': 1.00},
    ];

    final selIdx = _selectedBarIndex ?? 3;
    final selBar = weeks[selIdx];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                    'Revenue Recovery Progression',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Weekly commercial value salvaged from surplus',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.restaurantPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Selected: ₹${selBar['val']}',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Bar chart layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(weeks.length, (i) {
              final w = weeks[i];
              final isSel = selIdx == i;
              final factor = w['factor'] as double;
              final isPeak = factor >= 1.0;

              return InkWell(
                onTap: () => setState(() => _selectedBarIndex = i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.restaurantPrimary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹${w['val']}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: isSel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 100 * factor,
                      width: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            isSel ? AppColors.restaurantPrimary : AppColors.restaurantPrimary.withValues(alpha: 0.7),
                            isSel ? const Color(0xFFFF8B7A) : AppColors.restaurantPrimary.withValues(alpha: 0.35),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: isPeak ? Border.all(color: AppColors.restaurantPrimary, width: 1.5) : null,
                        boxShadow: [
                          if (isSel)
                            BoxShadow(
                              color: AppColors.restaurantPrimary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      w['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSel ? FontWeight.w900 : FontWeight.w600,
                        color: isSel ? AppColors.restaurantPrimary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. ENVIRONMENTAL & RESOURCE CONSERVATION SUMMARY
  // ===========================================================================
  Widget _buildEcoResourceImpactCard(int foodDivertedKg, int co2PreventedKg, int waterSavedL, int mealsSaved) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
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
                'Environmental & Resource Conservation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              Text(
                'Verified Carbon Ledger',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildEcoTile('♻️', '$foodDivertedKg kg', 'Food Diverted from Landfill'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEcoTile('🌱', '$co2PreventedKg kg', 'CO₂ Emissions Prevented'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEcoTile('💧', '${(waterSavedL / 1000).round()}k L', 'Virtual Water Footprint Saved'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEcoTile('🍽️', '$mealsSaved', 'Beneficiary Meals Served'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEcoTile(String emoji, String val, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.restaurantBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.restaurantPrimary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            val,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 10. KITCHEN WASTE INTELLIGENCE INSIGHTS
  // ===========================================================================
  Widget _buildKitchenInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: AppColors.restaurantPrimary, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Kitchen Waste Intelligence Insights',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Text(
                'AI Recommendations',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.restaurantPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _buildInsightRow(
            icon: Icons.access_time_filled_rounded,
            color: AppColors.warning,
            tag: 'Peak Waste Window: 7:30 – 9:30 PM',
            body: 'Dinner rush accounts for 62% of daily surplus. Activating automatic 8-min cascading 20 mins earlier recovered ₹1,450 more value this week.',
          ),
          const Divider(height: 18),
          _buildInsightRow(
            icon: Icons.star_rounded,
            color: AppColors.restaurantPrimary,
            tag: 'Highest Recovery: Curries & Gravies (91%)',
            body: 'Curries & gravies achieved a 91% zero-waste redirect rate via smart NGO matching, saving ₹6,800 in ingredients.',
          ),
          const Divider(height: 18),
          _buildInsightRow(
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            tag: 'Monthly Progress: 32% Waste Reduction',
            body: 'Kitchen preparation efficiency is pacing at 32% waste reduction, on track to achieve the 35% zero-waste milestone by month end.',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required Color color,
    required String tag,
    required String body,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tag,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 11. RECENT AUDIT & RECOVERY LEDGER
  // ===========================================================================
  Widget _buildRecentActivityLedger(AppState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
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
                'Recent Recovery & Rewards Ledger',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              Text(
                'Verified Activity',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityItem('🟢 NGO Dispatch Completed', '35 meals (Rice & Paneer Curry) received by Koramangala NGO • +250 Points', '2 hours ago'),
          const Divider(height: 16),
          _buildActivityItem('🟢 Kirana Reward Redeemed', 'Used 500 FoodResQ Points for ₹100 OFF on Sharma Kirana inventory', '4 hours ago'),
          const Divider(height: 16),
          _buildActivityItem('🟢 Kitchen Prep Optimized', 'AI Forecast adjusted rice batch down 12% to prevent surplus', 'Yesterday'),
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

// =============================================================================
// CUSTOM PAINTERS FOR REALISTIC CHARTS
// =============================================================================

// Area Sparkline Painter for KPI Box
class _AreaSparklinePainter extends CustomPainter {
  final Color color;
  _AreaSparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final points = [0.25, 0.45, 0.38, 0.65, 0.58, 0.85, 0.95];
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

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    final endX = size.width;
    final endY = size.height * (1 - points.last);
    canvas.drawCircle(Offset(endX, endY), 3.5, Paint()..color = color);
    canvas.drawCircle(Offset(endX, endY), 2.0, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Radial Progress Ring Painter
class _RadialProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadialProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 5) / 2;

    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 deg
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dual Series Trend Painter (Generated vs. Recovered)
class _DualSeriesTrendPainter extends CustomPainter {
  final List<String> labels;
  final List<double> series1; // Generated (Critical)
  final List<double> series2; // Recovered (Success)
  final Color color1;
  final Color color2;
  final int selectedIndex;

  _DualSeriesTrendPainter({
    required this.labels,
    required this.series1,
    required this.series2,
    required this.color1,
    required this.color2,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series1.isEmpty || series2.isEmpty) return;

    final maxVal = (series1 + series2).reduce(math.max) * 1.15;
    final stepX = size.width / (labels.length - 1);

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.6)
      ..strokeWidth = 1.0;

    for (int g = 1; g <= 3; g++) {
      final y = size.height * (g / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Helper to draw a series
    void drawSeries(List<double> data, Color c, bool isDashed) {
      final path = Path();
      final fillPath = Path();

      final firstY = size.height * (1 - (data[0] / maxVal));
      path.moveTo(0, firstY);
      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, firstY);

      for (int i = 1; i < data.length; i++) {
        final x = i * stepX;
        final y = size.height * (1 - (data[i] / maxVal));
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      fillPath.lineTo(size.width, size.height);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          colors: [c.withValues(alpha: 0.18), c.withValues(alpha: 0.0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.fill;

      canvas.drawPath(fillPath, fillPaint);

      final strokePaint = Paint()
        ..color = c
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, strokePaint);

      // Draw point markers
      for (int i = 0; i < data.length; i++) {
        final x = i * stepX;
        final y = size.height * (1 - (data[i] / maxVal));
        final isSelected = i == selectedIndex;

        canvas.drawCircle(Offset(x, y), isSelected ? 5.0 : 3.0, Paint()..color = c);
        canvas.drawCircle(Offset(x, y), isSelected ? 3.0 : 1.5, Paint()..color = Colors.white);
      }
    }

    // Draw Series 1 (Generated Waste)
    drawSeries(series1, color1, false);

    // Draw Series 2 (Food Recovered)
    drawSeries(series2, color2, false);

    // Draw Vertical Selection Indicator Line
    if (selectedIndex >= 0 && selectedIndex < labels.length) {
      final selX = selectedIndex * stepX;
      final selLinePaint = Paint()
        ..color = AppColors.restaurantPrimary.withValues(alpha: 0.5)
        ..strokeWidth = 1.2;

      canvas.drawLine(Offset(selX, 0), Offset(selX, size.height), selLinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Donut Chart Painter
class _DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;

  _DonutChartPainter({required this.categories, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    const strokeWidth = 18.0;

    double startAngle = -math.pi / 2;

    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      final sweepAngle = 2 * math.pi * (cat['pct'] as double);
      final color = cat['color'] as Color;
      final isSelected = i == selectedIndex;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 4 : strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius - strokeWidth / 2),
        startAngle + 0.03, // Small gap
        sweepAngle - 0.06,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
