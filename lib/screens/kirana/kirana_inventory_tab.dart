import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';
import 'create_discount_screen.dart';

class KiranaInventoryTab extends StatefulWidget {
  const KiranaInventoryTab({super.key});

  @override
  State<KiranaInventoryTab> createState() => _KiranaInventoryTabState();
}

class _KiranaInventoryTabState extends State<KiranaInventoryTab> {
  String selectedFilter = 'ALL'; // Default selected filter is ALL

  String _getGroceryImageUrl(DiscountOffer offer) {
    final name = offer.productName.toLowerCase();
    if (name.contains('tomato')) return AppImage.groceryTomatoes;
    if (name.contains('milk')) return AppImage.groceryMilk;
    if (name.contains('rice')) return AppImage.groceryRice;
    if (name.contains('bread') || name.contains('bakery')) return AppImage.foodBakery;
    return AppImage.groceryVeggies;
  }

  List<DiscountOffer> _getFilteredOffers(List<DiscountOffer> allOffers) {
    if (selectedFilter == 'EXPIRING') {
      return allOffers.where((o) => o.isExpiring).toList();
    } else if (selectedFilter == 'LOW STOCK') {
      return allOffers.where((o) => o.isLowStock).toList();
    }
    return allOffers;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final allOffers = state.discountOffers;

    final allCount = allOffers.length;
    final expiringCount = allOffers.where((o) => o.isExpiring).length;
    final lowStockCount = allOffers.where((o) => o.isLowStock).length;

    final filteredOffers = _getFilteredOffers(allOffers);

    return SubtleBackgroundAnimation(
      role: UserRole.kirana,
      child: Column(
        children: [
          // 1. FILTER TABS BAR (Active state design with checkmark + counts)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterChip('ALL', 'ALL', allCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('EXPIRING', 'EXPIRING', expiringCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('LOW STOCK', 'LOW STOCK', lowStockCount),
                  ],
                ),
                const SizedBox(height: 10),
                // Dynamic Result Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getFilterHeaderText(filteredOffers.length),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (selectedFilter != 'ALL')
                      GestureDetector(
                        onTap: () => setState(() => selectedFilter = 'ALL'),
                        child: const Text(
                          'Show All',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.kiranaPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // 2. PRODUCT LIST OR EMPTY STATE
          Expanded(
            child: filteredOffers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = filteredOffers[index];
                      final imageUrl = _getGroceryImageUrl(offer);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppImage(
                              url: imageUrl,
                              width: 72,
                              height: 72,
                              borderRadius: 14,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Title & Badges
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          offer.productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Status Badges (EXPIRING / LOW STOCK)
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      if (offer.isExpiring)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.critical.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.critical.withValues(alpha: 0.3)),
                                          ),
                                          child: const Text(
                                            '🔥 HIGH RISK',
                                            style: TextStyle(
                                              color: AppColors.critical,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                      if (offer.isLowStock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.warning.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                                          ),
                                          child: const Text(
                                            '⚠️ LOW STOCK',
                                            style: TextStyle(
                                              color: AppColors.warning,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),

                                  // Quantity & Expiry Info
                                  Text(
                                    '${offer.availableQuantity} ${offer.unit} • ${offer.isExpiring ? "Expires in 2 days" : "Fresh Inventory"}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),

                                  // Price Breakdown
                                  Row(
                                    children: [
                                      Text(
                                        'MRP ₹${offer.originalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '➔ Target ₹${offer.discountedPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.kiranaPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Discount CTA Action Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const CreateDiscountScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.kiranaPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('DISCOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
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

  Widget _buildFilterChip(String filterKey, String label, int count) {
    final isSel = selectedFilter == filterKey;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFilter = filterKey;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: isSel ? AppColors.kiranaPrimary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSel ? AppColors.kiranaPrimary : AppColors.border,
              width: isSel ? 1.5 : 1.0,
            ),
            boxShadow: isSel
                ? [
                    BoxShadow(
                      color: AppColors.kiranaPrimary.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSel) ...[
                const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSel ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSel ? FontWeight.w900 : FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: isSel ? Colors.white.withValues(alpha: 0.25) : AppColors.kiranaBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: isSel ? Colors.white : AppColors.kiranaPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterHeaderText(int count) {
    if (selectedFilter == 'EXPIRING') {
      return 'EXPIRING · $count PRODUCTS AT RISK';
    } else if (selectedFilter == 'LOW STOCK') {
      return 'LOW STOCK · $count PRODUCTS BELOW THRESHOLD';
    }
    return 'ALL INVENTORY · $count TOTAL PRODUCTS';
  }

  Widget _buildEmptyState() {
    if (selectedFilter == 'EXPIRING') {
      return const EmptyStateWidget(
        title: 'No products expiring soon',
        description: 'Your inventory is currently healthy.',
        emoji: '✓',
        color: AppColors.kiranaPrimary,
      );
    } else if (selectedFilter == 'LOW STOCK') {
      return const EmptyStateWidget(
        title: 'No low-stock products',
        description: 'All products have sufficient stock.',
        emoji: '✓',
        color: AppColors.kiranaPrimary,
      );
    }
    return const EmptyStateWidget(
      title: 'No Inventory Products',
      description: 'Your store inventory is empty right now.',
      emoji: '🏪',
      color: AppColors.kiranaPrimary,
    );
  }
}
