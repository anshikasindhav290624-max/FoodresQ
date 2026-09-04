import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/foodresq_logo.dart';
import '../widgets/subtle_background_animation.dart';
import 'role_auth_screen.dart';

class WelcomeRoleScreen extends StatelessWidget {
  const WelcomeRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SubtleBackgroundAnimation(
        role: UserRole.ngo,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header brand pill with Back Button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    const FoodResQLogo(size: 32, fontSize: 20),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  'How will you use FoodresQ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'Choose your role to continue.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // 4 Role Cards with Rich Imagery
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildRoleCard(
                        context: context,
                        role: UserRole.restaurant,
                        emoji: '🍽️',
                        title: 'RESTAURANT',
                        subtitle: 'Post surplus food and recover value',
                        imageUrl: AppImage.restaurantKitchen,
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        context: context,
                        role: UserRole.ngo,
                        emoji: '🤝',
                        title: 'NGO',
                        subtitle: 'Receive and distribute surplus food',
                        imageUrl: AppImage.ngoCommunity,
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        context: context,
                        role: UserRole.vendor,
                        emoji: '📦',
                        title: 'VENDOR',
                        subtitle: 'Find discounted food and grocery deals',
                        imageUrl: AppImage.vendorWholesale,
                      ),
                      const SizedBox(height: 16),
                      _buildRoleCard(
                        context: context,
                        role: UserRole.kirana,
                        emoji: '🏪',
                        title: 'KIRANA',
                        subtitle: 'Recover value from near-expiry inventory',
                        imageUrl: AppImage.kiranaStore,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required UserRole role,
    required String emoji,
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    final roleColor = AppColors.getPrimaryForRole(role);
    final bgColor = AppColors.getBgForRole(role);

    return InkWell(
      onTap: () {
        final state = Provider.of<AppState>(context, listen: false);
        state.setRole(role);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoleAuthScreen(role: role),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: roleColor.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: roleColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image Thumbnail Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: roleColor.withOpacity(0.3), width: 1),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AppImage(
                      url: imageUrl,
                      borderRadius: 16,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: roleColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: roleColor, size: 18),
          ],
        ),
      ),
    );
  }
}
