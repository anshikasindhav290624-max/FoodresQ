import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';
import 'deal_detail_screen.dart';

class VendorDealsTab extends StatefulWidget {
  const VendorDealsTab({super.key});

  @override
  State<VendorDealsTab> createState() => _VendorDealsTabState();
}

class _VendorDealsTabState extends State<VendorDealsTab> {
  String filterCategory = 'ALL';

  String _getGroceryImageUrl(int index) {
    switch (index % 3) {
      case 0:
        return AppImage.groceryTomatoes;
      case 1:
        return AppImage.groceryMilk;
      case 2:
        return AppImage.groceryRice;
      default:
        return AppImage.groceryVeggies;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    var offers = state.discountOffers;

    if (filterCategory == '< 3 KM') {
      offers = offers.where((o) => o.distanceKm <= 3.0).toList();
    } else if (filterCategory == 'VEGETABLES') {
      offers = offers.where((o) => o.category == 'Vegetables').toList();
    } else if (filterCategory == 'DAIRY') {
      offers = offers.where((o) => o.category == 'Dairy').toList();
    }

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
      child: Column(
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
            child: offers.isEmpty
                ? const EmptyStateWidget(
                    title: 'No Grocery Deals Available',
                    description: 'No near-expiry discounted grocery offers match your selected filter.',
                    emoji: '🛒',
                    color: AppColors.vendorPrimary,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      final offer = offers[index];
                      final imageUrl = _getGroceryImageUrl(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
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
                            // Product Image Banner with Discount Badges
                            SizedBox(
                              height: 130,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: AppImage(
                                      url: imageUrl,
                                      borderRadius: 0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.65),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.critical,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '🔥 ${offer.discountPercent}% OFF',
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '📍 ${offer.distanceKm} km away',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 12,
                                    right: 12,
                                    child: Text(
                                      offer.productName,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Details & Price Section
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Kirana Seller: ${offer.kiranaName}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
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
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          const Text('Vendor Wholesale Price', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.vendorPrimary)),
                                          Text('₹${offer.discountedPrice.toStringAsFixed(0)} / ${offer.unit}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.vendorPrimary)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DealDetailScreen(offer: offer)));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.vendorPrimary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                                      label: const Text('PURCHASE DISCOUNTED BATCH', style: TextStyle(fontWeight: FontWeight.w800)),
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
          ),
        ],
      ),
    );
  }
}
