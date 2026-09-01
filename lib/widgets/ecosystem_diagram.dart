import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EcosystemDiagramWidget extends StatelessWidget {
  const EcosystemDiagramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFlowCard(
          title: 'FLOW A — SURPLUS FOOD RECOVERY',
          subtitle: 'Restaurant Surplus → NGO → People in Need',
          primaryColor: AppColors.ngoPrimary,
          bgGradient: const [Color(0xFFEEF8F3), Color(0xFFFFF8F1)],
          steps: [
            _FlowStep('RESTAURANT', 'Generates Surplus Food', Icons.restaurant, AppColors.restaurantPrimary),
            _FlowStep('SURPLUS POST', 'Uploads Batch Details', Icons.cloud_upload, AppColors.restaurantSecondary),
            _FlowStep('AI MATCHING', 'Ranks Capacity & Distance', Icons.auto_awesome, AppColors.aiAccent),
            _FlowStep('NGO CASCADE', '8-Min Acceptance Window', Icons.timer, AppColors.ngoPrimary),
            _FlowStep('DISTRIBUTION', 'Serves Beneficiaries', Icons.volunteer_activism, AppColors.success),
            _FlowStep('VERIFIED IMPACT', 'Trust Score & Stats Update', Icons.verified, AppColors.ngoPrimary),
          ],
        ),
        const SizedBox(height: 20),
        _buildFlowCard(
          title: 'FLOW B — NEAR-EXPIRY MARKETPLACE',
          subtitle: 'Kirana Store → Discount Offer → Vendor Buyer',
          primaryColor: AppColors.vendorPrimary,
          bgGradient: const [Color(0xFFF7F8ED), Color(0xFFF4F5FF)],
          steps: [
            _FlowStep('KIRANA STORE', 'At-Risk Inventory (1-3 Days Expiry)', Icons.store, AppColors.kiranaPrimary),
            _FlowStep('AI EXPIRY ALERT', 'Detects Loss & Recommends %', Icons.warning_amber, AppColors.warning),
            _FlowStep('DISCOUNT PUBLISH', 'Publishes Offer to Network', Icons.local_offer, AppColors.kiranaPrimary),
            _FlowStep('VENDOR MARKET', 'Discovers & Buys Deals', Icons.shopping_cart, AppColors.vendorPrimary),
            _FlowStep('VALUE RECOVERY', 'Kirana Recovers Loss, Vendor Saves', Icons.savings, AppColors.success),
            _FlowStep('SHARED LEDGER', 'Traceable Transaction History', Icons.receipt_long, AppColors.vendorPrimary),
          ],
        ),
      ],
    );
  }

  Widget _buildFlowCard({
    required String title,
    required String subtitle,
    required Color primaryColor,
    required List<Color> bgGradient,
    required List<_FlowStep> steps,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: primaryColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final idx = entry.key;
            final step = entry.value;
            final isLast = idx == steps.length - 1;

            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: step.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: step.color, width: 1.5),
                      ),
                      child: Icon(step.icon, size: 16, color: step.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: step.color,
                            ),
                          ),
                          Text(
                            step.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 17, top: 4, bottom: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 2,
                        height: 16,
                        color: primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _FlowStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _FlowStep(this.title, this.subtitle, this.icon, this.color);
}
