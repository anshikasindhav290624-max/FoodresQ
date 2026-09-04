import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

/// Reusable interactive Detail Tile for Profile cards
class ProfileDetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onEdit;
  final Color? primaryColor;

  const ProfileDetailTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onEdit,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = primaryColor ?? AppColors.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: themeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit_outlined, color: themeColor, size: 17),
              tooltip: 'Edit $label',
              onPressed: onEdit,
              splashRadius: 18,
            ),
        ],
      ),
    );
  }
}

/// Unified Photo Picker Dialog (Preset grid + Custom URL)
class PhotoPickerDialog extends StatefulWidget {
  final UserRole role;
  final bool isCover;
  final String currentUrl;
  final Function(String newUrl) onSelected;

  const PhotoPickerDialog({
    super.key,
    required this.role,
    required this.isCover,
    required this.currentUrl,
    required this.onSelected,
  });

  static void show(
    BuildContext context, {
    required UserRole role,
    required bool isCover,
    required String currentUrl,
    required Function(String newUrl) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => PhotoPickerDialog(
        role: role,
        isCover: isCover,
        currentUrl: currentUrl,
        onSelected: onSelected,
      ),
    );
  }

  @override
  State<PhotoPickerDialog> createState() => _PhotoPickerDialogState();
}

class _PhotoPickerDialogState extends State<PhotoPickerDialog> {
  late String _selectedUrl;
  late TextEditingController _urlCtrl;

