import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'ecosystem_diagram.dart';

class RoleHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const RoleHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final activeRole = state.activeRole;
    final primaryColor = AppColors.getPrimaryForRole(activeRole);
    final unreadNotifs = state.notifications.where((n) => !n.isRead && (n.targetRole == AppColors.getRoleTitle(activeRole) || n.targetRole == 'NGO' && activeRole == UserRole.ngo)).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.8))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Role Badge & Selector
              GestureDetector(
                onTap: () => _showRoleSwitchModal(context, state),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Text(AppColors.getRoleEmoji(activeRole), style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        AppColors.getRoleTitle(activeRole),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.swap_horiz, size: 16, color: primaryColor),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Ecosystem Info button
              IconButton(
                icon: const Icon(Icons.info_outline, color: AppColors.textSecondary, size: 22),
                tooltip: 'Ecosystem Flow',
                onPressed: () => _showEcosystemModal(context),
              ),
              // Notifications Bell
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 24),
                    onPressed: () => _showNotificationsModal(context, state),
                  ),
                  if (unreadNotifs > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.critical,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$unreadNotifs',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
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
        ],
      ),
    );
  }

  void _showRoleSwitchModal(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Switch Demo Role Interface',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Test multi-role features live during presentation',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ...UserRole.values.map((role) {
                final isSelected = state.activeRole == role;
                final roleColor = AppColors.getPrimaryForRole(role);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      state.setRole(role);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected ? roleColor.withOpacity(0.1) : AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? roleColor : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(AppColors.getRoleEmoji(role), style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppColors.getRoleTitle(role),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: roleColor,
                                  ),
                                ),
                                Text(
                                  AppColors.getRoleSubtitle(role),
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check_circle, color: roleColor, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showEcosystemModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RescuEats Circular Ecosystem',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Expanded(
                child: SingleChildScrollView(
                  child: EcosystemDiagramWidget(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsModal(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Intelligent Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () {
                      for (var n in state.notifications) {
                        state.markNotificationRead(n.id);
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (state.notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('No notifications yet')),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final n = state.notifications[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: n.isRead ? AppColors.background : AppColors.ngoBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(n.message, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
