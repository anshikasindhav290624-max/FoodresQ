import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';

class NgoPickupTrackingScreen extends StatefulWidget {
  final SurplusItem item;

  const NgoPickupTrackingScreen({super.key, required this.item});

  @override
  State<NgoPickupTrackingScreen> createState() => _NgoPickupTrackingScreenState();
}

class _NgoPickupTrackingScreenState extends State<NgoPickupTrackingScreen> {
  bool isReceived = false;
  bool isDistributed = false;
  final _peopleServedCtrl = TextEditingController(text: '35');

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final item = widget.item;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Food Pickup & Distribution'),
        backgroundColor: Colors.white,
      ),
      body: SubtleBackgroundAnimation(
        role: UserRole.ngo,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Thumbnail & Restaurant Banner Header
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.ngoPrimary.withOpacity(0.12),
                      blurRadius: 12,
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
                          url: AppImage.foodThali,
                          borderRadius: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.75),
                                Colors.transparent,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.ngoPrimary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${item.mealsCount} MEALS BATCH',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                                  ),
                                ),
                                Text(
                                  '📍 ${item.distanceKm} km away',
                                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                            Text('Pickup: ${item.restaurantName}, ${item.location}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Recovery Progress Timeline
              const Text('Recovery Progress Timeline:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTimelineStep('Food Opportunity Posted', 'Urban Tadka posted 35 Meals', true),
                    _buildTimelineStep('NGO Accepted', 'Accepted within 8-min cascade window', true),
                    _buildTimelineStep('Pickup at Restaurant', 'Collect food before deadline (10:30 PM)', isReceived),
                    _buildTimelineStep('Beneficiary Distribution', 'Distribute food & report verified impact', isDistributed),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive Actions
              if (!isReceived) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isReceived = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Food marked as RECEIVED! Proceeding to distribution.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ngoPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text('MARK AS RECEIVED FROM RESTAURANT', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ] else if (!isDistributed) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.ngoPrimary, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Record Food Distribution:', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _peopleServedCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Number of People Served',
                          hintText: 'Enter beneficiary count',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isDistributed = true;
                            });
                            final count = int.tryParse(_peopleServedCtrl.text) ?? 35;
                            state.completeFoodPickupAndDistribution(item, count);

                            _showSuccessDialog(context, state, count, item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.verified),
                          label: const Text('MARK AS DISTRIBUTED & COMPLETE', style: TextStyle(fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.success, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 54),
                      const SizedBox(height: 10),
                      const Text(
                        'FOOD RESCUE COMPLETED ✓',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.success),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('✓ ${item.mealsCount} Meals Rescued', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          Text('✓ ${_peopleServedCtrl.text} Served', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          Text('✓ ${item.restaurantName}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, AppState state, int count, SurplusItem item) {
    final double kgRescued = (item.mealsCount * 0.4);
    final int pointsEarned = (kgRescued * 10).round().clamp(50, 5000);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.stars, color: AppColors.warning, size: 28),
            SizedBox(width: 8),
            Text('Food Rescue Completed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.mealsCount} meals rescued from ${item.restaurantName}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${kgRescued.toStringAsFixed(0)} kg food diverted from waste',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, color: AppColors.warning, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⭐ +$pointsEarned FoodResQ Reward Points awarded to ${item.restaurantName}!',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFB45309)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '⭐ NGO Trust Score increased to ${state.trustScore.overallScore} (+4 points)!',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ngoPrimary),
            ),
            const SizedBox(height: 8),
            Text('• Served $count beneficiaries with 35 meals.'),
            Text('• Prevented ${kgRescued.toStringAsFixed(0)} kg food waste.'),
            const Text('• Circular transaction ledger updated.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('BACK TO DASHBOARD'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String desc, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? AppColors.success : Colors.grey,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
