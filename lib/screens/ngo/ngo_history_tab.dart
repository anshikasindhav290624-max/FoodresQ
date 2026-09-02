import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';
import '../../widgets/transaction_detail_dialog.dart';

class NgoHistoryTab extends StatefulWidget {
  const NgoHistoryTab({super.key});

  @override
  State<NgoHistoryTab> createState() => _NgoHistoryTabState();
}

class _NgoHistoryTabState extends State<NgoHistoryTab> {
  String selectedFilter = 'ALL';

  Color _getStatusColor(String status) {
    final s = status.toUpperCase();
    if (s == 'COMPLETED') return AppColors.success;
    if (s == 'EXPIRED') return AppColors.warning;
    if (s == 'CANCELLED') return AppColors.critical;
    return AppColors.ngoPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final allNgoTxns = state.transactions.where((t) => t.roleType == 'NGO').toList();

    List<TransactionRecord> filteredTxns;
    if (selectedFilter == 'COMPLETED') {
      filteredTxns = allNgoTxns.where((t) => t.status.toUpperCase() == 'COMPLETED').toList();
    } else if (selectedFilter == 'EXPIRED') {
      filteredTxns = allNgoTxns.where((t) => t.status.toUpperCase() == 'EXPIRED').toList();
    } else if (selectedFilter == 'CANCELLED') {
      filteredTxns = allNgoTxns.where((t) => t.status.toUpperCase() == 'CANCELLED').toList();
    } else {
      filteredTxns = allNgoTxns;
    }

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: Column(
        children: [
          // Filter tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['ALL', 'COMPLETED', 'EXPIRED', 'CANCELLED'].map((filter) {
                final isSel = selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSel,
                  onSelected: (v) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  selectedColor: AppColors.ngoPrimary,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredTxns.isEmpty
                ? EmptyStateWidget(
                    title: 'No $selectedFilter transactions found',
                    description: selectedFilter == 'ALL'
                        ? 'Your food recovery transactions will be recorded here.'
                        : 'No transactions match the $selectedFilter filter status.',
                    emoji: '📜',
                    color: AppColors.ngoPrimary,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTxns.length,
                    itemBuilder: (context, index) {
                      final txn = filteredTxns[index];
                      final statusColor = _getStatusColor(txn.status);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            AppImage(
                              url: AppImage.foodThali,
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
                                      Text('TXN #${txn.id}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.textSecondary)),
                                      Text(
                                        '${txn.status}${txn.status.toUpperCase() == "COMPLETED" ? " ✓" : ""}',
                                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: statusColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(txn.itemTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 2),
                                  Text('${txn.participant1} ➔ ${txn.participant2}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          txn.impactSummary,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.ngoPrimary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      OutlinedButton(
                                        onPressed: () => TransactionDetailDialog.show(context, txn),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text('Details', style: TextStyle(fontSize: 11)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
