import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/smart_match_card.dart';
import '../../models/models.dart';

class AddSurplusScreen extends StatefulWidget {
  const AddSurplusScreen({super.key});

  @override
  State<AddSurplusScreen> createState() => _AddSurplusScreenState();
}

class _AddSurplusScreenState extends State<AddSurplusScreen> {
  final _titleCtrl = TextEditingController(text: 'Paneer Butter Masala & Naan Combo');
  final _mealsCtrl = TextEditingController(text: '35');
  final _locationCtrl = TextEditingController(text: 'Koramangala 5th Block');
  String _category = 'Prepared Meals';
  String _targetType = 'DONATE'; // DONATE, SELL, BOTH
  String _selectedFoodImageUrl = AppImage.foodPaneer;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Surplus Food Batch'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image Upload / Preview Container
            const Text('Food Batch Photo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.restaurantPrimary.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AppImage(
                        url: _selectedFoodImageUrl,
                        borderRadius: 18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                            SizedBox(width: 6),
                            Text('Change Photo', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Food Category Sample Pickers
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPhotoOption('Thali', AppImage.foodThali),
                  const SizedBox(width: 8),
                  _buildPhotoOption('Paneer', AppImage.foodPaneer),
                  const SizedBox(width: 8),
                  _buildPhotoOption('Biryani', AppImage.foodBiryani),
                  const SizedBox(width: 8),
                  _buildPhotoOption('Bakery', AppImage.foodBakery),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Target Type Selector
            const Text('Recovery Channel:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildChannelOption('DONATE', '❤️ NGO Recovery', 'Free food rescue for social impact', AppColors.ngoPrimary),
                const SizedBox(width: 10),
                _buildChannelOption('BOTH', '🔥 Dual Channel', 'NGO donate + Marketplace sell', AppColors.restaurantPrimary),
              ],
            ),
            const SizedBox(height: 20),

            // Form Inputs
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Food Batch Title / Description'),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mealsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity (Meals)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: ['Prepared Meals', 'Gravy & Breads', 'Biryani & Rice', 'Bakery & Sweets']
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _category = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Pickup Address / Location'),
            ),
            const SizedBox(height: 20),

            // AI Smart Match Preview Card
            SmartMatchCard(
              match: SmartMatchResult(
                ngoName: 'Helping Hands Foundation',
                overallMatch: 91,
                capacityScore: 95,
                distanceScore: 82,
                requirementScore: 90,
                trustScore: 92,
                pickupReliability: 88,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final title = _titleCtrl.text;
                  final meals = int.tryParse(_mealsCtrl.text) ?? 35;
                  state.addSurplusItem(
                    title: title,
                    mealsCount: meals,
                    category: _category,
                    targetType: _targetType,
                    location: _locationCtrl.text,
                  );

                  _showPublishedDialog(context, title, meals);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.restaurantPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.cloud_upload),
                label: const Text('POST SURPLUS & TRIGGER SMART MATCH', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption(String name, String url) {
    final isSel = _selectedFoodImageUrl == url;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFoodImageUrl = url;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? AppColors.restaurantBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? AppColors.restaurantPrimary : AppColors.border, width: isSel ? 2 : 1),
        ),
        child: Row(
          children: [
            AppImage(url: url, width: 24, height: 24, borderRadius: 6),
            const SizedBox(width: 6),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.w900 : FontWeight.w600, color: isSel ? AppColors.restaurantPrimary : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelOption(String val, String title, String desc, Color color) {
    final isSel = _targetType == val;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _targetType = val;
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSel ? color.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSel ? color : AppColors.border, width: isSel ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  void _showPublishedDialog(BuildContext context, String title, int meals) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.auto_awesome, color: AppColors.aiAccent, size: 28),
            SizedBox(width: 8),
            Text('Smart Match Triggered!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posted $meals Meals: $title', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('• Ranked Helping Hands NGO as top match (91%).'),
            const Text('• 8-Minute acceptance countdown dispatched to NGO.'),
            const Text('• Track live acceptance on your dashboard.'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.restaurantPrimary),
            child: const Text('GO TO DASHBOARD'),
          ),
        ],
      ),
    );
  }
}
