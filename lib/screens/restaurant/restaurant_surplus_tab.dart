import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final items = state.surplusItems;

    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['ACTIVE', 'ACCEPTED', 'COMPLETED', 'EXPIRED'].map((tab) {
                final isSel = activeTab == tab;
                return ChoiceChip(
                  label: Text(tab),
                  selected: isSel,
                  onSelected: (v) => setState(() => activeTab = tab),
                  selectedColor: AppColors.restaurantPrimary,
                  labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const EmptyStateWidget(
                    title: 'No Surplus Batches',
                    description: 'You have no active surplus food batches right now. Click + ADD SURPLUS to post a batch.',
                    emoji: '🍳',
                    color: AppColors.restaurantPrimary,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final imageUrl = _getFoodImageUrl(index);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
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
                                          color: AppColors.restaurantPrimary.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item.targetType,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary),
                                        ),
                                      ),
                                      Text(
                                        'Status: ${item.status.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: item.status == 'accepted' ? AppColors.success : AppColors.restaurantPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(item.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                  const SizedBox(height: 2),
                                  Text('${item.mealsCount} Meals • ${item.category}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  if (item.acceptedByNgo != null) ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.ngoBg,
                                        borderRadius: BorderRadius.circular(8),
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
}
