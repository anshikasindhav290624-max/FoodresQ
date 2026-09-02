import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
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

    return SubtleBackgroundAnimation(
      role: UserRole.ngo,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo & Profile Avatar Header Card with Photo Edit Triggers
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                children: [
                  // Cover Image with Change Cover Button
                  SizedBox(
                    height: 110,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                                colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: InkWell(
                            onTap: () => _showPhotoPickerDialog(context, state, isCover: true),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.camera_alt, color: Colors.white, size: 13),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit Cover',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Avatar & Profile Title Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar Photo with Edit Overlay
                            GestureDetector(
                              onTap: () => _showPhotoPickerDialog(context, state, isCover: false),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 3),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(34),
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
                                        color: AppColors.ngoPrimary,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                      child: const Icon(Icons.edit, color: Colors.white, size: 12),
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
                                      const Icon(Icons.verified, color: AppColors.ngoPrimary, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Reg: ${state.ngoRegNumber}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    state.ngoLocation,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Prominent Edit Profile Details Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showEditProfileDialog(context, state),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.ngoPrimary,
                              side: const BorderSide(color: AppColors.ngoPrimary, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.edit_note_rounded, size: 18),
                            label: const Text(
                              'EDIT PROFILE DETAILS',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Detailed NGO Profile Information Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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
                      const Text(
                        'NGO Organization Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      IconButton(
                        onPressed: () => _showEditProfileDialog(context, state),
                        icon: const Icon(Icons.edit_outlined, color: AppColors.ngoPrimary, size: 20),
                        tooltip: 'Edit Information',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildDetailTile(Icons.business_rounded, 'NGO Name', state.ngoName),
                  const Divider(height: 16),
                  _buildDetailTile(Icons.app_registration_rounded, 'Registration Number', state.ngoRegNumber),
                  const Divider(height: 16),
                  _buildDetailTile(Icons.location_on_outlined, 'Address / Location', state.ngoLocation),
                  const Divider(height: 16),
                  _buildDetailTile(Icons.person_outline_rounded, 'Contact Person', state.ngoContactPerson),
                  const Divider(height: 16),
                  _buildDetailTile(Icons.phone_outlined, 'Phone Number', state.ngoPhone),
                  const Divider(height: 16),
                  _buildDetailTile(Icons.email_outlined, 'Email Address', state.ngoEmail),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Trust Score Card
            TrustScoreBadge(
              trustScore: state.trustScore,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NgoTrustScoreScreen()));
              },
            ),
            const SizedBox(height: 20),

            // Settings & Log Out List
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: AppColors.critical),
                    title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.critical)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodresQWelcomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                    title: Text('Notification Preferences'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.help_outline, color: AppColors.textPrimary),
                    title: Text('Help & Support'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.ngoPrimary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  // EDIT PROFILE DETAILS DIALOG (FORM WITH SAVE & CANCEL)
  void _showEditProfileDialog(BuildContext context, AppState state) {
    final nameController = TextEditingController(text: state.ngoName);
    final regController = TextEditingController(text: state.ngoRegNumber);
    final locationController = TextEditingController(text: state.ngoLocation);
    final contactController = TextEditingController(text: state.ngoContactPerson);
    final phoneController = TextEditingController(text: state.ngoPhone);
    final emailController = TextEditingController(text: state.ngoEmail);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.edit_rounded, color: AppColors.ngoPrimary),
            SizedBox(width: 8),
            Text('Edit NGO Profile', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'NGO Name', prefixIcon: Icon(Icons.business_rounded, size: 20)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: regController,
                decoration: const InputDecoration(labelText: 'Registration Number', prefixIcon: Icon(Icons.app_registration_rounded, size: 20)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Address / Location', prefixIcon: Icon(Icons.location_on_outlined, size: 20)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact Person', prefixIcon: Icon(Icons.person_outline_rounded, size: 20)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined, size: 20)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined, size: 20)),
              ),
            ],
          ),
        ),
        actions: [
          // CANCEL BUTTON (Discards unsaved edits)
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          // SAVE BUTTON (Updates state immediately)
          ElevatedButton(
            onPressed: () {
              state.updateNgoProfile(
                name: nameController.text.trim(),
                regNumber: regController.text.trim(),
                location: locationController.text.trim(),
                contactPerson: contactController.text.trim(),
                phone: phoneController.text.trim(),
                email: emailController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('NGO Profile details updated successfully!'),
                  backgroundColor: AppColors.ngoPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ngoPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // EDIT PROFILE / COVER PHOTO PICKER DIALOG
  void _showPhotoPickerDialog(BuildContext context, AppState state, {required bool isCover}) {
    final customUrlController = TextEditingController();

    final presets = [
      AppImage.ngoCommunity,
      AppImage.foodThali,
      AppImage.restaurantKitchen,
      AppImage.vendorWholesale,
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.camera_alt_rounded, color: AppColors.ngoPrimary),
            const SizedBox(width: 8),
            Text(
              isCover ? 'Change Cover Photo' : 'Change Profile Photo',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select from preset imagery:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: presets.map((url) {
                return InkWell(
                  onTap: () {
                    if (isCover) {
                      state.updateNgoProfile(coverUrl: url);
                    } else {
                      state.updateNgoProfile(avatarUrl: url);
                    }
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${isCover ? "Cover" : "Profile"} photo updated!'),
                        backgroundColor: AppColors.ngoPrimary,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppImage(url: url, fit: BoxFit.cover),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Or enter image URL:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: customUrlController,
              decoration: const InputDecoration(
                hintText: 'https://images.unsplash.com/...',
                prefixIcon: Icon(Icons.link, size: 18),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () {
              final customUrl = customUrlController.text.trim();
              if (customUrl.isNotEmpty) {
                if (isCover) {
                  state.updateNgoProfile(coverUrl: customUrl);
                } else {
                  state.updateNgoProfile(avatarUrl: customUrl);
                }
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${isCover ? "Cover" : "Profile"} photo updated!'),
                  backgroundColor: AppColors.ngoPrimary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ngoPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Photo', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
