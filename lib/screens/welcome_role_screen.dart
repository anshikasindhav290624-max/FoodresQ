import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'auth_screen.dart';

class WelcomeRoleScreen extends StatelessWidget {
  const WelcomeRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.ngoPrimary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.recycling, color: AppColors.ngoPrimary, size: 24),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'RescuEats',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Who are you?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose your role to continue into the circular recovery platform.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildRoleCard(
                      context: context,
                      role: UserRole.ngo,
                      badge: 'FLOW A — FOOD RECOVERY',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context: context,
                      role: UserRole.restaurant,
                      badge: 'FLOW A — SURPLUS SUPPLIER',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context: context,
                      role: UserRole.vendor,
                      badge: 'FLOW B — DISCOUNT BUYER',
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      context: context,
                      role: UserRole.kirana,
                      badge: 'FLOW B — INVENTORY SELLER',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required UserRole role,
    required String badge,
  }) {
    final roleColor = AppColors.getPrimaryForRole(role);
    final bgColor = AppColors.getBgForRole(role);
    final emoji = AppColors.getRoleEmoji(role);
    final title = AppColors.getRoleTitle(role);
    final subtitle = AppColors.getRoleSubtitle(role);

    return InkWell(
      onTap: () {
        final state = Provider.of<AppState>(context, listen: false);
        state.setRole(role);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen(role: role)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: roleColor.withOpacity(0.12),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: roleColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: roleColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: roleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: roleColor, size: 18),
          ],
        ),
      ),
    );
  }
}