  @override
  void initState() {
    super.initState();
    _selectedUrl = widget.currentUrl;
    _urlCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  List<String> _getPresets() {
    switch (widget.role) {
      case UserRole.vendor:
        return [
          AppImage.vendorWholesale,
          AppImage.vendorMarket,
          AppImage.groceryVeggies,
          AppImage.groceryRice,
          AppImage.groceryTomatoes,
        ];
      case UserRole.kirana:
        return [
          AppImage.kiranaStore,
          AppImage.kiranaShop,
          AppImage.groceryMilk,
          AppImage.groceryRice,
          AppImage.foodBakery,
        ];
      case UserRole.restaurant:
        return [
          AppImage.restaurantKitchen,
          AppImage.restaurantDining,
          AppImage.foodThali,
          AppImage.foodPaneer,
          AppImage.foodBiryani,
        ];
      case UserRole.ngo:
        return [
          AppImage.ngoCommunity,
          AppImage.ngoDistribution,
          AppImage.foodThali,
          AppImage.groceryVeggies,
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimaryForRole(widget.role);
    final presets = _getPresets();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.camera_alt_rounded, color: primaryColor, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            widget.isCover ? 'Update Cover Photo' : 'Update Profile Photo',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose from curated high-resolution photography:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (ctx, idx) {
                  final url = presets[idx];
                  final isCurrent = _selectedUrl == url;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedUrl = url),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCurrent ? primaryColor : Colors.grey.shade300,
                          width: isCurrent ? 3 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AppImage(url: url, fit: BoxFit.cover),
                            if (isCurrent)
                              Container(
                                color: primaryColor.withOpacity(0.35),
                                child: const Center(
                                  child: Icon(Icons.check_circle_rounded, color: Colors.white, size: 24),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Or provide a custom image web link:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlCtrl,
                      decoration: InputDecoration(
                        hintText: 'https://example.com/photo.jpg',
                        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.link_rounded, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final url = _urlCtrl.text.trim();
                      if (url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
                        setState(() => _selectedUrl = url);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Custom image preview set!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSelected(_selectedUrl);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.isCover ? "Cover" : "Profile"} image updated successfully!'),
                backgroundColor: primaryColor,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          ),
          child: const Text('Save Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

/// Interactive Notifications & Alerts Modal for any role
class NotificationsModal extends StatelessWidget {
  final UserRole role;

  const NotificationsModal({super.key, required this.role});

  static void show(BuildContext context, UserRole role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => NotificationsModal(role: role),
    );
  }

  List<Map<String, dynamic>> _getNotificationsForRole(UserRole role) {
    switch (role) {
      case UserRole.vendor:
        return [
          {
            'icon': Icons.local_offer_rounded,
            'title': 'New Wholesale Deal: 40L Milk Packs (30% off)',
            'desc': 'Sharma General Store listed near-expiry fresh dairy inventory.',
            'time': '10 mins ago',
            'unread': true,
            'color': AppColors.vendorPrimary,
          },
          {
            'icon': Icons.check_circle_outline_rounded,
            'title': 'Order #FB-9021 Confirmed',
            'desc': '18kg Bakery buns verified & ready for pickup at Koramangala store.',
            'time': '1 hour ago',
            'unread': true,
            'color': AppColors.success,
          },
          {
            'icon': Icons.savings_outlined,
            'title': 'Procurement Savings Report Ready',
            'desc': 'You saved ₹1,820 this week across 5 discounted purchases.',
            'time': 'Yesterday',
            'unread': false,
            'color': AppColors.warning,
          },
          {
            'icon': Icons.verified_user_outlined,
            'title': 'GST Invoicing Verified',
            'desc': 'All input tax credit receipts for August have been reconciled.',
            'time': '3 days ago',
            'unread': false,
            'color': AppColors.info,
          },
        ];
      case UserRole.kirana:
        return [
          {
            'icon': Icons.auto_awesome,
            'title': 'AI Near-Expiry Alert',
            'desc': '12 Dairy packs expire in 48h. Recommended discount: 30% for instant vendor clearance.',
            'time': '25 mins ago',
            'unread': true,
            'color': AppColors.aiAccent,
          },
          {
            'icon': Icons.monetization_on_outlined,
            'title': 'Offer Claimed by FreshBuy Traders',
            'desc': 'Full Cream Milk Packs (12 qty) purchased. ₹252 added to your recovery wallet.',
            'time': '2 hours ago',
            'unread': true,
            'color': AppColors.kiranaPrimary,
          },
          {
            'icon': Icons.analytics_outlined,
            'title': 'Monthly Kirana Recovery Target: 88%',
            'desc': 'You have recovered ₹12,800 out of ₹14,500 at-risk inventory this month.',
            'time': 'Yesterday',
            'unread': false,
            'color': AppColors.success,
          },
        ];
      case UserRole.restaurant:
        return [
          {
            'icon': Icons.volunteer_activism_rounded,
            'title': 'Surplus Claimed by Helping Hands NGO',
            'desc': '35 North Indian meals assigned for pickup within 30 minutes.',
            'time': '15 mins ago',
            'unread': true,
            'color': AppColors.restaurantPrimary,
          },
          {
            'icon': Icons.timer_outlined,
            'title': 'Acceptance Cascade Finished',
            'desc': 'SUR-101 accepted in 3m 42s. Zero food waste penalty applied.',
            'time': '2 hours ago',
            'unread': true,
            'color': AppColors.success,
          },
          {
            'icon': Icons.card_giftcard_rounded,
            'title': 'FoodResQ Green Partner Badge Renewed',
            'desc': '248 successful meal donations recorded on your public ESG score.',
            'time': 'Yesterday',
            'unread': false,
            'color': AppColors.aiAccent,
          },
        ];
      case UserRole.ngo:
        return [
          {
            'icon': Icons.fastfood_rounded,
            'title': 'Urgent Surplus Available: 35 Meals',
            'desc': 'Urban Tadka (Koramangala) prepared hot meal containers ready for pickup.',
            'time': '5 mins ago',
            'unread': true,
            'color': AppColors.ngoPrimary,
          },
          {
            'icon': Icons.security_rounded,
            'title': 'Trust Score Increased to 88/100',
            'desc': '+2 points awarded for on-time verification & verified meal distribution.',
            'time': '3 hours ago',
            'unread': true,
            'color': AppColors.success,
          },
          {
            'icon': Icons.route_rounded,
            'title': 'Optimized Pickup Route Generated',
            'desc': 'AI clustered 2 donor pickups within 2.1km radius to save volunteer transit time.',
            'time': 'Yesterday',
            'unread': false,
            'color': AppColors.info,
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimaryForRole(role);
    final notifs = _getNotificationsForRole(role);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Top drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications_active_rounded, color: primaryColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Notifications & Alerts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read.')),
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Mark all read', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (ctx, idx) {
                final item = notifs[idx];
                final color = item['color'] as Color;
                final isUnread = item['unread'] as bool;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUnread ? color.withOpacity(0.04) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: isUnread ? Border.all(color: color.withOpacity(0.2)) : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['title'] as String,
                                    style: TextStyle(
                                      fontWeight: isUnread ? FontWeight.w900 : FontWeight.w700,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  item['time'] as String,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['desc'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive Partner Support & FAQs Modal
class SupportFaqModal extends StatelessWidget {
  final UserRole role;

  const SupportFaqModal({super.key, required this.role});

  static void show(BuildContext context, UserRole role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SupportFaqModal(role: role),
    );
  }

  List<Map<String, String>> _getFaqsForRole(UserRole role) {
    switch (role) {
      case UserRole.vendor:
        return [
          {
            'q': 'How does discounted near-expiry procurement work?',
            'a': 'Local Kirana stores and distributors list verified at-risk items 48-72 hours prior to expiration with 30-50% AI-recommended discounts. You can claim bulk or fractional lots with instant digital receipts.',
          },
          {
            'q': 'How are invoices and GST tax credits handled?',
            'a': 'Every purchase automatically generates a compliant B2B tax invoice with matching GSTIN details, ensuring full Input Tax Credit (ITC) eligibility.',
          },
          {
            'q': 'What happens if products delivered do not match description?',
            'a': 'FoodResQ offers a 100% Quality Assurance guarantee. If goods are damaged or expired upon pickup, submit a dispute photo within 4 hours for an immediate refund.',
          },
          {
            'q': 'Can I schedule daily automated procurement?',
            'a': 'Yes! Under Buying Preferences, set category thresholds (e.g., Dairy, Grains, Oils) and receive instant push notifications when matching stock is listed.',
          },
        ];
      case UserRole.kirana:
        return [
          {
            'q': 'How does FoodResQ calculate AI discount pricing?',
            'a': 'Our algorithm evaluates product category, historical sales velocity, days until expiration, and local vendor demand to suggest the optimal discount (usually 25%–40%) to liquidate stock before expiry.',
          },
          {
            'q': 'When do vendor buyers pick up purchased stock?',
            'a': 'Vendors are assigned a 2-hour pickup slot upon order confirmation. They present a verification OTP at your counter before handing over goods.',
          },
          {
            'q': 'How are payouts processed for recovered inventory?',
            'a': 'All revenue recovered is credited to your registered bank account via UPI/IMPS every evening by 8:00 PM.',
          },
        ];
      case UserRole.restaurant:
        return [
          {
            'q': 'What is the 8-Minute Acceptance Cascade?',
            'a': 'When you post freshly prepared surplus meals, verified partner NGOs within 5km have an 8-minute priority window to accept the batch. If unaccepted, it cascades to secondary relief shelters.',
          },
          {
            'q': 'Are food donors protected from liability?',
            'a': 'Yes. Under the Good Samaritan Food Donation Guidelines, registered donors adhering to basic temperature and hygiene standards are fully protected.',
          },
          {
            'q': 'How do I download monthly ESG and Tax Exemption certificates?',
            'a': 'Your monthly donation statement includes 80G tax benefit acknowledgments and CO₂ emissions mitigation metrics ready for corporate reporting.',
          },
        ];
      case UserRole.ngo:
        return [
          {
            'q': 'How can our NGO increase our Trust Score?',
            'a': 'Maintain on-time surplus collections, promptly verify distributions with geo-tagged receipts, and keep active requirement signals updated daily.',
          },
          {
            'q': 'What safety standards apply to collected prepared meals?',
            'a': 'All surplus prepared food must be transported in covered temperature-insulated containers and distributed within 3 hours of collection.',
          },
          {
            'q': 'How do we coordinate volunteer vehicles for large batches?',
            'a': 'FoodResQ provides automated volunteer route clustering and real-time transit ETA tracking directly inside the Pickup Tracking dashboard.',
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimaryForRole(role);
    final faqs = _getFaqsForRole(role);

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.help_center_rounded, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Partner Support & FAQs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faqs.length,
              itemBuilder: (ctx, idx) {
                final faq = faqs[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    iconColor: primaryColor,
                    collapsedIconColor: AppColors.textSecondary,
                    title: Text(
                      faq['q']!,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq['a']!,
                          style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Interactive Call Assistance & Callback Request Modal
class CallAssistanceModal extends StatefulWidget {
  final UserRole role;

  const CallAssistanceModal({super.key, required this.role});

  static void show(BuildContext context, UserRole role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CallAssistanceModal(role: role),
    );
  }

  @override
  State<CallAssistanceModal> createState() => _CallAssistanceModalState();
}

class _CallAssistanceModalState extends State<CallAssistanceModal> {
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController(text: 'General account & operations support');
  bool _submitting = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    final primaryColor = AppColors.getPrimaryForRole(widget.role);
    final roleTitle = AppColors.getRoleTitle(widget.role);

    // Pre-fill phone from state if empty
    if (_phoneCtrl.text.isEmpty) {
      switch (widget.role) {
        case UserRole.vendor:
          _phoneCtrl.text = state.vendorPhone;
          break;
        case UserRole.kirana:
          _phoneCtrl.text = state.kiranaPhone;
          break;
        case UserRole.restaurant:
          _phoneCtrl.text = state.restaurantPhone;
          break;
        case UserRole.ngo:
          _phoneCtrl.text = state.ngoPhone;
          break;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone_in_talk_rounded, color: primaryColor, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FoodResQ Partner Helpline', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                    Text('Priority 24/7 Desk for $roleTitle Partners', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Direct Toll-Free Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.headset_mic_rounded, color: primaryColor, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Toll-Free Helpline', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                        Text('1800-889-FOOD (3663)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Dialing FoodResQ Helpline 1800-889-3663...'),
                          backgroundColor: primaryColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    icon: const Icon(Icons.call, color: Colors.white, size: 16),
                    label: const Text('Call Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('Request Immediate Callback:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Callback Phone Number',
                prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subjectCtrl,
              decoration: InputDecoration(
                labelText: 'Topic / Query Subject',
                prefixIcon: const Icon(Icons.topic_outlined, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting
                    ? null
                    : () {
                        setState(() => _submitting = true);
                        final phone = _phoneCtrl.text.trim();
                        final subject = _subjectCtrl.text.trim();

                        state.requestSupportCallback(
                          requesterName: roleTitle,
                          phone: phone.isEmpty ? '+91 Partner' : phone,
                          roleTitle: roleTitle,
                          subject: subject.isEmpty ? 'Priority Query' : subject,
                        );

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Callback requested! Our partner specialist will call you at $phone shortly.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Request Urgent Callback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive Verification & Documents Center Modal
class VerificationDocumentsModal extends StatelessWidget {
  final UserRole role;

  const VerificationDocumentsModal({super.key, required this.role});

  static void show(BuildContext context, UserRole role) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => VerificationDocumentsModal(role: role),
    );
  }

  List<Map<String, String>> _getDocsForRole(UserRole role) {
    switch (role) {
      case UserRole.vendor:
        return [
          {'title': 'GSTIN Registration Certificate', 'id': '29AAAAA0000A1Z5', 'status': 'Active & Verified', 'validUntil': '31-Dec-2027'},
          {'title': 'APMC Wholesale Trade License', 'id': 'APMC-BLR-8841-W', 'status': 'Verified', 'validUntil': '15-Mar-2028'},
          {'title': 'Bank Account & Pan Verification', 'id': 'PAN: AAAP9821C', 'status': 'KYC Approved', 'validUntil': 'Lifetime'},
        ];
      case UserRole.kirana:
        return [
          {'title': 'Shop & Commercial Establishment Act', 'id': 'KA-BLR-KIR-2023-4109', 'status': 'Active & Verified', 'validUntil': '30-Jun-2027'},
          {'title': 'FSSAI Basic Retail Registration', 'id': '21223004001928', 'status': 'Verified', 'validUntil': '12-Oct-2028'},
          {'title': 'Local Trade Municipal Permit', 'id': 'BBMP-IND-6612', 'status': 'Renewed', 'validUntil': '31-Mar-2027'},
        ];
      case UserRole.restaurant:
        return [
          {'title': 'FSSAI State Food License', 'id': '11223344556677', 'status': 'Active & Verified', 'validUntil': '24-Nov-2027'},
          {'title': 'BBMP Health & Sanitation Trade License', 'id': 'BBMP-HLTH-9941', 'status': 'Verified', 'validUntil': '31-Dec-2027'},
          {'title': 'Fire & Life Safety Clearance NOC', 'id': 'NOC-FS-BLR-401', 'status': 'Compliant', 'validUntil': '18-Aug-2028'},
        ];
      case UserRole.ngo:
        return [
          {'title': 'NITI Aayog NGO Darpan Registration', 'id': 'NGO-KAR-2024-8849', 'status': 'Active & Verified', 'validUntil': 'Perpetual'},
          {'title': 'Section 80G Tax Exemption Certificate', 'id': 'CIT-BLR-80G-1029', 'status': 'Verified', 'validUntil': '31-Mar-2029'},
          {'title': 'Trust Registration & MoA Document', 'id': 'DOC-TR-2018-091', 'status': 'KYC Verified', 'validUntil': 'Perpetual'},
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimaryForRole(role);
    final docs = _getDocsForRole(role);

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 44,
            height: 5,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.verified_user_rounded, color: primaryColor, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Verification & Store Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (ctx, idx) {
                final doc = docs[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description_rounded, color: AppColors.success, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['title']!,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 2),
                            Text('ID: ${doc['id']!}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            Text('Valid until: ${doc['validUntil']!}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'VERIFIED',
                              style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w900, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document upload portal opened. Select PDF/Image certificate.')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.upload_file_rounded, size: 18),
                label: const Text('Upload Renewed Certificate', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
