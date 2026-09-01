import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class NgoImpactTab extends StatelessWidget {
  const NgoImpactTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ecosystem Impact Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text('Cumulative social and environmental impact generated:', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // 4 Grid Metric Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildImpactCard('Meals Saved', '${state.totalMealsSaved}', Icons.restaurant, AppColors.ngoPrimary),
              _buildImpactCard('People Served', '${state.peopleServed}', Icons.people, AppColors.success),
              _buildImpactCard('Food Diverted', '${state.foodDivertedKg.toStringAsFixed(0)} kg', Icons.recycling, AppColors.warning),
              _buildImpactCard('Pickups Done', '${state.successfulPickups}', Icons.local_shipping, AppColors.aiAccent),
            ],
          ),
          const SizedBox(height: 20),

          // Weekly Trend Bar Chart
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Weekly Meals Rescued Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    Text('+14% vs last week', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('Mon', 0.5),
                    _buildBar('Tue', 0.7),
                    _buildBar('Wed', 0.4),
                    _buildBar('Thu', 0.85),
                    _buildBar('Fri', 0.6),
                    _buildBar('Sat', 0.95),
                    _buildBar('Sun', 0.75),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, double heightFactor) {
    return Column(
      children: [
        Container(
          height: 100 * heightFactor,
          width: 18,
          decoration: BoxDecoration(
            color: AppColors.ngoPrimary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
