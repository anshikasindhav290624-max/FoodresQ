import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.ngoBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.ngoPrimary.withOpacity(0.3)),
              ),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.mealsCount} MEALS BATCH',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${item.distanceKm} km away',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text('Pickup Location: ${item.restaurantName}, ${item.location}', style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Timeline Steps
            const Text('Recovery Progress Timeline:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
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
            const SizedBox(height: 24),

            // Interactive Actions
            if (!isReceived) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isReceived = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Food marked as RECEIVED! Proceeding to distribution.')),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('MARK AS RECEIVED FROM RESTAURANT'),
                ),
              ),
            ] else if (!isDistributed) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.ngoPrimary),
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
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isDistributed = true;
                          });
                          final count = int.tryParse(_peopleServedCtrl.text) ?? 35;
                          state.completeFoodPickupAndDistribution(item, count);

                          _showSuccessDialog(context, state, count);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                        icon: const Icon(Icons.verified),
                        label: const Text('MARK AS DISTRIBUTED & COMPLETE'),
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
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.success),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.check_circle, color: AppColors.success, size: 48),
                    SizedBox(height: 10),
                    Text(
                      'FOOD RECOVERY COMPLETED ✓',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.success),
                    ),
                    SizedBox(height: 4),
                    Text('Trust Score updated! Impact stats recorded in public ledger.', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, AppState state, int count) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.stars, color: AppColors.warning, size: 28),
            SizedBox(width: 8),
            Text('Trust Score Updated!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⭐ Trust Score increased to ${state.trustScore.overallScore} (+4 points)!',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ngoPrimary),
            ),
            const SizedBox(height: 10),
            Text('• Served $count beneficiaries with 35 meals.'),
            const Text('• Prevented 14 kg food waste.'),
            const Text('• Updated transaction ledger.'),
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
