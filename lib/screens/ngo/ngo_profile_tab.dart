import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/trust_score_badge.dart';
import '../welcome_role_screen.dart';
import 'ngo_trust_score_screen.dart';

class NgoProfileTab extends StatelessWidget {
  const NgoProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: AppColors.ngoBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('❤️', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('Helping Hands', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                          SizedBox(width: 4),
                          Icon(Icons.verified, color: AppColors.ngoPrimary, size: 18),
                        ],
                      ),
                      const Text('Reg: NGO-KAR-2024-8849', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const Text('Koramangala, Bengaluru', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Trust Score Card
          TrustScoreBadge(
            trustScore: state.trustScore,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NgoTrustScoreScreen()));
            },
          ),
          const SizedBox(height: 20),

          // Settings List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: AppColors.ngoPrimary),
                  title: const Text('Switch Demo Role Interface', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeRoleScreen()),
                      (route) => false,
                    );
                  },
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                  title: Text('Notification Preferences'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.help_outline, color: AppColors.textPrimary),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
