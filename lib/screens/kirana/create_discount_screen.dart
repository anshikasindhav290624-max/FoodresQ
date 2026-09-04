import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class CreateDiscountScreen extends StatefulWidget {
  const CreateDiscountScreen({super.key});

  @override
  State<CreateDiscountScreen> createState() => _CreateDiscountScreenState();
}

class _CreateDiscountScreenState extends State<CreateDiscountScreen> {
  final _productCtrl = TextEditingController(text: '🥛 Full Cream Milk Packs (500ml)');
  final _mrpCtrl = TextEditingController(text: '30');
  final _discountedPriceCtrl = TextEditingController(text: '21');
  final _qtyCtrl = TextEditingController(text: '12');
  String _unit = 'packs';
  int _discountPercent = 30;
  String _category = 'Dairy';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    final mrp = double.tryParse(_mrpCtrl.text) ?? 30.0;
    final discountPrice = double.tryParse(_discountedPriceCtrl.text) ?? 21.0;
    final qty = int.tryParse(_qtyCtrl.text) ?? 12;
    final totalRecovered = discountPrice * qty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Near-Expiry Discount Offer'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Recommendation Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.aiAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.aiAccent.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('🤖 AI EXPIRY RECOMMENDATION', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.aiAccent, fontSize: 11)),
                        SizedBox(height: 2),
                        Text('Recommending 30% Discount for fast disposal to local Vendor buyers.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visual Price Transformation Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.kiranaPrimary.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kiranaPrimary.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text('Original MRP', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          const SizedBox(height: 2),
                          Text('₹${mrp.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: AppColors.kiranaPrimary, size: 24),
                      Column(
                        children: [
                          const Text('30% Discount Price', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.kiranaPrimary)),
                          const SizedBox(height: 2),
                          Text('₹${discountPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.kiranaPrimary)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.kiranaBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '💰 ESTIMATED REVENUE RECOVERY: ₹${totalRecovered.toStringAsFixed(0)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.kiranaPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _productCtrl,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mrpCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Original MRP (₹)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _discountedPriceCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Discounted Price (₹)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _qtyCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Available Stock Quantity'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _unit,
                    decoration: const InputDecoration(labelText: 'Unit'),
                    items: ['packs', 'kg', 'bags', 'boxes'].map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _unit = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final title = _productCtrl.text;
                  final origMrp = double.tryParse(_mrpCtrl.text) ?? 30.0;
                  final dPrice = double.tryParse(_discountedPriceCtrl.text) ?? 21.0;
                  final quantity = int.tryParse(_qtyCtrl.text) ?? 12;

                  state.createDiscountOffer(
                    productName: title,
                    originalPrice: origMrp,
                    discountedPrice: dPrice,
                    discountPercent: _discountPercent,
                    quantity: quantity,
                    unit: _unit,
                    category: _category,
                  );

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: const [
                          Icon(Icons.check_circle, color: AppColors.kiranaPrimary, size: 28),
                          SizedBox(width: 8),
                          Text('Offer Published Live!'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Published $title ($quantity $_unit)', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('• Visible on Vendor Buyer Marketplace.'),
                          const Text('• Nearby buyers notified immediately.'),
                          const Text('• At-risk loss converted to recovered revenue.'),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.kiranaPrimary),
                          child: const Text('BACK TO INVENTORY'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kiranaPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.publish),
                label: const Text('PUBLISH OFFER TO VENDOR MARKETPLACE', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
