import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';
import '../../widgets/transaction_detail_dialog.dart';

class KiranaHistoryTab extends StatelessWidget {
  const KiranaHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final txns = state.transactions;

    return SubtleBackgroundAnimation(
      role: UserRole.kirana,
      child: txns.isEmpty
          ? const EmptyStateWidget(
              title: 'No Recovery History',
              description: 'Completed inventory discount sales will be recorded here.',
              emoji: '🏪',
              color: AppColors.kiranaPrimary,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: txns.length,
              itemBuilder: (context, index) {
                final txn = txns[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AppImage(
                        url: AppImage.groceryMilk,
                        width: 60,
                        height: 60,
                        borderRadius: 12,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('#${txn.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textSecondary)),
                                Text(txn.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.success)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(txn.itemTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(txn.impactSummary, style: const TextStyle(fontSize: 11, color: AppColors.kiranaPrimary, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                onPressed: () => TransactionDetailDialog.show(context, txn),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('View Sale Receipt', style: TextStyle(fontSize: 11)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
