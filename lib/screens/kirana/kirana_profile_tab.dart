import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../welcome_role_screen.dart';

class KiranaProfileTab extends StatelessWidget {
  const KiranaProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: AppColors.kiranaBg, shape: BoxShape.circle),
                  child: const Text('🏪', style: TextStyle(fontSize: 32)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Sharma General Store', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Owner: Ramesh Sharma', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Indiranagar, Bengaluru', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.swap_horiz, color: AppColors.kiranaPrimary),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
