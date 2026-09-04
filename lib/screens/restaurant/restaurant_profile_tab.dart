import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/profile_support_widgets.dart';
import '../../widgets/subtle_background_animation.dart';
import '../welcome_screen.dart';

class RestaurantProfileTab extends StatefulWidget {
  const RestaurantProfileTab({super.key});

  @override
  State<RestaurantProfileTab> createState() => _RestaurantProfileTabState();
}

class _RestaurantProfileTabState extends State<RestaurantProfileTab> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    const primaryColor = AppColors.restaurantPrimary;

    return SubtleBackgroundAnimation(
      role: UserRole.restaurant,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PROFILE HEADER CARD (Cover + Circular Avatar + Edit Button)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Cover Image with Camera Edit Overlay
                  SizedBox(
                    height: 125,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                            child: AppImage(
                              url: state.restaurantCoverUrl,
                              borderRadius: 0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: InkWell(
                            onTap: () => PhotoPickerDialog.show(
                              context,
                              role: UserRole.restaurant,
                              isCover: true,
                              currentUrl: state.restaurantCoverUrl,
                              onSelected: (url) => state.updateRestaurantProfile(coverUrl: url),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                  SizedBox(width: 5),
                                  Text(
                                    'Edit Cover',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Avatar, Titles & Edit Profile Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Circular Profile Image with Camera overlay
                            GestureDetector(
                              onTap: () => PhotoPickerDialog.show(
                                context,
                                role: UserRole.restaurant,
                                isCover: false,
                                currentUrl: state.restaurantAvatarUrl,
                                onSelected: (url) => state.updateRestaurantProfile(avatarUrl: url),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(36),
                                      child: AppImage(
                                        url: state.restaurantAvatarUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.restaurantName,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.verified, color: primaryColor, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Owner: ${state.restaurantOwnerName}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    state.restaurantAddress,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Prominent EDIT PROFILE DETAILS Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showEditRestaurantModal(context, state),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: const BorderSide(color: primaryColor, width: 1.6),
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.edit_note_rounded, size: 20),
                            label: const Text(
                              'EDIT PROFILE DETAILS',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, letterSpacing: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. FOODRESQ GREEN REWARDS & ESG IMPACT CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.08),
                    AppColors.warning.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: primaryColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('FoodResQ Green Partner • Gold Tier', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textPrimary)),
                        SizedBox(height: 2),
                        Text('1,240 ESG Impact Points • Tax Exemption 80G Certified', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('ACTIVE', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. QUICK STATS ROW
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat('₹${state.restaurantRevenueToday.toStringAsFixed(0)}', 'Revenue Today', AppColors.success),
                  _buildStatDivider(),
                  _buildQuickStat('${state.restaurantSavedMealsToday}', 'Meals Donated', primaryColor),
                  _buildStatDivider(),
                  _buildQuickStat('${state.restaurantWasteKgToday.toStringAsFixed(0)} kg', 'Waste Diverted', AppColors.warning),
                  _buildStatDivider(),
                  _buildQuickStat('88/100', 'Trust Score', const Color(0xFF4F46A5)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. RESTAURANT INFORMATION CARD (With individual row edit actions)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.restaurant_menu_rounded, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Restaurant Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _showEditRestaurantModal(context, state),
                        icon: const Icon(Icons.edit_outlined, color: primaryColor, size: 20),
                        tooltip: 'Edit All Information',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProfileDetailTile(
                    icon: Icons.restaurant_rounded,
                    label: 'Restaurant Name',
                    value: state.restaurantName,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'name'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Owner / General Manager',
                    value: state.restaurantOwnerName,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'owner'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address / Location',
                    value: state.restaurantAddress,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'address'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.security_rounded,
                    label: 'FSSAI License Number',
                    value: state.restaurantFssai,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'fssai'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.badge_outlined,
                    label: 'Registration / License No.',
                    value: state.restaurantRegNumber,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'regNumber'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: state.restaurantPhone,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'phone'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: state.restaurantEmail,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'email'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.dinner_dining_rounded,
                    label: 'Cuisine Type',
                    value: state.restaurantCuisine,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'cuisine'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.access_time_rounded,
                    label: 'Opening Hours',
                    value: state.restaurantOperatingHours,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'hours'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.volunteer_activism_rounded,
                    label: 'Food Donation & Rescue Preference',
                    value: state.restaurantDonationPref,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditRestaurantModal(context, state, focusField: 'donation'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 5. NOTIFICATIONS, SUPPORT & UTILITIES MENU
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.notifications_active_outlined, color: primaryColor, size: 20),
                    ),
                    title: const Text('Notifications & Alerts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('Surplus pickups, cascade alerts & ESG reports', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => NotificationsModal.show(context, UserRole.restaurant),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.verified_user_outlined, color: AppColors.success, size: 20),
                    ),
                    title: const Text('FSSAI & Food Safety Documents', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('FSSAI certificate, BBMP health license, fire NOC', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => VerificationDocumentsModal.show(context, UserRole.restaurant),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.aiAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.help_center_outlined, color: AppColors.aiAccent, size: 20),
                    ),
                    title: const Text('Partner Support & FAQs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('Cascade timer rules, packaging standards & tax credits', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => SupportFaqModal.show(context, UserRole.restaurant),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.support_agent_rounded, color: AppColors.info, size: 20),
                    ),
                    title: const Text('Call Assistance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('24/7 priority restaurant partner desk & callback', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => CallAssistanceModal.show(context, UserRole.restaurant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. LOG OUT ACTION
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.critical.withOpacity(0.25)),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.critical.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.logout_rounded, color: AppColors.critical, size: 20),
                ),
                title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.critical)),
                subtitle: const Text('Sign out of Urban Tadka Restaurant portal', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.critical),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FoodresQWelcomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String val, String label, Color color) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 26, width: 1, color: AppColors.border);
  }

  // EDIT RESTAURANT PROFILE MODAL
  void _showEditRestaurantModal(BuildContext context, AppState state, {String? focusField}) {
    final nameCtrl = TextEditingController(text: state.restaurantName);
    final ownerCtrl = TextEditingController(text: state.restaurantOwnerName);
    final addressCtrl = TextEditingController(text: state.restaurantAddress);
    final fssaiCtrl = TextEditingController(text: state.restaurantFssai);
    final regCtrl = TextEditingController(text: state.restaurantRegNumber);
    final phoneCtrl = TextEditingController(text: state.restaurantPhone);
    final emailCtrl = TextEditingController(text: state.restaurantEmail);
    final cuisineCtrl = TextEditingController(text: state.restaurantCuisine);
    final hoursCtrl = TextEditingController(text: state.restaurantOperatingHours);
    final donationCtrl = TextEditingController(text: state.restaurantDonationPref);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.edit_note_rounded, color: AppColors.restaurantPrimary, size: 26),
            SizedBox(width: 8),
            Text('Edit Restaurant Details', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  autofocus: focusField == 'name',
                  decoration: const InputDecoration(labelText: 'Restaurant Name', prefixIcon: Icon(Icons.restaurant_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ownerCtrl,
                  autofocus: focusField == 'owner',
                  decoration: const InputDecoration(labelText: 'Owner / Manager', prefixIcon: Icon(Icons.person_outline_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressCtrl,
                  autofocus: focusField == 'address',
                  decoration: const InputDecoration(labelText: 'Address / Location', prefixIcon: Icon(Icons.location_on_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fssaiCtrl,
                  autofocus: focusField == 'fssai',
                  decoration: const InputDecoration(labelText: 'FSSAI License No.', prefixIcon: Icon(Icons.security_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: regCtrl,
                  autofocus: focusField == 'regNumber',
                  decoration: const InputDecoration(labelText: 'Registration No.', prefixIcon: Icon(Icons.badge_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneCtrl,
                  autofocus: focusField == 'phone',
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  autofocus: focusField == 'email',
                  decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cuisineCtrl,
                  autofocus: focusField == 'cuisine',
                  decoration: const InputDecoration(labelText: 'Cuisine Type', prefixIcon: Icon(Icons.dinner_dining_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hoursCtrl,
                  autofocus: focusField == 'hours',
                  decoration: const InputDecoration(labelText: 'Operating Hours', prefixIcon: Icon(Icons.access_time_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: donationCtrl,
                  autofocus: focusField == 'donation',
                  decoration: const InputDecoration(labelText: 'Donation Preference', prefixIcon: Icon(Icons.volunteer_activism_rounded, size: 18)),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              state.updateRestaurantProfile(
                name: nameCtrl.text.trim(),
                ownerName: ownerCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                fssai: fssaiCtrl.text.trim(),
                regNumber: regCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                cuisine: cuisineCtrl.text.trim(),
                operatingHours: hoursCtrl.text.trim(),
                donationPref: donationCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Restaurant profile updated successfully!'),
                  backgroundColor: AppColors.restaurantPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.restaurantPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            ),
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
