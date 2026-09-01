import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'deal_detail_screen.dart';

class VendorDealsTab extends StatefulWidget {
  const VendorDealsTab({super.key});

  @override
  State<VendorDealsTab> createState() => _VendorDealsTabState();
}

class _VendorDealsTabState extends State<VendorDealsTab> {
  String filterCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final offers = state.discountOffers;

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search tomatoes, milk, rice or Kirana store...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['ALL', 'HIGH DISCOUNT (30%+)', '< 3 KM', 'VEGETABLES', 'DAIRY'].map((cat) {
                    final isSel = filterCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSel,
                        onSelected: (v) => setState(() => filterCategory = cat),
                        selectedColor: AppColors.vendorPrimary,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.critical, borderRadius: BorderRadius.circular(6)),
                          child: Text('${offer.discountPercent}% OFF', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        const Spacer(),
                        Text('${offer.distanceKm} km away', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(offer.productName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text('Kirana Seller: ${offer.kiranaName}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Original MRP', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('₹${offer.originalPrice.toStringAsFixed(0)} / ${offer.unit}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vendor Wholesale Price', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.vendorPrimary)),
                            Text('₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.vendorPrimary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DealDetailScreen(offer: offer)));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.vendorPrimary),
                        child: const Text('PURCHASE DISCOUNTED BATCH'),
                      ),
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
