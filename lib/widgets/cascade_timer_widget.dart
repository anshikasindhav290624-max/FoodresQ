import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class CascadeTimerWidget extends StatelessWidget {
  final SurplusItem item;
  final int timerSeconds;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const CascadeTimerWidget({
    super.key,
    required this.item,
    required this.timerSeconds,
    required this.onAccept,
    required this.onDecline,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    final minsStr = mins.toString().padLeft(2, '0');
    final secsStr = secs.toString().padLeft(2, '0');
    return '$minsStr:$secsStr';
  }

  @override
  Widget build(BuildContext context) {
    final isWarning = timerSeconds < 120; // under 2 minutes
    final timerColor = isWarning ? AppColors.critical : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: timerColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: timerColor.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.critical.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.timer, color: AppColors.critical, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '8-MINUTE CASCADE ACTIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.critical,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Opportunity #${item.id}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.store, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${item.restaurantName} • ${item.distanceKm} km away',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: timerColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: timerColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACCEPTANCE WINDOW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: timerColor,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTime(timerSeconds),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: timerColor,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.ngoPrimary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.mealsCount} MEALS',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Free / Donated',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: const Text('DECLINE'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ngoPrimary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('ACCEPT FOOD'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
