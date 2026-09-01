import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/transaction_detail_dialog.dart';

class RestaurantHistoryTab extends StatelessWidget {
  const RestaurantHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final txns = state.transactions;

    return ListView.builder(
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
                  Text('#${txn.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textSecondary)),
                  Text(txn.status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.success)),
                ],
              ),
              const SizedBox(height: 6),
              Text(txn.itemTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(txn.impactSummary, style: const TextStyle(fontSize: 12, color: AppColors.restaurantPrimary)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: () => TransactionDetailDialog.show(context, txn),
                  child: const Text('View Receipt'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
