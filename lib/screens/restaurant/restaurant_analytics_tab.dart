import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RestaurantAnalyticsTab extends StatelessWidget {
  const RestaurantAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Food Waste & Cost Reduction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildMetric('Waste Reduction', '32%', Icons.trending_down, AppColors.success),
              _buildMetric('Cost Saved', '₹18,400', Icons.savings, AppColors.restaurantPrimary),
              _buildMetric('Meals Recovered', '1,820', Icons.restaurant, AppColors.info),
              _buildMetric('Diverted Mass', '450 kg', Icons.recycling, AppColors.aiAccent),
            ],
          ),
          const SizedBox(height: 20),
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
                const Text('Monthly Waste Reduction Trend', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartCol('Week 1', 0.9, Colors.red.shade300),
                    _buildChartCol('Week 2', 0.7, Colors.amber.shade400),
                    _buildChartCol('Week 3', 0.5, AppColors.restaurantPrimary),
                    _buildChartCol('Week 4', 0.35, AppColors.success),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildChartCol(String label, double val, Color color) {
    return Column(
      children: [
        Container(
          height: 100 * val,
          width: 24,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
