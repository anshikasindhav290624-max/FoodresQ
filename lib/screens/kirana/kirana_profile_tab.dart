import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_image.dart';
import '../../widgets/subtle_background_animation.dart';
import '../welcome_screen.dart';

class KiranaProfileTab extends StatefulWidget {
  const KiranaProfileTab({super.key});

  @override
  State<KiranaProfileTab> createState() => _KiranaProfileTabState();
}

class _KiranaProfileTabState extends State<KiranaProfileTab> {
  String? _editingField; // 'name', 'owner', 'location', 'regNumber', 'phone', 'email'
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
        setState(() => _errorText = 'Store name cannot be empty');
        return;
      }
      state.updateKiranaProfile(name: text);
    } else if (fieldKey == 'owner') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Owner name cannot be empty');
        return;
      }
      state.updateKiranaProfile(ownerName: text);
    } else if (fieldKey == 'location') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Location / Address cannot be empty');
        return;
      }
      state.updateKiranaProfile(location: text);
    } else if (fieldKey == 'regNumber') {
      if (text.isEmpty) {
        setState(() => _errorText = 'Registration number cannot be empty');
        return;
      }
      state.updateKiranaProfile(regNumber: text);
    } else if (fieldKey == 'phone') {
      final cleanPhone = text.replaceAll(RegExp(r'\D'), '');
      if (text.isEmpty || cleanPhone.length < 10) {
        setState(() => _errorText = 'Please enter a valid 10-digit phone number');
        return;
      }
      state.updateKiranaProfile(phone: text);
    } else if (fieldKey == 'email') {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (text.isEmpty || !emailRegex.hasMatch(text)) {
        setState(() => _errorText = 'Please enter a valid email address');
        return;
      }
      state.updateKiranaProfile(email: text);
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
        backgroundColor: AppColors.kiranaPrimary,
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
      role: UserRole.kirana,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover & Profile Avatar Header Card
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
                  // Cover Image with Edit Cover trigger
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: AppImage(
                              url: state.kiranaCoverUrl,
                              borderRadius: 0,
                              fit: BoxFit.cover,
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar Stack with Camera Edit Badge
                        GestureDetector(
                          onTap: () => _showPhotoPickerDialog(context, state, isCover: false),
                          child: Stack(
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
                                    url: state.kiranaAvatarUrl,
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
                                    color: AppColors.kiranaPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 12),
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
                              Text(
                                state.kiranaName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Owner: ${state.kiranaOwnerName}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              Text(
                                state.kiranaLocation,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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

            // Detailed Store Information Card with Inline Editors
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
                        'Store Information',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Icon(Icons.storefront_rounded, color: AppColors.kiranaPrimary, size: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildEditableDetailTile(
                    fieldKey: 'name',
                    icon: Icons.business_rounded,
                    label: 'Store Name',
                    value: state.kiranaName,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'owner',
                    icon: Icons.person_outline_rounded,
                    label: 'Owner Name',
                    value: state.kiranaOwnerName,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'location',
                    icon: Icons.location_on_outlined,
                    label: 'Address / Location',
                    value: state.kiranaLocation,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'regNumber',
                    icon: Icons.app_registration_rounded,
                    label: 'Registration / License No.',
                    value: state.kiranaRegNumber,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'phone',
                    icon: Icons.phone_outlined,
                    label: 'Phone Number',
                    value: state.kiranaPhone,
                    state: state,
                  ),
                  const Divider(height: 20),
                  _buildEditableDetailTile(
                    fieldKey: 'email',
                    icon: Icons.email_outlined,
                    label: 'Email Address',
                    value: state.kiranaEmail,
                    state: state,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Log Out Button Container
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            Icon(icon, color: AppColors.kiranaPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                  if (!isEditing) ...[
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                      Icon(Icons.edit_outlined, color: AppColors.kiranaPrimary, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kiranaPrimary,
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
                borderSide: const BorderSide(color: AppColors.kiranaPrimary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.kiranaPrimary, width: 2),
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
                  backgroundColor: AppColors.kiranaPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _showPhotoPickerDialog(BuildContext context, AppState state, {required bool isCover}) {
    String selectedUrl = isCover ? state.kiranaCoverUrl : state.kiranaAvatarUrl;
    final customUrlController = TextEditingController(text: selectedUrl);

    final presets = [
      AppImage.kiranaStore,
      AppImage.vendorWholesale,
      AppImage.foodThali,
      AppImage.restaurantKitchen,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.camera_alt_rounded, color: AppColors.kiranaPrimary),
                const SizedBox(width: 8),
                Text(
                  isCover ? 'Change Cover Photo' : 'Change Profile Photo',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preview:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: isCover ? 220 : 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isCover ? 12 : 40),
                        border: Border.all(color: AppColors.kiranaPrimary, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(isCover ? 10 : 38),
                        child: AppImage(url: selectedUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select from presets:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: presets.map((url) {
                      final isSelected = selectedUrl == url;
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedUrl = url;
                            customUrlController.text = url;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.kiranaPrimary : AppColors.border,
                              width: isSelected ? 2.5 : 1,
                            ),
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
                    'Or enter custom image URL:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: customUrlController,
                    onChanged: (val) {
                      setDialogState(() {
                        selectedUrl = val.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'https://images.unsplash.com/...',
                      prefixIcon: const Icon(Icons.link, size: 18),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  final finalUrl = customUrlController.text.trim();
                  if (finalUrl.isNotEmpty) {
                    if (isCover) {
                      state.updateKiranaProfile(coverUrl: finalUrl);
                    } else {
                      state.updateKiranaProfile(avatarUrl: finalUrl);
                    }
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${isCover ? "Cover" : "Profile"} photo updated successfully!'),
                      backgroundColor: AppColors.kiranaPrimary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kiranaPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Photo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }
}
