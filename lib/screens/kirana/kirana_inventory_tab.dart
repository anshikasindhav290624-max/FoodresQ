import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'create_discount_screen.dart';

class KiranaInventoryTab extends StatefulWidget {
  const KiranaInventoryTab({super.key});

  @override
  State<KiranaInventoryTab> createState() => _KiranaInventoryTabState();
}

class _KiranaInventoryTabState extends State<KiranaInventoryTab> {
  String selectedFilter = 'EXPIRING';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final offers = state.discountOffers;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['ALL', 'EXPIRING', 'LOW STOCK'].map((f) {
              final isSel = selectedFilter == f;
              return ChoiceChip(
                label: Text(f),
                selected: isSel,
                onSelected: (v) => setState(() => selectedFilter = f),
                selectedColor: AppColors.kiranaPrimary,
                labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.kiranaBg, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.storefront, color: AppColors.kiranaPrimary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('${offer.availableQuantity} ${offer.unit} • Expires soon', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Text('MRP: ₹${offer.originalPrice.toStringAsFixed(0)} ➔ Target: ₹${offer.discountedPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.kiranaPrimary)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateDiscountScreen()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.kiranaPrimary),
                      child: const Text('DISCOUNT'),
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
