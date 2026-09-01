import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'ngo/ngo_main_screen.dart';
import 'restaurant/restaurant_main_screen.dart';
import 'vendor/vendor_main_screen.dart';
import 'kirana/kirana_main_screen.dart';

class AuthScreen extends StatefulWidget {
  final UserRole role;

  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  int _currentStep = 1;
  final int _totalSteps = 4;

  // Controller Fields
  final _orgNameCtrl = TextEditingController(text: 'Helping Hands Foundation');
  final _contactPersonCtrl = TextEditingController(text: 'Ramesh Kumar');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');
  final _emailCtrl = TextEditingController(text: 'contact@helpinghands.org');
  final _regNumCtrl = TextEditingController(text: 'NGO-KAR-2024-8849');
  final _capacityCtrl = TextEditingController(text: '250');
  final _addressCtrl = TextEditingController(text: '12th Cross, Koramangala 5th Block, Bengaluru');

  @override
  void initState() {
    super.initState();
    _initRoleDefaults();
  }

  void _initRoleDefaults() {
    switch (widget.role) {
      case UserRole.ngo:
        _orgNameCtrl.text = 'Helping Hands Foundation';
        break;
      case UserRole.restaurant:
        _orgNameCtrl.text = 'Urban Tadka Restaurant';
        break;
      case UserRole.vendor:
        _orgNameCtrl.text = 'FreshBuy Wholesale Traders';
        break;
      case UserRole.kirana:
        _orgNameCtrl.text = 'Sharma General Store';
        break;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeAuth();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeAuth() {
    final state = Provider.of<AppState>(context, listen: false);
    state.setRole(widget.role);

    Widget targetScreen;
    switch (widget.role) {
      case UserRole.ngo:
        targetScreen = const NgoMainScreen();
        break;
      case UserRole.restaurant:
        targetScreen = const RestaurantMainScreen();
        break;
      case UserRole.vendor:
        targetScreen = const VendorMainScreen();
        break;
      case UserRole.kirana:
        targetScreen = const KiranaMainScreen();
        break;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => targetScreen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = AppColors.getPrimaryForRole(widget.role);
    final title = AppColors.getRoleTitle(widget.role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('$title Registration'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 1) {
              _prevStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Multi-step Progress Indicator
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'STEP $_currentStep OF $_totalSteps',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: roleColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        _getStepTitle(_currentStep),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _currentStep / _totalSteps,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(roleColor),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepContent(),
                  ],
                ),
              ),
            ),
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _prevStep,
                        child: const Text('BACK'),
                      ),
                    ),
                  if (_currentStep > 1) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(backgroundColor: roleColor),
                      child: Text(_currentStep == _totalSteps ? 'COMPLETE & ENTER APP' : 'CONTINUE →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Basic Details';
      case 2:
        return 'Capacity & Preferences';
      case 3:
        return 'Location & Operational Area';
      case 4:
        return 'Verification Documents';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    final roleColor = AppColors.getPrimaryForRole(widget.role);

    if (_currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Step 1: Organization Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(
            controller: _orgNameCtrl,
            decoration: const InputDecoration(labelText: 'Organization / Business Name'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _contactPersonCtrl,
            decoration: const InputDecoration(labelText: 'Primary Contact Person'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Mobile Number (+91)'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Official Email Address'),
          ),
        ],
      );
    } else if (_currentStep == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Step 2: Operational Capacity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(
            controller: _regNumCtrl,
            decoration: const InputDecoration(labelText: 'Registration / License Number'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _capacityCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Max Capacity (Meals / Products / Day)'),
          ),
          const SizedBox(height: 16),
          const Text('Primary Category Focus:', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(label: const Text('Prepared Meals'), selected: true, onSelected: (v) {}, selectedColor: roleColor.withOpacity(0.2)),
              FilterChip(label: const Text('Packaged Groceries'), selected: true, onSelected: (v) {}, selectedColor: roleColor.withOpacity(0.2)),
              FilterChip(label: const Text('Fresh Vegetables'), selected: true, onSelected: (v) {}, selectedColor: roleColor.withOpacity(0.2)),
              FilterChip(label: const Text('Dairy Items'), selected: false, onSelected: (v) {}),
            ],
          ),
        ],
      );
    } else if (_currentStep == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Step 3: Service Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          TextField(
            controller: _addressCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Full Address'),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: roleColor, size: 36),
                      const SizedBox(height: 4),
                      const Text('Koramangala 5th Block, Bengaluru', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Service Radius: 8.5 km', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Step 4: Government Verification', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Text('Upload registration certificate or FSSAI license for platform verification.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.success.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: AppColors.success, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('VERIFICATION STATUS: PRE-VERIFIED', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.success, fontSize: 12)),
                      SizedBox(height: 2),
                      Text('Document: NGO_REG_CERT_2024.pdf (Attached)', style: TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
