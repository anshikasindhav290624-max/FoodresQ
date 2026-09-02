import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/subtle_background_animation.dart';
import 'welcome_role_screen.dart';

class FoodresQWelcomeScreen extends StatelessWidget {
  const FoodresQWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SubtleBackgroundAnimation(
        role: UserRole.ngo,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Header Brand Pill
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.ngoPrimary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.eco_rounded,
                              color: AppColors.ngoPrimary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'FoodresQ',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Main Headline
                      const Text(
                        'FoodresQ',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          height: 1.1,
                          letterSpacing: -0.8,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Tagline
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.ngoPrimary, Color(0xFF4F46A5)],
                        ).createShader(bounds),
                        child: const Text(
                          'Rescue Food. Recover Value. Reduce Waste.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.25,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Supporting line
                      const Text(
                        'Connecting restaurants, NGOs, vendors and local stores to reduce food waste and recover value.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Food Rescue Hero Illustration & Ecosystem Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.ngoBg,
                              Colors.white,
                              AppColors.vendorBg.withOpacity(0.5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.ngoPrimary.withOpacity(0.2), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ngoPrimary.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
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
                                    color: AppColors.ngoPrimary.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.recycling_rounded, color: AppColors.ngoPrimary, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'CIRCULAR FOOD RECOVERY NETWORK',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ngoPrimary,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Portion above Get Started: Visual cards for the 4 interfaces
                            const Text(
                              '4 Connected Ecosystem Interfaces',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.35,
                              children: [
                                _buildRoleInterfaceCard(
                                  title: 'Restaurant',
                                  subtitle: 'Post Surplus',
                                  emoji: '🍽️',
                                  imageUrl: AppImage.restaurantKitchen,
                                  color: AppColors.restaurantPrimary,
                                ),
                                _buildRoleInterfaceCard(
                                  title: 'NGO',
                                  subtitle: 'Distribute Meals',
                                  emoji: '🤝',
                                  imageUrl: AppImage.ngoCommunity,
                                  color: AppColors.ngoPrimary,
                                ),
                                _buildRoleInterfaceCard(
                                  title: 'Vendor',
                                  subtitle: 'Buy Discounts',
                                  emoji: '📦',
                                  imageUrl: AppImage.vendorWholesale,
                                  color: AppColors.vendorPrimary,
                                ),
                                _buildRoleInterfaceCard(
                                  title: 'Kirana',
                                  subtitle: 'Recover Value',
                                  emoji: '🏪',
                                  imageUrl: AppImage.kiranaStore,
                                  color: AppColors.kiranaPrimary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom CTA Button Container
              Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, anim, secAnim) => const WelcomeRoleScreen(),
                          transitionsBuilder: (context, anim, secAnim, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 350),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ngoPrimary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.ngoPrimary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleInterfaceCard({
    required String title,
    required String subtitle,
    required String emoji,
    required String imageUrl,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Image background
            Positioned.fill(
              child: AppImage(
                url: imageUrl,
                borderRadius: 16,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.black.withOpacity(0.25),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Text & Emoji Content
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    overflow: TextOverflow.ellipsis,
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
