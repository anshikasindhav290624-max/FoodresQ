import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import '../../widgets/trust_score_badge.dart';
import '../welcome_screen.dart';
import 'ngo_trust_score_screen.dart';

class NgoProfileTab extends StatelessWidget {
  const NgoProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo & Profile Avatar Header Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cover Image
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: AppImage(
                        url: AppImage.ngoCommunity,
                        borderRadius: 0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Avatar Photo with Edit Overlay
                        Stack(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: AppImage(
                                  url: AppImage.ngoCommunity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.ngoPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
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
                    leading: const Icon(Icons.logout_rounded, color: AppColors.critical),
                    title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.critical)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodresQWelcomeScreen()),
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
      ),
    );
  }
}
