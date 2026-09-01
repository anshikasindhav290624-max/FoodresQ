import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class DealDetailScreen extends StatelessWidget {
  final DiscountOffer offer;

  const DealDetailScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    final totalPaid = offer.discountedPrice * offer.availableQuantity;
    final totalOriginal = offer.originalPrice * offer.availableQuantity;
    final totalSaved = totalOriginal - totalPaid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Near-Expiry Deal Details'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image / Badge Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.vendorBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.vendorPrimary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.critical,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${offer.discountPercent}% OFF',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${offer.distanceKm} km away',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    offer.productName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seller: ${offer.kiranaName} (Verified Kirana)',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Price & Savings Breakdown Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Original Unit Price', style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        '₹${offer.originalPrice.toStringAsFixed(0)} / ${offer.unit}',
                        style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Vendor Wholesale Price', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.vendorPrimary),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Batch Quantity', style: TextStyle(color: AppColors.textSecondary)),
                      Text('${offer.availableQuantity} ${offer.unit}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Purchase Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('₹${totalPaid.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🎉 YOU SAVE ₹${totalSaved.toStringAsFixed(0)} ON THIS BATCH!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.success),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // AI Insight Alert
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.aiAccent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.aiAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI Insight: ${offer.aiReason}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Purchase Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  state.purchaseDiscountOffer(offer);

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: const [
                          Icon(Icons.check_circle, color: AppColors.success, size: 28),
                          SizedBox(width: 8),
                          Text('Order Placed Successfully!'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Purchased ${offer.availableQuantity} ${offer.unit} ${offer.productName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('• Total Paid: ₹${totalPaid.toStringAsFixed(0)}'),
                          Text('• Money Saved: ₹${totalSaved.toStringAsFixed(0)}'),
                          const Text('• Recovered value for Kirana store.'),
                          const Text('• Updated transaction ledger.'),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.vendorPrimary),
                          child: const Text('BACK TO MARKETPLACE'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.vendorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.shopping_cart),
                label: const Text('PURCHASE BATCH NOW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
