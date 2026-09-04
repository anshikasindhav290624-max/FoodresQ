import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/profile_support_widgets.dart';
import '../../widgets/subtle_background_animation.dart';
import '../../widgets/trust_score_badge.dart';
import '../welcome_screen.dart';
import 'ngo_trust_score_screen.dart';

class NgoProfileTab extends StatefulWidget {
  const NgoProfileTab({super.key});

  @override
  State<NgoProfileTab> createState() => _NgoProfileTabState();
}

class _NgoProfileTabState extends State<NgoProfileTab> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    const primaryColor = AppColors.ngoPrimary;

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
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
                              url: state.ngoCoverUrl,
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
                              role: UserRole.ngo,
                              isCover: true,
                              currentUrl: state.ngoCoverUrl,
                              onSelected: (url) => state.updateNgoProfile(coverUrl: url),
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
                                role: UserRole.ngo,
                                isCover: false,
                                currentUrl: state.ngoAvatarUrl,
                                onSelected: (url) => state.updateNgoProfile(avatarUrl: url),
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
                                        url: state.ngoAvatarUrl,
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
                                          state.ngoName,
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
                                    'Reg: ${state.ngoRegNumber}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    state.ngoLocation,
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
                            onPressed: () => _showEditNgoModal(context, state),
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

            // 2. QUICK IMPACT STATS ROW (Preserved NGO data)
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
                  _buildQuickStat('${state.totalMealsSaved}', 'Meals Saved', primaryColor),
                  _buildStatDivider(),
                  _buildQuickStat('${state.peopleServed}', 'People Fed', AppColors.success),
                  _buildStatDivider(),
                  _buildQuickStat('${state.foodDivertedKg.toStringAsFixed(0)} kg', 'Diverted', AppColors.warning),
                  _buildStatDivider(),
                  _buildQuickStat('${state.successfulPickups}', 'Pickups Done', const Color(0xFF4F46A5)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. NGO ORGANIZATION DETAILS CARD (With individual row edit actions)
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
                          Icon(Icons.volunteer_activism_rounded, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'NGO Organization Details',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _showEditNgoModal(context, state),
                        icon: const Icon(Icons.edit_outlined, color: primaryColor, size: 20),
                        tooltip: 'Edit All Information',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ProfileDetailTile(
                    icon: Icons.business_rounded,
                    label: 'NGO Name',
                    value: state.ngoName,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'name'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.app_registration_rounded,
                    label: 'Registration Number',
                    value: state.ngoRegNumber,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'regNumber'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'Address / Location',
                    value: state.ngoLocation,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'location'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Contact Person / Coordinator',
                    value: state.ngoContactPerson,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'contactPerson'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: state.ngoPhone,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'phone'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: state.ngoEmail,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'email'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.map_outlined,
                    label: 'Service Area / Coverage',
                    value: state.ngoServiceArea,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'serviceArea'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.groups_rounded,
                    label: 'Beneficiary Capacity',
                    value: state.ngoBeneficiaryCapacity,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'capacity'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.local_shipping_outlined,
                    label: 'Food Pickup Availability',
                    value: state.ngoPickupAvailability,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'pickup'),
                  ),
                  const Divider(height: 12),
                  ProfileDetailTile(
                    icon: Icons.access_time_rounded,
                    label: 'Operating Hours',
                    value: state.ngoOperatingHours,
                    primaryColor: primaryColor,
                    onEdit: () => _showEditNgoModal(context, state, focusField: 'hours'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. TRUST SCORE CARD
            TrustScoreBadge(
              trustScore: state.trustScore,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NgoTrustScoreScreen()));
              },
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
                    subtitle: const Text('Surplus signals, rescue alarms & route clusters', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => NotificationsModal.show(context, UserRole.ngo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.verified_user_outlined, color: AppColors.success, size: 20),
                    ),
                    title: const Text('Verification & Trust Documents', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('NGO Darpan registration, 80G tax certificate, Trust Deed', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => VerificationDocumentsModal.show(context, UserRole.ngo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.aiAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.help_center_outlined, color: AppColors.aiAccent, size: 20),
                    ),
                    title: const Text('Partner Support & FAQs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('Meal claim standards, cold-chain guidelines & ratings', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => SupportFaqModal.show(context, UserRole.ngo),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.support_agent_rounded, color: AppColors.info, size: 20),
                    ),
                    title: const Text('Call Assistance', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    subtitle: const Text('24/7 priority NGO dispatch desk & callback', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: AppColors.textSecondary),
                    onTap: () => CallAssistanceModal.show(context, UserRole.ngo),
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
                subtitle: const Text('Sign out of Helping Hands NGO portal', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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

  // EDIT NGO PROFILE MODAL
  void _showEditNgoModal(BuildContext context, AppState state, {String? focusField}) {
    final nameCtrl = TextEditingController(text: state.ngoName);
    final regCtrl = TextEditingController(text: state.ngoRegNumber);
    final locationCtrl = TextEditingController(text: state.ngoLocation);
    final contactCtrl = TextEditingController(text: state.ngoContactPerson);
    final phoneCtrl = TextEditingController(text: state.ngoPhone);
    final emailCtrl = TextEditingController(text: state.ngoEmail);
    final areaCtrl = TextEditingController(text: state.ngoServiceArea);
    final capacityCtrl = TextEditingController(text: state.ngoBeneficiaryCapacity);
    final pickupCtrl = TextEditingController(text: state.ngoPickupAvailability);
    final hoursCtrl = TextEditingController(text: state.ngoOperatingHours);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: const [
            Icon(Icons.edit_note_rounded, color: AppColors.ngoPrimary, size: 26),
            SizedBox(width: 8),
            Text('Edit NGO Profile', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
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
                  decoration: const InputDecoration(labelText: 'NGO Name', prefixIcon: Icon(Icons.business_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: regCtrl,
                  autofocus: focusField == 'regNumber',
                  decoration: const InputDecoration(labelText: 'Registration Number', prefixIcon: Icon(Icons.app_registration_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationCtrl,
                  autofocus: focusField == 'location',
                  decoration: const InputDecoration(labelText: 'Address / Location', prefixIcon: Icon(Icons.location_on_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactCtrl,
                  autofocus: focusField == 'contactPerson',
                  decoration: const InputDecoration(labelText: 'Contact Person / Coordinator', prefixIcon: Icon(Icons.person_outline_rounded, size: 18)),
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
                  controller: areaCtrl,
                  autofocus: focusField == 'serviceArea',
                  decoration: const InputDecoration(labelText: 'Service Area / Coverage', prefixIcon: Icon(Icons.map_outlined, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: capacityCtrl,
                  autofocus: focusField == 'capacity',
                  decoration: const InputDecoration(labelText: 'Beneficiary Capacity', prefixIcon: Icon(Icons.groups_rounded, size: 18)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: pickupCtrl,
                  autofocus: focusField == 'pickup',
                  decoration: const InputDecoration(labelText: 'Pickup Availability', prefixIcon: Icon(Icons.local_shipping_outlined, size: 18)),
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
              state.updateNgoProfile(
                name: nameCtrl.text.trim(),
                regNumber: regCtrl.text.trim(),
                location: locationCtrl.text.trim(),
                contactPerson: contactCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                serviceArea: areaCtrl.text.trim(),
                beneficiaryCapacity: capacityCtrl.text.trim(),
                pickupAvailability: pickupCtrl.text.trim(),
                operatingHours: hoursCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('NGO profile updated successfully!'),
                  backgroundColor: AppColors.ngoPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ngoPrimary,
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
