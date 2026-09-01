import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class KiranaInsightsTab extends StatelessWidget {
  const KiranaInsightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Revenue Recovery & Waste Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              _buildCard('Revenue Recovered', '₹${state.kiranaRevenueRecovered.toStringAsFixed(0)}', Icons.monetization_on, AppColors.success),
              _buildCard('Waste Prevented', '86 kg', Icons.recycling, AppColors.kiranaPrimary),
              _buildCard('Near-Expiry Sales', '₹6,400', Icons.sell, AppColors.warning),
              _buildCard('Inventory Loss ↓', '23%', Icons.trending_down, AppColors.info),
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
                const Text('Monthly Value Recovery (₹)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar('May', 0.45),
                    _buildBar('Jun', 0.65),
                    _buildBar('Jul', 0.8),
                    _buildBar('Aug', 0.9),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String label, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(val, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBar(String month, double val) {
    return Column(
      children: [
        Container(height: 100 * val, width: 22, decoration: BoxDecoration(color: AppColors.kiranaPrimary, borderRadius: BorderRadius.circular(6))),
        const SizedBox(height: 6),
        Text(month, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
