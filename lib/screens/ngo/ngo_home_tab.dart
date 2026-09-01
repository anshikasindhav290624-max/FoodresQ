import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trust_score_badge.dart';
import '../../widgets/cascade_timer_widget.dart';
import '../../widgets/smart_match_card.dart';
import 'ngo_trust_score_screen.dart';
import 'ngo_pickup_tracking_screen.dart';

class NgoHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const NgoHomeTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final isAccepting = state.ngoAcceptingFood;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  color: (isAccepting ? AppColors.ngoPrimary : Colors.grey).withOpacity(0.08),
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
                    Row(
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
                        Text(
                          isAccepting ? 'ACCEPTING SURPLUS FOOD' : 'NOT ACCEPTING FOOD',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: isAccepting ? AppColors.success : AppColors.critical,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
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

          // 2. TRUST SCORE BADGE
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

          // 3. 8-MINUTE CASCADE OPPORTUNITY TIMER
          if (state.isCascadeActive && state.activeCascadeItem != null) ...[
            CascadeTimerWidget(
              item: state.activeCascadeItem!,
              timerSeconds: state.cascadeTimerSeconds,
              onAccept: () {
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
                    builder: (context) => NgoPickupTrackingScreen(item: state.activeCascadeItem!),
                  ),
                );
              },
              onDecline: () {
                state.declineCascadeOpportunity();
              },
            ),
            const SizedBox(height: 16),
          ],

          // 4. SMART MATCHING RECOMMENDATION BREAKDOWN
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

          // 5. QUICK NEARBY FOOD SURPLUS FEED
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
          ...state.surplusItems.take(2).map((item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.ngoBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fastfood, color: AppColors.ngoPrimary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('${item.restaurantName} • ${item.distanceKm} km away', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.ngoPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.mealsCount} Meals • Pickup before 10:30 PM',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.ngoPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
