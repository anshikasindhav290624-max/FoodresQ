import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'add_surplus_screen.dart';

class RestaurantHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const RestaurantHomeTab({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. KPI CARDS GRID
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildKpi('Today\'s Revenue', '₹${state.restaurantRevenueToday.toStringAsFixed(0)}', Icons.payments, AppColors.restaurantPrimary),
              _buildKpi('Orders Served', '86', Icons.receipt_long, AppColors.info),
              _buildKpi('Food Waste', '${state.restaurantWasteKgToday.toStringAsFixed(0)} kg', Icons.delete_outline, AppColors.warning),
              _buildKpi('Meals Saved', '${state.restaurantSavedMealsToday}', Icons.favorite, AppColors.success),
            ],
          ),
          const SizedBox(height: 20),

          // 2. PRIMARY CTA — ADD SURPLUS
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSurplusScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.restaurantPrimary,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.add_circle_outline, size: 24),
              label: const Text(
                '+ ADD SURPLUS FOOD BATCH',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.8),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. 🤖 AI WASTE FORECAST CARD
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.aiAccent.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.aiAccent.withOpacity(0.08),
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
                        color: AppColors.aiAccent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '🤖 AI WASTE FORECAST & PREDICTION',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.aiAccent, letterSpacing: 1.0),
                          ),
                          Text(
                            'Tomorrow\'s Predicted Surplus: 16 kg',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
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
                    color: AppColors.restaurantBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildForecastRow('Prepared Rice Batch', '8 kg at risk'),
                      const SizedBox(height: 4),
                      _buildForecastRow('Curry & Gravy', '5 kg at risk'),
                      const SizedBox(height: 4),
                      _buildForecastRow('Salad & Breads', '3 kg at risk'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.warning, size: 18),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'AI Recommendation: Reduce Friday rice preparation by 12% based on historical demand patterns.',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('AI Inventory Plan applied! Prep target adjusted -12%.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.restaurantPrimary,
                      side: const BorderSide(color: AppColors.restaurantPrimary),
                    ),
                    child: const Text('PLAN INVENTORY NOW'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpi(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildForecastRow(String item, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        Text(val, style: const TextStyle(color: AppColors.critical, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
