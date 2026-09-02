import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/subtle_background_animation.dart';
import 'ngo_pickup_tracking_screen.dart';

class NgoAvailableTab extends StatefulWidget {
  const NgoAvailableTab({super.key});

  @override
  State<NgoAvailableTab> createState() => _NgoAvailableTabState();
}

class _NgoAvailableTabState extends State<NgoAvailableTab> {
  bool isMapView = false;
  String selectedFilter = 'ALL';

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
    // Filter active items only
    var items = state.surplusItems.where((i) => i.status == 'active').toList();

    if (selectedFilter == '< 3 KM') {
      items = items.where((i) => i.distanceKm <= 3.0).toList();
    } else if (selectedFilter == 'VEGETARIAN') {
      items = items.where((i) => i.isVeg).toList();
    } else if (selectedFilter == 'LARGE BATCH (>30 MEALS)') {
      items = items.where((i) => i.mealsCount >= 30).toList();
    }

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: Column(
        children: [
          // Search & Filters Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search food type, restaurant or area...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isMapView = !isMapView;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMapView ? AppColors.ngoPrimary : AppColors.ngoBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.ngoPrimary),
                        ),
                        child: Icon(
                          isMapView ? Icons.list : Icons.map_outlined,
                          color: isMapView ? Colors.white : AppColors.ngoPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['ALL', '< 3 KM', 'VEGETARIAN', 'LARGE BATCH (>30 MEALS)'].map((filter) {
                      final isSel = selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSel,
                          onSelected: (v) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          selectedColor: AppColors.ngoPrimary,
                          labelStyle: TextStyle(
                            color: isSel ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main List or Map Content
          Expanded(
            child: isMapView
                ? _buildMapView(state)
                : items.isEmpty
                    ? const EmptyStateWidget(
                        title: 'No Surplus Food Found',
                        description: 'No surplus food matching your filter in your immediate area right now.',
                        emoji: '🍱',
                        color: AppColors.ngoPrimary,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final imageUrl = _getFoodImageUrl(index);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Card Image Banner with Badges
                                SizedBox(
                                  height: 140,
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
                                                Colors.black.withValues(alpha: 0.6),
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
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: item.isVeg ? Colors.green.shade700 : Colors.red.shade700,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            item.isVeg ? '🌱 VEG' : '🍗 NON-VEG',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.7),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '📍 ${item.distanceKm} km away',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 12,
                                        right: 12,
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Card Content Details
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Restaurant: ${item.restaurantName} • ${item.location}',
                                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.ngoBg,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.restaurant_menu, color: AppColors.ngoPrimary, size: 18),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '${item.mealsCount} Prepared Meals',
                                                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.ngoPrimary, fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            const Text('Pickup before 10:30 PM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 14),

                                      // BOTH REJECT & ACCEPT BUTTONS
                                      Row(
                                        children: [
                                          // REJECT BUTTON (Secondary Outlined Red Visual)
                                          Expanded(
                                            flex: 1,
                                            child: OutlinedButton.icon(
                                              onPressed: () {
                                                _showRejectConfirmationDialog(context, state, item);
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppColors.critical,
                                                side: const BorderSide(color: AppColors.critical, width: 1.5),
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                              ),
                                              icon: const Icon(Icons.close_rounded, size: 16),
                                              label: const Text('REJECT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                                            ),
                                          ),
                                          const SizedBox(width: 10),

                                          // ACCEPT & INITIATE PICKUP BUTTON (Primary NGO Teal Visual)
                                          Expanded(
                                            flex: 2,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                state.acceptCascadeOpportunity();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => NgoPickupTrackingScreen(item: item),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.ngoPrimary,
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(vertical: 12),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                              ),
                                              icon: const Icon(Icons.check_circle_outline, size: 16),
                                              label: const Text('ACCEPT & INITIATE PICKUP', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                                            ),
                                          ),
                                        ],
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

  void _showRejectConfirmationDialog(BuildContext context, AppState state, SurplusItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reject this food donation?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to reject ${item.mealsCount} meals from ${item.restaurantName}? This will move the record to history.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.rejectSurplusItem(item);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Donation offer rejected and moved to History.'),
                  backgroundColor: AppColors.critical,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.critical,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(AppState state) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE5E9E7),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.map, size: 64, color: AppColors.ngoPrimary),
                SizedBox(height: 12),
                Text(
                  'Interactive Food Opportunity Map',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                SizedBox(height: 4),
                Text('Showing 3 active surplus pickups near Koramangala', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.ngoPrimary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Urban Tadka (2.4 km)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('35 Meals • Pickup before 10:30 PM', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.ngoPrimary),
                    child: const Text('SELECT'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
