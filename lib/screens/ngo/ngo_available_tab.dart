import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import 'ngo_pickup_tracking_screen.dart';

class NgoAvailableTab extends StatefulWidget {
  const NgoAvailableTab({super.key});

  @override
  State<NgoAvailableTab> createState() => _NgoAvailableTabState();
}

class _NgoAvailableTabState extends State<NgoAvailableTab> {
  bool isMapView = false;
  String selectedFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final items = state.surplusItems;

    return Column(
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.isVeg ? Colors.green.shade50 : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: item.isVeg ? Colors.green : Colors.red),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle, size: 8, color: item.isVeg ? Colors.green : Colors.red),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.isVeg ? 'VEG' : 'NON-VEG',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        color: item.isVeg ? Colors.green.shade800 : Colors.red.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${item.distanceKm} km away',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Restaurant: ${item.restaurantName} • ${item.location}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 14),
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
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
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
                              ),
                              child: const Text('ACCEPT & INITIATE PICKUP'),
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
