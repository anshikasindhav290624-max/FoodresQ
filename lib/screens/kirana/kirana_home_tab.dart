import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'create_discount_screen.dart';

class KiranaHomeTab extends StatelessWidget {
  final Function(int) onNavigateTab;

  const KiranaHomeTab({super.key, required this.onNavigateTab});

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
              _buildKpi('Today\'s Sales', '₹8,450', Icons.point_of_sale, AppColors.kiranaPrimary),
              _buildKpi('Orders', '24', Icons.receipt, AppColors.info),
              _buildKpi('Expiring Stock', '${state.kiranaExpiringProducts}', Icons.timer, AppColors.warning),
              _buildKpi('Potential Loss', '₹${state.kiranaPotentialLoss.toStringAsFixed(0)}', Icons.warning_amber, AppColors.critical),
            ],
          ),
          const SizedBox(height: 20),

          // 2. ⚠ EXPIRING SOON WARNING ALERT
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.warning, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warning.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 24),
                    SizedBox(width: 8),
                    Text(
                      '⚠ EXPIRING SOON ALERT',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.warning, letterSpacing: 1.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.kiranaExpiringProducts} products expire within 3 days.',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  'At-risk inventory value: ₹${state.kiranaPotentialLoss.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onNavigateTab(1),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.kiranaPrimary),
                    child: const Text('MANAGE EXPIRING INVENTORY NOW'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. 🤖 AI EXPIRY DETECTION & DISCOUNT RECOMMENDATION
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.aiAccent.withOpacity(0.4), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.aiAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('🤖 AI HIGH RISK EXPIRY DETECTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.aiAccent, letterSpacing: 1.0)),
                          Text('12 Full Cream Milk Packs Expire Tomorrow', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Potential Loss: ₹360 if left unsold.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                const Text('AI Action Recommendation: Publish 30% Discount Offer (₹21/pack) to local Vendor buyers.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.kiranaPrimary)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDiscountScreen()));
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.kiranaPrimary, side: const BorderSide(color: AppColors.kiranaPrimary)),
                    child: const Text('CREATE DISCOUNT OFFER WITH AI'),
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
}
