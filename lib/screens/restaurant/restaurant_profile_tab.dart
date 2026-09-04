import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import '../welcome_screen.dart';

class RestaurantProfileTab extends StatefulWidget {
  const RestaurantProfileTab({super.key});

  @override
  State<RestaurantProfileTab> createState() => _RestaurantProfileTabState();
}

class _RestaurantProfileTabState extends State<RestaurantProfileTab> {
  String? _editingField;
  late TextEditingController _textController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _startEditing(String fieldKey, String currentValue) {
    setState(() {
      _editingField = fieldKey;
      _textController.text = currentValue;
      _errorText = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingField = null;
      _textController.clear();
      _errorText = null;
    });
  }

  void _saveField(String fieldKey, AppState state) {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Field cannot be empty');
      return;
    }
    if (fieldKey == 'phone') {
      final clean = text.replaceAll(RegExp(r'\D'), '');
      if (clean.length < 10) { setState(() => _errorText = 'Enter a valid phone number'); return; }
    }
    if (fieldKey == 'email') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(text)) { setState(() => _errorText = 'Enter a valid email'); return; }
    }
    switch (fieldKey) {
      case 'name': state.updateRestaurantProfile(name: text); break;
      case 'owner': state.updateRestaurantProfile(ownerName: text); break;
      case 'location': state.updateRestaurantProfile(location: text); break;
      case 'reg': state.updateRestaurantProfile(regNumber: text); break;
      case 'fssai': state.updateRestaurantProfile(fssai: text); break;
      case 'phone': state.updateRestaurantProfile(phone: text); break;
      case 'email': state.updateRestaurantProfile(email: text); break;
      case 'cuisine': state.updateRestaurantProfile(cuisine: text); break;
      case 'hours': state.updateRestaurantProfile(hours: text); break;
    }
    _cancelEditing();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(children: [Icon(Icons.check_circle_rounded, color: Colors.white, size: 18), SizedBox(width: 8), Text('Profile updated successfully!')]),
      backgroundColor: AppColors.restaurantPrimary,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─────────────────────────────────────────────────────────────────
            // COVER + AVATAR HEADER CARD
            // ─────────────────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1.2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AppImage(url: AppImage.restaurantKitchen, borderRadius: 0, fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.restaurantPrimary.withValues(alpha: 0.6), Colors.transparent],
                                begin: Alignment.bottomCenter, end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10, right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.camera_alt, color: Colors.white, size: 13),
                                SizedBox(width: 4),
                                Text('Edit Cover', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 68, height: 68,
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                                  child: ClipRRect(borderRadius: BorderRadius.circular(34), child: AppImage(url: AppImage.restaurantKitchen, fit: BoxFit.cover)),
                                ),
                                Positioned(bottom: 0, right: 0, child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(color: AppColors.restaurantPrimary, shape: BoxShape.circle),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
                                )),
                              ],
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(state.restaurantName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
                                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                          Icon(Icons.verified, size: 12, color: AppColors.success),
                                          SizedBox(width: 2),
                                          Text('VERIFIED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.success)),
                                        ]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text('Owner: ${state.restaurantOwnerName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                                  Text(state.restaurantLocation, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _startEditing('name', state.restaurantName),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.restaurantPrimary,
                              side: const BorderSide(color: AppColors.restaurantPrimary, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.edit_note_rounded, size: 18),
                            label: const Text('EDIT PROFILE DETAILS', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, thickness: 0.8),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat('Meals Saved', '1,820', AppColors.success),
                            _buildStatDivider(),
                            _buildStat('Revenue', '₹18.4K', AppColors.restaurantPrimary),
                            _buildStatDivider(),
                            _buildStat('Waste Saved', '450 kg', AppColors.warning),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // RESTAURANT INFORMATION CARD (Editable)
            // ─────────────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Restaurant Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      Icon(Icons.restaurant_rounded, color: AppColors.restaurantPrimary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildEditableTile('name', Icons.storefront_rounded, 'Restaurant Name', state.restaurantName, state),
                  const Divider(height: 20),
                  _buildEditableTile('owner', Icons.person_outline_rounded, 'Owner Name', state.restaurantOwnerName, state),
                  const Divider(height: 20),
                  _buildEditableTile('location', Icons.location_on_outlined, 'Address / Location', state.restaurantLocation, state),
                  const Divider(height: 20),
                  _buildEditableTile('reg', Icons.badge_outlined, 'Registration No.', state.restaurantRegNumber, state),
                  const Divider(height: 20),
                  _buildEditableTile('fssai', Icons.security_rounded, 'FSSAI License No.', state.restaurantFssai, state),
                  const Divider(height: 20),
                  _buildEditableTile('phone', Icons.phone_outlined, 'Phone Number', state.restaurantPhone, state),
                  const Divider(height: 20),
                  _buildEditableTile('email', Icons.email_outlined, 'Email Address', state.restaurantEmail, state),
                  const Divider(height: 20),
                  _buildEditableTile('cuisine', Icons.set_meal_rounded, 'Cuisine Type', state.restaurantCuisine, state),
                  const Divider(height: 20),
                  _buildEditableTile('hours', Icons.schedule_outlined, 'Opening Hours', state.restaurantHours, state),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // FOODRESQ REWARDS CARD (preserved)
            // ─────────────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35), width: 1.2),
                boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)), child: const Text('⭐', style: TextStyle(fontSize: 18))),
                        const SizedBox(width: 10),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('FoodResQ Rewards', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                          Text('${state.rewardTierEmoji} ${state.rewardTierName} Tier', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                        ]),
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.35))),
                        child: Text('${state.restaurantPoints} pts', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFD97706))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('+${state.pointsEarnedThisMonth} pts this month', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                    Text(state.pointsToNextTier > 0 ? '${state.pointsToNextTier} pts to Champion' : 'Max Tier Reached!', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(value: state.tierProgress.clamp(0.05, 1.0), minHeight: 6, backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.15), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD97706))),
                  ),
                  const SizedBox(height: 10),
                  const Text('Earn 10 pts/kg of surplus food rescued. Redeem 500 pts for ₹100 OFF Kirana near-expiry stock.', style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────────
            // SUPPORT SECTIONS
            // ─────────────────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 1.2),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildSettingTile(Icons.notifications_outlined, 'Notifications & Alerts', 'Manage sound and banner signals', () => _showNotificationsModal(context)),
                  const Divider(height: 1, indent: 56),
                  _buildSettingTile(Icons.security_rounded, 'FSSAI & Food Safety', 'Certified standards valid until 2027', () => _showFssaiModal(context)),
                  const Divider(height: 1, indent: 56),
                  _buildSettingTile(Icons.support_agent_rounded, 'Partner Support & FAQs', '24/7 Priority restaurant assistance', () => _showFaqModal(context)),
                  const Divider(height: 1, indent: 56),
                  _buildSettingTile(Icons.phone_in_talk_rounded, 'Call Assistance', 'Talk to a FoodResQ agent', () => _showCallModal(context)),
                  const Divider(height: 1, indent: 56),
                  _buildSettingTile(Icons.volunteer_activism_rounded, 'Donation/Rescue Guidelines', 'Best practices for food donation', () => _showGuidelinesModal(context)),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.critical.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.logout_rounded, color: AppColors.critical, size: 20)),
                    title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.critical, fontSize: 14)),
                    subtitle: Text('Sign out of ${state.restaurantName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                    onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FoodresQWelcomeScreen()), (route) => false),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build helpers ──────────────────────────────────────────────────────────
  Widget _buildStat(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    ]);
  }

  Widget _buildStatDivider() => Container(width: 1, height: 28, color: AppColors.border);

  Widget _buildEditableTile(String fieldKey, IconData icon, String label, String value, AppState state) {
    final isEditing = _editingField == fieldKey;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.restaurantPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                if (!isEditing) ...[const SizedBox(height: 2), Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary))],
              ]),
            ),
            if (!isEditing)
              InkWell(
                onTap: () => _startEditing(fieldKey, value),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
                    Icon(Icons.edit_outlined, color: AppColors.restaurantPrimary, size: 14),
                    SizedBox(width: 4),
                    Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.restaurantPrimary)),
                  ]),
                ),
              ),
          ],
        ),
        if (isEditing) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _textController,
            autofocus: true,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.restaurantPrimary)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.restaurantPrimary, width: 2)),
              errorText: _errorText,
              errorStyle: const TextStyle(color: AppColors.critical, fontSize: 11),
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            OutlinedButton(onPressed: _cancelEditing, style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact, foregroundColor: AppColors.textSecondary, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Cancel', style: TextStyle(fontSize: 12))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () => _saveField(fieldKey, state), style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact, backgroundColor: AppColors.restaurantPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Save', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
          ]),
        ],
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.restaurantPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.restaurantPrimary, size: 20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  // ── Modals ─────────────────────────────────────────────────────────────────
  void _showNotificationsModal(BuildContext context) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          const Text('Notifications & Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          _notifRow('Surplus pickup requests', 'When NGO requests food from you', true),
          _notifRow('Kirana deal alerts', 'New near-expiry ingredient deals', true),
          _notifRow('Points & rewards', 'When you earn FoodResQ points', true),
          _notifRow('System updates', 'Platform announcements', false),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.restaurantPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Save Preferences', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)))),
        ]),
      ),
    );
  }

  Widget _notifRow(String title, String sub, bool on) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
        Switch(value: on, onChanged: (_) {}, activeColor: AppColors.restaurantPrimary),
      ]),
    );
  }

  void _showFssaiModal(BuildContext context) {
    showDialog(context: context, builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.security_rounded, color: AppColors.success, size: 22)),
          const SizedBox(width: 10),
          const Text('FSSAI & Food Safety', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 16),
        Consumer<AppState>(builder: (_, s, __) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('License: ${s.restaurantFssai}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Valid Until: December 2027', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)), child: const Row(children: [Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18), SizedBox(width: 8), Expanded(child: Text('Your restaurant meets all FSSAI hygiene and food safety standards.', style: TextStyle(fontSize: 12, height: 1.4)))])),
        ])),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.restaurantPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)))),
      ])),
    ));
  }

  void _showFaqModal(BuildContext context) {
    final faqs = [
      ['How does food donation work?', 'Mark surplus food via the Surplus tab. NGOs in your area receive an alert and can accept/reject. You earn reward points per kg donated.'],
      ['How do I track my reward points?', 'Points are shown on this Profile tab under FoodResQ Rewards. You earn 10 pts/kg rescued and can redeem for Kirana discounts.'],
      ['Can I edit my FSSAI number?', 'Yes, tap Edit next to FSSAI License No. in the Restaurant Information card and enter your updated license.'],
      ['What are pickup preferences?', 'You can set food pickup availability (hot/cold ready for pickup) so NGOs know what to expect when they arrive.'],
    ];
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(initialChildSize: 0.7, maxChildSize: 0.92, minChildSize: 0.4,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: controller, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Text('Partner Support & FAQs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            const Text('Common questions for Restaurant partners', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            ...faqs.map((faq) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.restaurantPrimary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(faq[0], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 6),
                Text(faq[1], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              ]),
            )),
          ]),
        ),
      ),
    );
  }

  void _showCallModal(BuildContext context) {
    showDialog(context: context, builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.restaurantPrimary.withValues(alpha: 0.10), shape: BoxShape.circle), child: const Icon(Icons.headset_mic_rounded, color: AppColors.restaurantPrimary, size: 32)),
        const SizedBox(height: 16),
        const Text('Call Assistance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        const Text('Restaurant support team available daily, 9 AM to 9 PM', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        const Text('+91 1800-FRQ-RESTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.restaurantPrimary)),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.callback_rounded, size: 16), label: const Text('Request Callback', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)), style: OutlinedButton.styleFrom(foregroundColor: AppColors.restaurantPrimary, side: const BorderSide(color: AppColors.restaurantPrimary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.phone_rounded, size: 16, color: Colors.white), label: const Text('Call Support', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.restaurantPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
        ]),
      ])),
    ));
  }

  void _showGuidelinesModal(BuildContext context) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          const Text('Donation & Rescue Guidelines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          ...[
            ['🌡️ Temperature', 'Hot food must be above 60°C. Cold food below 4°C. Room temp food is not accepted for donation.'],
            ['⏱️ Timing', 'Mark surplus within 1 hour of preparation. NGOs have 4–6 hours to collect after listing.'],
            ['📦 Packaging', 'Seal all food in clean, labelled containers. Include preparation time and item description.'],
            ['✅ Safety', 'Only food that is safe for human consumption can be donated. Pre-check for contamination or spoilage.'],
          ].map((g) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.restaurantPrimary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(g[0], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              const SizedBox(height: 4),
              Text(g[1], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
            ]),
          )),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: AppColors.restaurantPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Got It', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)))),
        ]),
      ),
    );
  }
}
