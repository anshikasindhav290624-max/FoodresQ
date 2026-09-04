import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import '../welcome_screen.dart';

class VendorProfileTab extends StatefulWidget {
  const VendorProfileTab({super.key});

  @override
  State<VendorProfileTab> createState() => _VendorProfileTabState();
}

class _VendorProfileTabState extends State<VendorProfileTab> {
  // Tracks which field is currently being edited: 'name', 'owner', 'location',
  // 'license', 'phone', 'email'
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

    if (fieldKey == 'name') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Business name cannot be empty');
        return;
      }
      state.updateVendorProfile(name: text);
    } else if (fieldKey == 'owner') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Owner name cannot be empty');
        return;
      }
      state.updateVendorProfile(ownerName: text);
    } else if (fieldKey == 'location') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Location / Address cannot be empty');
        return;
      }
      state.updateVendorProfile(location: text);
    } else if (fieldKey == 'license') {
      if (text.isEmpty) {
        setState(() => _errorText = 'License / GSTIN number cannot be empty');
        return;
      }
      state.updateVendorProfile(licenseNumber: text);
    } else if (fieldKey == 'phone') {
      final cleanPhone = text.replaceAll(RegExp(r'\D'), '');
      if (text.isEmpty || cleanPhone.length < 10) {
        setState(() => _errorText = 'Please enter a valid 10-digit phone number');
        return;
      }
      state.updateVendorProfile(phone: text);
    } else if (fieldKey == 'email') {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (text.isEmpty || !emailRegex.hasMatch(text)) {
        setState(() => _errorText = 'Please enter a valid email address');
        return;
      }
      state.updateVendorProfile(email: text);
    }

    _cancelEditing();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Profile updated successfully!'),
          ],
        ),
        backgroundColor: AppColors.vendorPrimary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    return SubtleBackgroundAnimation(
      role: UserRole.vendor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                  // Cover Image
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AppImage(
                              url: AppImage.vendorWholesale,
                              borderRadius: 0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.vendorPrimary.withValues(alpha: 0.65),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.storefront_rounded, color: Colors.white, size: 13),
                                  SizedBox(width: 4),
                                  Text(
                                    'Vendor Account',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Avatar + Name
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: AppImage(
                                  url: AppImage.vendorWholesale,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.vendorPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.store_rounded, color: Colors.white, size: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.vendorName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Owner: ${state.vendorOwnerName}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              Text(
                                state.vendorLocation,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // VENDOR STATS SUMMARY CARD
            // ─────────────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Row(
                children: [
                  _buildStatBubble('₹${state.vendorMoneySaved.toStringAsFixed(0)}', 'Saved', AppColors.success),
                  _buildDivider(),
                  _buildStatBubble('${state.vendorOrdersCount}', 'Orders', AppColors.vendorPrimary),
                  _buildDivider(),
                  _buildStatBubble('${state.discountOffers.length}', 'Deals', AppColors.warning),
                  _buildDivider(),
                  _buildStatBubble('${state.vendorNearExpiryBought}kg', 'Rescued', AppColors.info),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // DETAILED BUSINESS INFORMATION CARD (Editable)
            // ─────────────────────────────────────────────────────────────────
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
                    children: const [
                      Text(
                        'Business Information',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Icon(Icons.business_rounded, color: AppColors.vendorPrimary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildEditableDetailTile(
                    fieldKey: 'name',
                    icon: Icons.storefront_rounded,
                    label: 'Business Name',
                    value: state.vendorName,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'owner',
                    icon: Icons.person_outline_rounded,
                    label: 'Owner Name',
                    value: state.vendorOwnerName,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'location',
                    icon: Icons.location_on_outlined,
                    label: 'Address / Location',
                    value: state.vendorLocation,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'license',
                    icon: Icons.badge_outlined,
                    label: 'GSTIN / License No.',
                    value: state.vendorLicenseNumber,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'phone',
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: state.vendorPhone,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'email',
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: state.vendorEmail,
                    state: state,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────────
            // LOG OUT CARD
            // ─────────────────────────────────────────────────────────────────
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
                    title: const Text(
                      'Log Out',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.critical),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const FoodresQWelcomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBubble(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 36, color: AppColors.border);
  }

  Widget _buildEditableDetailTile({
    required String fieldKey,
    required IconData icon,
    required String label,
    required String value,
    required AppState state,
  }) {
    final isEditing = _editingField == fieldKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.vendorPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                  if (!isEditing) ...[
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ],
              ),
            ),
            if (!isEditing)
              InkWell(
                onTap: () => _startEditing(fieldKey, value),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.edit_outlined, color: AppColors.vendorPrimary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.vendorPrimary,
                        ),
                      ),
                    ],
                  ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.vendorPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.vendorPrimary, width: 2),
              ),
              errorText: _errorText,
              errorStyle: const TextStyle(color: AppColors.critical, fontSize: 11),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: _cancelEditing,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _saveField(fieldKey, state),
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  backgroundColor: AppColors.vendorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
