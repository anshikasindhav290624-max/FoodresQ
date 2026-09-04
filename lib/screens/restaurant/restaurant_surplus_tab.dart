import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';

class RestaurantSurplusTab extends StatefulWidget {
  const RestaurantSurplusTab({super.key});

  @override
  State<RestaurantSurplusTab> createState() => _RestaurantSurplusTabState();
}

class _RestaurantSurplusTabState extends State<RestaurantSurplusTab> {
  String activeTab = 'ACTIVE';

  String _getFoodImageUrl(int index) {
    switch (index % 3) {
      case 0:
        return AppImage.foodThali;
      case 1:
        return AppImage.foodPaneer;
      case 2:
        return AppImage.foodBiryani;
      default:
        return AppImage.foodThali;
    }
  }

  List<SurplusItem> _getFilteredItems(List<SurplusItem> allItems) {
    if (activeTab == 'ACTIVE') {
      return allItems.where((i) => i.status.toLowerCase() == 'active').toList();
    } else if (activeTab == 'ACCEPTED') {
      return allItems.where((i) => i.status.toLowerCase() == 'accepted').toList();
    } else if (activeTab == 'COMPLETED') {
      return allItems.where((i) => i.status.toLowerCase() == 'completed').toList();
    }
    return allItems;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final allItems = state.surplusItems;

    final activeCount = allItems.where((i) => i.status.toLowerCase() == 'active').length;
    final acceptedCount = allItems.where((i) => i.status.toLowerCase() == 'accepted').length;
    final completedCount = allItems.where((i) => i.status.toLowerCase() == 'completed').length;
    final allCount = allItems.length;

    final filteredItems = _getFilteredItems(allItems);

    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: Column(
        children: [
          // 1. FILTER TABS BAR (Kirana Store Design Language)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildFilterChip('ACTIVE', 'ACTIVE', activeCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('ACCEPTED', 'ACCEPTED', acceptedCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('COMPLETED', 'COMPLETED', completedCount),
                    const SizedBox(width: 8),
                    _buildFilterChip('ALL', 'ALL', allCount),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SHOWING ${filteredItems.length} OF $allCount BATCHES',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (activeTab != 'ALL')
                      GestureDetector(
                        onTap: () => setState(() => activeTab = 'ALL'),
                        child: const Text(
                          'Show All',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.restaurantPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
                ? EmptyStateWidget(
                    title: 'No $activeTab Batches',
                    description: activeTab == 'ALL'
                        ? 'You have no surplus food batches right now. Click + ADD SURPLUS to post a batch.'
                        : 'No batches found under $activeTab status.',
                    emoji: '🍳',
                    color: AppColors.restaurantPrimary,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final imageUrl = _getFoodImageUrl(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border, width: 1.2),
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.restaurantPrimary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.targetType,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: item.status == 'accepted' ? AppColors.success.withValues(alpha: 0.12) : AppColors.restaurantPrimary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.status.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: item.status == 'accepted' ? AppColors.success : AppColors.restaurantPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                                  const SizedBox(height: 2),
                                  Text('${item.mealsCount} Meals • ${item.category}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                                  if (item.acceptedByNgo != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.ngoBg,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppColors.ngoPrimary.withValues(alpha: 0.2)),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.volunteer_activism, color: AppColors.ngoPrimary, size: 14),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text('Accepted by ${item.acceptedByNgo}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.ngoPrimary), overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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

  Widget _buildFilterChip(String label, String value, int count) {
    final isSelected = activeTab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.restaurantPrimary : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.restaurantPrimary : AppColors.border,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                const SizedBox(width: 2),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.border,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
