import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import '../../widgets/trust_score_badge.dart';
import '../../widgets/cascade_timer_widget.dart';
import '../../widgets/smart_match_card.dart';
import 'ngo_trust_score_screen.dart';
import 'ngo_pickup_tracking_screen.dart';

class NgoHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const NgoHomeTab({super.key, required this.onNavigateTab});

  String _getFoodImageUrl(int index) {
    switch (index % 3) {
      case 0:
        return AppImage.foodThali;
      case 1:
        return AppImage.foodPaneer;
      case 2:
        return AppImage.foodBiryani;
      default:
        return AppImage.foodThali;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isAccepting = state.ngoAcceptingFood;

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 0. NGO HERO BANNER WITH REAL COMMUNITY FOOD IMAGE
            Container(
              width: double.infinity,
              height: 140,
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
                              AppColors.ngoPrimary.withValues(alpha: 0.85),
                              AppColors.ngoPrimary.withValues(alpha: 0.35),
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
                              'FOOD RECOVERY & COMMUNITY IMPACT',
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
                            'Helping Hands Foundation',
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

            // 1. LIVE DEMAND REQUIREMENT TOGGLE CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isAccepting ? AppColors.ngoPrimary : AppColors.border,
                  width: isAccepting ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isAccepting ? AppColors.ngoPrimary : Colors.grey).withValues(alpha: 0.08),
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
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isAccepting ? AppColors.success : AppColors.critical,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                isAccepting ? 'ACCEPTING SURPLUS FOOD' : 'NOT ACCEPTING FOOD',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: isAccepting ? AppColors.success : AppColors.critical,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: isAccepting,
                        onChanged: (val) => state.toggleNgoRequirement(),
                        activeColor: AppColors.ngoPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Capacity', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text(
                              '${state.ngoCapacityPercent}%',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 40, color: AppColors.border),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Requirement Target', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            Text(
                              '${state.ngoMealsRequirement} Meals',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.ngoPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. ENHANCED LARGE NUMERIC IMPACT METRICS CARDS (MEALS SAVED & PEOPLE SERVED)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildMealsSavedCard(state.totalMealsSaved),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPeopleServedCard(state.peopleServed),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. TRUST SCORE BADGE
            TrustScoreBadge(
              trustScore: state.trustScore,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NgoTrustScoreScreen()),
                );
              },
            ),
            const SizedBox(height: 16),

            // 4. 8-MINUTE CASCADE OPPORTUNITY TIMER
            if (state.isCascadeActive && state.activeCascadeItem != null) ...[
              CascadeTimerWidget(
                item: state.activeCascadeItem!,
                timerSeconds: state.cascadeTimerSeconds,
                onAccept: () {
                  final itemToTrack = state.activeCascadeItem!;
                  state.acceptCascadeOpportunity();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opportunity accepted! Opening Pickup Tracker...'),
                      backgroundColor: AppColors.ngoPrimary,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NgoPickupTrackingScreen(item: itemToTrack),
                    ),
                  );
                },
                onDecline: () {
                  state.declineCascadeOpportunity();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opportunity declined. Loading next opportunity...'),
                      backgroundColor: AppColors.warning,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: const [
                    Icon(Icons.check_circle_outline, color: AppColors.ngoPrimary, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No more nearby opportunities available',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'All available surplus food opportunities in your network have been reviewed.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 5. SMART MATCHING RECOMMENDATION BREAKDOWN
            SmartMatchCard(
              match: SmartMatchResult(
                ngoName: 'Helping Hands Foundation',
                overallMatch: 91,
                capacityScore: 95,
                distanceScore: 82,
                requirementScore: 90,
                trustScore: 92,
                pickupReliability: 88,
              ),
            ),
            const SizedBox(height: 20),

            // 6. QUICK NEARBY FOOD SURPLUS FEED WITH REAL FOOD IMAGES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby Available Surplus',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () => onNavigateTab(1),
                  child: const Text('View All (3) →'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...state.surplusItems.asMap().entries.take(2).map((entry) {
              final index = entry.key;
              final item = entry.value;
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
                    // Real Food Image
                    AppImage(
                      url: _getFoodImageUrl(index),
                      width: 72,
                      height: 72,
                      borderRadius: 14,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${item.restaurantName} • ${item.distanceKm} km away', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.ngoPrimary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.mealsCount} Meals • Pickup before 10:30 PM',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.ngoPrimary),
                            ),
                          ),
                        ],
                      ),
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

  // Specialized Rescued Food Metric Card
  Widget _buildMealsSavedCard(int mealsSaved) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          // 30–40% Visual Header: Rescued Prepared Meal Image + Subtle Trend Indicator
          Stack(
            children: [
              SizedBox(
                height: 75,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AppImage(
                    url: AppImage.foodThali,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.trending_up_rounded, color: AppColors.success, size: 12),
                      SizedBox(width: 3),
                      Text(
                        '+12% this wk',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Large Number & Label Hierarchy
          Text(
            '$mealsSaved',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              Icon(Icons.set_meal_rounded, size: 14, color: AppColors.ngoPrimary),
              SizedBox(width: 4),
              Text(
                'Meals Saved',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Specialized Community People Served Metric Card
  Widget _buildPeopleServedCard(int peopleServed) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          // 30–40% Visual Header: Beneficiaries Community Meal Image + Verified Indicator
          Stack(
            children: [
              SizedBox(
                height: 75,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AppImage(
                    url: AppImage.ngoCommunity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.verified_rounded, color: Color(0xFF4F46A5), size: 12),
                      SizedBox(width: 3),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4F46A5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Large Number & Label Hierarchy
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
          Row(
            children: const [
              Icon(Icons.groups_rounded, size: 15, color: Color(0xFF4F46A5)),
              SizedBox(width: 4),
              Text(
                'People Served',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
