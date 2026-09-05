import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/profile_support_widgets.dart';
import '../../widgets/subtle_background_animation.dart';
import '../welcome_screen.dart';
import '../../services/auth_service.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    const primaryColor = AppColors.vendorPrimary;

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
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
                              url: state.vendorCoverUrl,
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
                              role: UserRole.vendor,
                              isCover: true,
                              currentUrl: state.vendorCoverUrl,
                              onSelected: (url) => state.updateVendorProfile(coverUrl: url),
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
                                role: UserRole.vendor,
                                isCover: false,
                                currentUrl: state.vendorAvatarUrl,
                                onSelected: (url) => state.updateVendorProfile(avatarUrl: url),
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
                                        url: state.vendorAvatarUrl,
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
                                          state.vendorBusinessName,
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
                                    'Owner: ${state.vendorOwnerName}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    state.vendorAddress,
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
                            onPressed: () => _showEditVendorModal(context, state),
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

            // 2. QUICK STATS ROW
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
                  _buildQuickStat('₹${state.vendorMoneySaved.toStringAsFixed(0)}', 'Total Saved', primaryColor),
                  _buildStatDivider(),
                  _buildQuickStat('${state.vendorOrdersCount}', 'Orders Done', AppColors.success),
                  _buildStatDivider(),
                  _buildQuickStat('${state.vendorNearExpiryKg.toStringAsFixed(0)} kg', 'Stock Recovered', AppColors.warning),
                  _buildStatDivider(),
                  _buildQuickStat('${state.vendorActiveDeals}', 'Active Deals', const Color(0xFF8B7CF6)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. BUSINESS INFORMATION CARD (With individual row edit actions)
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
                          Icon(Icons.storefront_rounded, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Business Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _showEditVendorModal(context, state),
                        icon: const Icon(Icons.edit_outlined, color: primaryColor, size: 20),
                        tooltip: 'Edit All Information',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProfileDetailTile(
                    icon: Icons.business_rounded,
                    label: 'Business Name',
                    value: state.vendorBusinessName,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'name'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Owner Name',
                    value: state.vendorOwnerName,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'owner'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address / Location',
                    value: state.vendorAddress,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'address'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.badge_outlined,
                    label: 'GSTIN / License No.',
                    value: state.vendorGstin,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'gstin'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: state.vendorPhone,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'phone'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: state.vendorEmail,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'email'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.category_outlined,
                    label: 'Business Type',
                    value: state.vendorBusinessType,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'type'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.access_time_rounded,
                    label: 'Operating Hours',
                    value: state.vendorOperatingHours,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditVendorModal(context, state, focusField: 'hours'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. NOTIFICATIONS, SUPPORT & UTILITIES MENU
            Container(
              decoration: BoxDecoration(
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
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.notifications_active_outlined, color: primaryColor, size: 20),
                      ),
                      title: const Text('Notifications & Alerts', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const Text('Wholesale deals, order status & reports', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                      onTap: () => NotificationsModal.show(context, UserRole.vendor),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.aiAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.help_center_outlined, color: AppColors.aiAccent, size: 20),
                      ),
                      title: const Text('Partner Support & FAQs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const Text('Procurement guidelines, invoicing & policies', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                      onTap: () => SupportFaqModal.show(context, UserRole.vendor),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.support_agent_rounded, color: AppColors.success, size: 20),
                      ),
                      title: const Text('Call Assistance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const Text('24/7 priority partner hotline & callback', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                      onTap: () => CallAssistanceModal.show(context, UserRole.vendor),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.verified_user_outlined, color: AppColors.info, size: 20),
                      ),
                      title: const Text('Verification & Store Documents', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      subtitle: const Text('GSTIN certificate, APMC license & KYC', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                      onTap: () => VerificationDocumentsModal.show(context, UserRole.vendor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 5. LOG OUT ACTION
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.critical.withOpacity(0.25)),
              ),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.critical.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.logout_rounded, color: AppColors.critical, size: 20),
                  ),
                  title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.critical)),
                  subtitle: const Text('Sign out of FreshBuy Vendor portal', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.critical),
                  onTap: () {
                    AuthService.instance.signOut();
                    state.signOutUser();
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, anim, secAnim) => const FoodresQWelcomeScreen(),
                        transitionsBuilder: (context, anim, secAnim, child) {
                          return FadeTransition(opacity: anim, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      ),
                      (route) => false,
                    );
                  },
                ),
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

  // EDIT VENDOR PROFILE MODAL (FORM WITH SAVE & CANCEL)
  void _showEditVendorModal(BuildContext context, AppState state, {String? focusField}) {
    final nameCtrl = TextEditingController(text: state.vendorBusinessName);
    final ownerCtrl = TextEditingController(text: state.vendorOwnerName);
    final addressCtrl = TextEditingController(text: state.vendorAddress);
    final gstinCtrl = TextEditingController(text: state.vendorGstin);
    final phoneCtrl = TextEditingController(text: state.vendorPhone);
    final emailCtrl = TextEditingController(text: state.vendorEmail);
    final typeCtrl = TextEditingController(text: state.vendorBusinessType);
    final hoursCtrl = TextEditingController(text: state.vendorOperatingHours);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.edit_note_rounded, color: AppColors.vendorPrimary, size: 26),
            SizedBox(width: 8),
            Text('Edit Business Details', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
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
                  decoration: const InputDecoration(labelText: 'Business Name', prefixIcon: Icon(Icons.business_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ownerCtrl,
                  autofocus: focusField == 'owner',
                  decoration: const InputDecoration(labelText: 'Owner Name', prefixIcon: Icon(Icons.person_outline_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressCtrl,
                  autofocus: focusField == 'address',
                  decoration: const InputDecoration(labelText: 'Address / Market Location', prefixIcon: Icon(Icons.location_on_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: gstinCtrl,
                  autofocus: focusField == 'gstin',
                  decoration: const InputDecoration(labelText: 'GSTIN / Trade License No.', prefixIcon: Icon(Icons.badge_outlined, size: 18)),
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
                  controller: typeCtrl,
                  autofocus: focusField == 'type',
                  decoration: const InputDecoration(labelText: 'Business Type', prefixIcon: Icon(Icons.category_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hoursCtrl,
                  autofocus: focusField == 'hours',
                  decoration: const InputDecoration(labelText: 'Operating Hours', prefixIcon: Icon(Icons.access_time_rounded, size: 18)),
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
              state.updateVendorProfile(
                businessName: nameCtrl.text.trim(),
                ownerName: ownerCtrl.text.trim(),
                address: addressCtrl.text.trim(),
                gstin: gstinCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                businessType: typeCtrl.text.trim(),
                operatingHours: hoursCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vendor profile updated successfully!'),
                  backgroundColor: AppColors.vendorPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.vendorPrimary,
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
