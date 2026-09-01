import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';

class RestaurantSurplusTab extends StatefulWidget {
  const RestaurantSurplusTab({super.key});

  @override
  State<RestaurantSurplusTab> createState() => _RestaurantSurplusTabState();
}

class _RestaurantSurplusTabState extends State<RestaurantSurplusTab> {
  String activeTab = 'ACTIVE';

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final items = state.surplusItems;

    return Column(
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
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: item.status == 'accepted' ? AppColors.success : AppColors.restaurantPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(item.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${item.mealsCount} Meals • ${item.category}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    if (item.acceptedByNgo != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.ngoBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volunteer_activism, color: AppColors.ngoPrimary, size: 16),
                            const SizedBox(width: 6),
                            Text('Accepted by ${item.acceptedByNgo}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.ngoPrimary)),
                          ],
                        ),
                      ),
                    ],
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
