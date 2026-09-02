import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String emoji;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? color;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.emoji = '🍃',
    this.icon,
    this.buttonText,
    this.onButtonPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.ngoPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Illustration Badge Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: themeColor.withOpacity(0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 48, color: themeColor)
                    : Text(emoji, style: const TextStyle(fontSize: 44)),
              ),
            ),
            const SizedBox(height: 20),

            // Headline
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),

            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: Text(
                  buttonText!,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
