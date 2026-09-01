import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/transaction_detail_dialog.dart';

class NgoHistoryTab extends StatefulWidget {
  const NgoHistoryTab({super.key});

  @override
  State<NgoHistoryTab> createState() => _NgoHistoryTabState();
}

class _NgoHistoryTabState extends State<NgoHistoryTab> {
  String selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final txns = state.transactions;

    return Column(
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
                labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: txns.length,
            itemBuilder: (context, index) {
              final txn = txns[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TRANSACTION #${txn.id}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: AppColors.textSecondary)),
                        Text('${txn.status} ✓', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.success)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(txn.itemTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('${txn.participant1} ➔ ${txn.participant2}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(txn.impactSummary, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.ngoPrimary)),
                        OutlinedButton(
                          onPressed: () => TransactionDetailDialog.show(context, txn),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Details', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
