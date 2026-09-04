import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';

class AppState extends ChangeNotifier {
  UserRole _activeRole = UserRole.ngo;
  UserRole get activeRole => _activeRole;

  // NGO Requirement Signal State
  bool _ngoAcceptingFood = true;
  bool get ngoAcceptingFood => _ngoAcceptingFood;
  int _ngoCapacityPercent = 80;
  int get ngoCapacityPercent => _ngoCapacityPercent;
  int _ngoMealsRequirement = 40;
  int get ngoMealsRequirement => _ngoMealsRequirement;

  // NGO Trust Score Engine State
  final NgoTrustScore _trustScore = NgoTrustScore(
    overallScore: 88,
    trustLevel: 'TRUSTED',
    levelColor: const Color(0xFF126B68),
    collectionScore: 23,
    distributionScore: 27,
    acceptanceScore: 14,
    pickupScore: 14,
    completionScore: 9,
    verifiedImpactScore: 4,
    monthlyDelta: 2,
    recentImprovements: [
      '+2 On-Time Collection (29 Aug)',
      '+1 Verified Distribution (28 Aug)',
    ],
  );
  NgoTrustScore get trustScore => _trustScore;

  // NGO Impact Stats
  int _totalMealsSaved = 1860;
  int get totalMealsSaved => _totalMealsSaved;
  int _peopleServed = 1720;
  int get peopleServed => _peopleServed;
  double _foodDivertedKg = 380.0;
  double get foodDivertedKg => _foodDivertedKg;
  int _successfulPickups = 248;
  int get successfulPickups => _successfulPickups;

  // NGO Profile State
  String _ngoName = 'Helping Hands Foundation';
  String get ngoName => _ngoName;

  String _ngoRegNumber = 'NGO-KAR-2024-8849';
  String get ngoRegNumber => _ngoRegNumber;

  String _ngoLocation = 'Koramangala, Bengaluru';
  String get ngoLocation => _ngoLocation;

  String _ngoContactPerson = 'Rahul Sharma';
  String get ngoContactPerson => _ngoContactPerson;

  String _ngoPhone = '+91 98765 43210';
  String get ngoPhone => _ngoPhone;

  String _ngoEmail = 'contact@helpinghandsngo.org';
  String get ngoEmail => _ngoEmail;

  String _ngoServiceArea = 'East & South Bengaluru (Indiranagar, Koramangala, HSR)';
  String get ngoServiceArea => _ngoServiceArea;

  String _ngoBeneficiaryCapacity = '500+ Daily Meals Supported';
  String get ngoBeneficiaryCapacity => _ngoBeneficiaryCapacity;

  String _ngoPickupAvailability = '11:00 AM – 10:30 PM (Daily)';
  String get ngoPickupAvailability => _ngoPickupAvailability;

  String _ngoOperatingHours = '09:00 AM – 11:00 PM';
  String get ngoOperatingHours => _ngoOperatingHours;

  String _ngoAvatarUrl = AppImage.ngoCommunity;
  String get ngoAvatarUrl => _ngoAvatarUrl;

  String _ngoCoverUrl = AppImage.ngoCommunity;
  String get ngoCoverUrl => _ngoCoverUrl;

  void updateNgoProfile({
    String? name,
    String? regNumber,
    String? location,
    String? contactPerson,
    String? phone,
    String? email,
    String? serviceArea,
    String? beneficiaryCapacity,
    String? pickupAvailability,
    String? operatingHours,
    String? avatarUrl,
    String? coverUrl,
  }) {
    if (name != null && name.isNotEmpty) _ngoName = name;
    if (regNumber != null && regNumber.isNotEmpty) _ngoRegNumber = regNumber;
    if (location != null && location.isNotEmpty) _ngoLocation = location;
    if (contactPerson != null && contactPerson.isNotEmpty) _ngoContactPerson = contactPerson;
    if (phone != null && phone.isNotEmpty) _ngoPhone = phone;
    if (email != null && email.isNotEmpty) _ngoEmail = email;
    if (serviceArea != null && serviceArea.isNotEmpty) _ngoServiceArea = serviceArea;
    if (beneficiaryCapacity != null && beneficiaryCapacity.isNotEmpty) _ngoBeneficiaryCapacity = beneficiaryCapacity;
    if (pickupAvailability != null && pickupAvailability.isNotEmpty) _ngoPickupAvailability = pickupAvailability;
    if (operatingHours != null && operatingHours.isNotEmpty) _ngoOperatingHours = operatingHours;
    if (avatarUrl != null && avatarUrl.isNotEmpty) _ngoAvatarUrl = avatarUrl;
    if (coverUrl != null && coverUrl.isNotEmpty) _ngoCoverUrl = coverUrl;

    notifyListeners();
  }

  // Kirana Profile State
  String _kiranaStoreName = 'Sharma General Store';
  String get kiranaStoreName => _kiranaStoreName;

  String _kiranaOwnerName = 'Ramesh Sharma';
  String get kiranaOwnerName => _kiranaOwnerName;

  String _kiranaAddress = 'Indiranagar 100ft Rd, Bengaluru';
  String get kiranaAddress => _kiranaAddress;

  String _kiranaRegNumber = 'KA-BLR-KIR-2023-4109';
  String get kiranaRegNumber => _kiranaRegNumber;

  String _kiranaPhone = '+91 98450 12345';
  String get kiranaPhone => _kiranaPhone;

  String _kiranaEmail = 'sharma.kirana@foodresq.in';
  String get kiranaEmail => _kiranaEmail;

  String _kiranaCategory = 'Retail Grocery & Dairy';
  String get kiranaCategory => _kiranaCategory;

  String _kiranaOperatingHours = '07:30 AM – 10:00 PM';
  String get kiranaOperatingHours => _kiranaOperatingHours;

  String _kiranaAvatarUrl = AppImage.kiranaStore;
  String get kiranaAvatarUrl => _kiranaAvatarUrl;

  String _kiranaCoverUrl = AppImage.kiranaStore;
  String get kiranaCoverUrl => _kiranaCoverUrl;

  void updateKiranaProfile({
    String? storeName,
    String? ownerName,
    String? address,
    String? regNumber,
    String? phone,
    String? email,
    String? category,
    String? operatingHours,
    String? avatarUrl,
    String? coverUrl,
  }) {
    if (storeName != null && storeName.isNotEmpty) _kiranaStoreName = storeName;
    if (ownerName != null && ownerName.isNotEmpty) _kiranaOwnerName = ownerName;
    if (address != null && address.isNotEmpty) _kiranaAddress = address;
    if (regNumber != null && regNumber.isNotEmpty) _kiranaRegNumber = regNumber;
    if (phone != null && phone.isNotEmpty) _kiranaPhone = phone;
    if (email != null && email.isNotEmpty) _kiranaEmail = email;
    if (category != null && category.isNotEmpty) _kiranaCategory = category;
    if (operatingHours != null && operatingHours.isNotEmpty) _kiranaOperatingHours = operatingHours;
    if (avatarUrl != null && avatarUrl.isNotEmpty) _kiranaAvatarUrl = avatarUrl;
    if (coverUrl != null && coverUrl.isNotEmpty) _kiranaCoverUrl = coverUrl;

    notifyListeners();
  }

  // Restaurant Profile State
  String _restaurantName = 'The Spice Symphony';
  String get restaurantName => _restaurantName;

  String _restaurantOwnerName = 'Rahul Verma';
  String get restaurantOwnerName => _restaurantOwnerName;

  String _restaurantAddress = 'Koramangala 5th Block, Bengaluru';
  String get restaurantAddress => _restaurantAddress;

  String _restaurantRegNumber = 'REG-KA-BLR-8921';
  String get restaurantRegNumber => _restaurantRegNumber;

  String _restaurantFssai = '11223344556677';
  String get restaurantFssai => _restaurantFssai;

  String _restaurantPhone = '+91 98765 43210';
  String get restaurantPhone => _restaurantPhone;

  String _restaurantEmail = 'manager@spicesymphony.com';
  String get restaurantEmail => _restaurantEmail;

  String _restaurantCuisine = 'North Indian & Mughlai Delicacies';
  String get restaurantCuisine => _restaurantCuisine;

  String _restaurantOperatingHours = '11:00 AM – 11:30 PM';
  String get restaurantOperatingHours => _restaurantOperatingHours;

  String _restaurantDonationPref = 'Freshly Cooked & Packaged Surplus';
  String get restaurantDonationPref => _restaurantDonationPref;

  String _restaurantAvatarUrl = AppImage.restaurantKitchen;
  String get restaurantAvatarUrl => _restaurantAvatarUrl;

  String _restaurantCoverUrl = AppImage.restaurantKitchen;
  String get restaurantCoverUrl => _restaurantCoverUrl;

  void updateRestaurantProfile({
    String? name,
    String? ownerName,
    String? address,
    String? regNumber,
    String? fssai,
    String? phone,
    String? email,
    String? cuisine,
    String? operatingHours,
    String? donationPref,
    String? avatarUrl,
    String? coverUrl,
  }) {
    if (name != null && name.isNotEmpty) _restaurantName = name;
    if (ownerName != null && ownerName.isNotEmpty) _restaurantOwnerName = ownerName;
    if (address != null && address.isNotEmpty) _restaurantAddress = address;
    if (regNumber != null && regNumber.isNotEmpty) _restaurantRegNumber = regNumber;
    if (fssai != null && fssai.isNotEmpty) _restaurantFssai = fssai;
    if (phone != null && phone.isNotEmpty) _restaurantPhone = phone;
    if (email != null && email.isNotEmpty) _restaurantEmail = email;
    if (cuisine != null && cuisine.isNotEmpty) _restaurantCuisine = cuisine;
    if (operatingHours != null && operatingHours.isNotEmpty) _restaurantOperatingHours = operatingHours;
    if (donationPref != null && donationPref.isNotEmpty) _restaurantDonationPref = donationPref;
    if (avatarUrl != null && avatarUrl.isNotEmpty) _restaurantAvatarUrl = avatarUrl;
    if (coverUrl != null && coverUrl.isNotEmpty) _restaurantCoverUrl = coverUrl;

    notifyListeners();
  }

  // Vendor Profile State
  String _vendorBusinessName = 'FreshBuy Wholesale Traders';
  String get vendorBusinessName => _vendorBusinessName;

  String _vendorOwnerName = 'Suresh Patel';
  String get vendorOwnerName => _vendorOwnerName;

  String _vendorAddress = 'Yeshwanthpur Wholesale Market, Bengaluru';
  String get vendorAddress => _vendorAddress;

  String _vendorGstin = '29AAAAA0000A1Z5';
  String get vendorGstin => _vendorGstin;

  String _vendorPhone = '+91 94480 98765';
  String get vendorPhone => _vendorPhone;

  String _vendorEmail = 'orders@freshbuytraders.com';
  String get vendorEmail => _vendorEmail;

  String _vendorBusinessType = 'B2B Wholesale & Bulk Retail';
  String get vendorBusinessType => _vendorBusinessType;

  String _vendorOperatingHours = '06:00 AM – 08:30 PM';
  String get vendorOperatingHours => _vendorOperatingHours;

  String _vendorAvatarUrl = AppImage.vendorWholesale;
  String get vendorAvatarUrl => _vendorAvatarUrl;

  String _vendorCoverUrl = AppImage.vendorWholesale;
  String get vendorCoverUrl => _vendorCoverUrl;

  void updateVendorProfile({
    String? businessName,
    String? ownerName,
    String? address,
    String? gstin,
    String? phone,
    String? email,
    String? businessType,
    String? operatingHours,
    String? avatarUrl,
    String? coverUrl,
  }) {
    if (businessName != null && businessName.isNotEmpty) _vendorBusinessName = businessName;
    if (ownerName != null && ownerName.isNotEmpty) _vendorOwnerName = ownerName;
    if (address != null && address.isNotEmpty) _vendorAddress = address;
    if (gstin != null && gstin.isNotEmpty) _vendorGstin = gstin;
    if (phone != null && phone.isNotEmpty) _vendorPhone = phone;
    if (email != null && email.isNotEmpty) _vendorEmail = email;
    if (businessType != null && businessType.isNotEmpty) _vendorBusinessType = businessType;
    if (operatingHours != null && operatingHours.isNotEmpty) _vendorOperatingHours = operatingHours;
    if (avatarUrl != null && avatarUrl.isNotEmpty) _vendorAvatarUrl = avatarUrl;
    if (coverUrl != null && coverUrl.isNotEmpty) _vendorCoverUrl = coverUrl;

    notifyListeners();
  }

  // Restaurant Analytics Stats
  double _restaurantRevenueToday = 4250.0;
  double get restaurantRevenueToday => _restaurantRevenueToday;
  final double _restaurantWasteKgToday = 24.0;
  double get restaurantWasteKgToday => _restaurantWasteKgToday;
  int _restaurantSavedMealsToday = 18;
  int get restaurantSavedMealsToday => _restaurantSavedMealsToday;

  // Vendor Savings Stats (Preserving all exact requested values)
  double _vendorTotalPurchases = 28500.0;
  double get vendorTotalPurchases => _vendorTotalPurchases;
  double _vendorMoneySaved = 6940.0; // ₹6940 Saved
  double get vendorMoneySaved => _vendorMoneySaved;
  int _vendorOrdersCount = 15; // 15 Orders Done
  int get vendorOrdersCount => _vendorOrdersCount;
  final double _vendorNearExpiryKg = 86.0; // 86 kg Bought
  double get vendorNearExpiryKg => _vendorNearExpiryKg;
  final int _vendorAvgDiscount = 32; // 32% Average Discount
  int get vendorAvgDiscount => _vendorAvgDiscount;
  final int _vendorActiveDeals = 6; // 6 Active Deals
  int get vendorActiveDeals => _vendorActiveDeals;

  // Support Callback Dispatcher
  void requestSupportCallback({
    required String requesterName,
    required String phone,
    required String roleTitle,
    required String subject,
  }) {
    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-${DateTime.now().millisecondsSinceEpoch}',
        title: '📞 Callback Requested: $subject',
        message: 'FoodResQ Priority Desk will call $requesterName ($phone) within 15 minutes.',
        timestamp: DateTime.now(),
        isRead: false,
        targetRole: roleTitle,
      ),
    );
    notifyListeners();
  }

  // Kirana Recovery Stats
  double _kiranaRevenueRecovered = 12800.0;
  double get kiranaRevenueRecovered => _kiranaRevenueRecovered;
  double _kiranaPotentialLoss = 2850.0;
  double get kiranaPotentialLoss => _kiranaPotentialLoss;
  int _kiranaExpiringProducts = 12;
  int get kiranaExpiringProducts => _kiranaExpiringProducts;

  // Lists
  final List<SurplusItem> _surplusItems = [];
  List<SurplusItem> get surplusItems => List.unmodifiable(_surplusItems);

  final List<DiscountOffer> _discountOffers = [];
  List<DiscountOffer> get discountOffers => List.unmodifiable(_discountOffers);

  final List<TransactionRecord> _transactions = [];
  List<TransactionRecord> get transactions => List.unmodifiable(_transactions);

  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  // 8-Minute Acceptance Cascade Timer
  SurplusItem? _activeCascadeItem;
  SurplusItem? get activeCascadeItem => _activeCascadeItem;
  int _cascadeTimerSeconds = 480; // 8 minutes = 480 seconds
  int get cascadeTimerSeconds => _cascadeTimerSeconds;
  Timer? _timer;
  bool _isCascadeActive = false;
  bool get isCascadeActive => _isCascadeActive;

  AppState() {
    _initDemoData();
  }

  void setRole(UserRole role) {
    _activeRole = role;
    notifyListeners();
  }

  void toggleNgoRequirement() {
    _ngoAcceptingFood = !_ngoAcceptingFood;
    notifyListeners();
  }

  void updateNgoRequirement(int capacity, int requirement) {
    _ngoCapacityPercent = capacity;
    _ngoMealsRequirement = requirement;
    notifyListeners();
  }

  // Demo Data Initialization
  void _initDemoData() {
    // 1. Surplus Items (Restaurant -> NGO / Sell)
    _surplusItems.addAll([
      SurplusItem(
        id: 'SUR-101',
        title: '🍱 Prepared North Indian Meals',
        restaurantName: 'Urban Tadka',
        mealsCount: 35,
        category: 'Prepared Meals',
        prepTime: DateTime.now().subtract(const Duration(hours: 2)),
        safeUntilTime: DateTime.now().add(const Duration(hours: 4)),
        isVeg: true,
        location: 'Koramangala 5th Block',
        distanceKm: 2.4,
        status: 'active',
        targetType: 'DONATE',
      ),
      SurplusItem(
        id: 'SUR-102',
        title: '🍛 Paneer Butter Masala & Naan',
        restaurantName: 'The Green Bowl',
        mealsCount: 20,
        category: 'Gravy & Breads',
        prepTime: DateTime.now().subtract(const Duration(hours: 1)),
        safeUntilTime: DateTime.now().add(const Duration(hours: 3)),
        isVeg: true,
        location: 'Indiranagar 100ft Rd',
        distanceKm: 4.1,
        status: 'active',
        targetType: 'DONATE',
      ),
      SurplusItem(
        id: 'SUR-103',
        title: '🍗 Chicken Biryani Combo Boxes',
        restaurantName: 'Spice Route Kitchen',
        mealsCount: 15,
        category: 'Biryani & Rice',
        prepTime: DateTime.now().subtract(const Duration(hours: 3)),
        safeUntilTime: DateTime.now().add(const Duration(hours: 2)),
        isVeg: false,
        location: 'HSR Layout Sector 1',
        distanceKm: 3.8,
        status: 'accepted',
        acceptedByNgo: 'Helping Hands Foundation',
        targetType: 'DONATE',
      ),
    ]);

    // 2. Discount Offers & Kirana Inventory Items (Kirana -> Vendor)
    _discountOffers.addAll([
      DiscountOffer(
        id: 'DIS-201',
        kiranaName: 'Sharma General Store',
        productName: '🍅 Fresh Red Tomatoes',
        originalPrice: 40.0,
        discountedPrice: 28.0,
        discountPercent: 30,
        availableQuantity: 45,
        unit: 'kg',
        expiresAt: DateTime.now().add(const Duration(days: 2)),
        distanceKm: 3.2,
        category: 'Vegetables',
        isHighRisk: true,
        aiReason: 'AI predicted unsold stock based on weekend footfall reduction',
      ),
      DiscountOffer(
        id: 'DIS-202',
        kiranaName: 'FreshMart Kirana',
        productName: '🥛 Full Cream Milk Packs (500ml)',
        originalPrice: 30.0,
        discountedPrice: 21.0,
        discountPercent: 30,
        availableQuantity: 3,
        unit: 'packs',
        expiresAt: DateTime.now().add(const Duration(hours: 26)),
        distanceKm: 1.8,
        category: 'Dairy',
        isHighRisk: true,
        aiReason: 'Expires tomorrow. High risk of 100% value loss.',
      ),
      DiscountOffer(
        id: 'DIS-203',
        kiranaName: 'Daily Needs Hub',
        productName: '🍞 Brown Wheat Bread',
        originalPrice: 50.0,
        discountedPrice: 35.0,
        discountPercent: 30,
        availableQuantity: 4,
        unit: 'packs',
        expiresAt: DateTime.now().add(const Duration(days: 2)),
        distanceKm: 2.0,
        category: 'Bakery',
        isHighRisk: true,
        aiReason: 'Expires in 2 days. Fast-moving fresh item.',
      ),
      DiscountOffer(
        id: 'DIS-204',
        kiranaName: 'Daily Needs Hub',
        productName: '🍚 Premium Basmati Rice (5kg)',
        originalPrice: 450.0,
        discountedPrice: 315.0,
        discountPercent: 30,
        availableQuantity: 25,
        unit: 'bags',
        expiresAt: DateTime.now().add(const Duration(days: 45)),
        distanceKm: 2.5,
        category: 'Grains & Staples',
        isHighRisk: false,
        aiReason: 'Healthy bulk inventory item',
      ),
      DiscountOffer(
        id: 'DIS-205',
        kiranaName: 'Sharma General Store',
        productName: '🌻 Sunflower Cooking Oil (1L)',
        originalPrice: 160.0,
        discountedPrice: 120.0,
        discountPercent: 25,
        availableQuantity: 3,
        unit: 'pouches',
        expiresAt: DateTime.now().add(const Duration(days: 60)),
        distanceKm: 1.5,
        category: 'Staples',
        isHighRisk: false,
        aiReason: 'Low stock threshold reached (3 pouches remaining)',
      ),
      DiscountOffer(
        id: 'DIS-206',
        kiranaName: 'Sharma General Store',
        productName: '🌾 Whole Wheat Atta (10kg)',
        originalPrice: 380.0,
        discountedPrice: 300.0,
        discountPercent: 20,
        availableQuantity: 18,
        unit: 'bags',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
        distanceKm: 1.2,
        category: 'Grains & Staples',
        isHighRisk: false,
        aiReason: 'Sufficient inventory available',
      ),
    ]);

    // 3. Transactions Log
    _transactions.addAll([
      TransactionRecord(
        id: 'TXN10482',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        itemTitle: '35 Meals (North Indian Thali)',
        quantityStr: '35 Meals',
        roleType: 'NGO',
        originalValue: 4200.0,
        finalValue: 0.0,
        savedValue: 4200.0,
        status: 'COMPLETED',
        participant1: 'Urban Tadka',
        participant2: 'Helping Hands Foundation',
        impactSummary: '35 Meals Saved • 35 People Served • 14 kg Diverted',
        timeline: [
          TransactionStep(title: 'Food Posted by Urban Tadka', timestamp: '17:30', isCompleted: true),
          TransactionStep(title: 'NGO Accepted (8-Min Cascade)', timestamp: '17:34', isCompleted: true),
          TransactionStep(title: 'Food Picked Up by NGO', timestamp: '18:15', isCompleted: true),
          TransactionStep(title: 'Distributed & Verified', timestamp: '19:10', isCompleted: true),
        ],
      ),
      TransactionRecord(
        id: 'TXN10479',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        itemTitle: '20 Meals (Bakery & Pastries Batch)',
        quantityStr: '20 Meals',
        roleType: 'NGO',
        originalValue: 2400.0,
        finalValue: 0.0,
        savedValue: 0.0,
        status: 'EXPIRED',
        participant1: 'Bakers Delight',
        participant2: 'Helping Hands Foundation',
        impactSummary: '8-minute cascade acceptance window expired',
        timeline: [
          TransactionStep(title: 'Food Posted by Bakers Delight', timestamp: 'Yesterday 14:00', isCompleted: true),
          TransactionStep(title: 'Cascade Window Expired', timestamp: 'Yesterday 14:08', isCompleted: false),
        ],
      ),
      TransactionRecord(
        id: 'TXN10478',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        itemTitle: '15 Meals (Rice & Gravy Combo)',
        quantityStr: '15 Meals',
        roleType: 'NGO',
        originalValue: 1800.0,
        finalValue: 0.0,
        savedValue: 0.0,
        status: 'CANCELLED',
        participant1: 'Curry House',
        participant2: 'Helping Hands Foundation',
        impactSummary: 'Pickup cancelled due to severe weather conditions',
        timeline: [
          TransactionStep(title: 'Food Posted by Curry House', timestamp: '2 days ago', isCompleted: true),
          TransactionStep(title: 'NGO Accepted', timestamp: '2 days ago', isCompleted: true),
          TransactionStep(title: 'Pickup Cancelled', timestamp: '2 days ago', isCompleted: false),
        ],
      ),
      TransactionRecord(
        id: 'TXN10481',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        itemTitle: '50 kg Organic Tomatoes Batch',
        quantityStr: '50 kg',
        roleType: 'VENDOR',
        originalValue: 2000.0,
        finalValue: 1400.0,
        savedValue: 600.0,
        status: 'COMPLETED',
        participant1: 'Sharma General Store',
        participant2: 'FreshBuy Traders',
        impactSummary: '₹600 Money Saved • 50 kg Inventory Diverted',
        timeline: [
          TransactionStep(title: 'Discount Offer Created', timestamp: '14:00', isCompleted: true),
          TransactionStep(title: 'Purchased by FreshBuy Traders', timestamp: '14:25', isCompleted: true),
          TransactionStep(title: 'Pickup Completed', timestamp: '15:10', isCompleted: true),
        ],
      ),
    ]);

    // 4. Notifications
    _notifications.addAll([
      NotificationModel(
        id: 'NOTIF-1',
        title: '🍱 New Surplus Opportunity',
        message: 'Urban Tadka posted 35 Meals (2.4 km away). 8-minute acceptance countdown initiated!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        targetRole: 'NGO',
        actionKey: 'OPEN_CASCADE',
      ),
      NotificationModel(
        id: 'NOTIF-2',
        title: '🤖 AI Waste Forecast Alert',
        message: 'Tomorrow\'s predicted surplus: 16 kg. Reduce Friday rice prep by 12%.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        targetRole: 'RESTAURANT',
      ),
      NotificationModel(
        id: 'NOTIF-3',
        title: '🏷️ New 30% Off Deal',
        message: 'FreshMart Kirana published 12 Milk Packs at ₹21/pack expiring tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        targetRole: 'VENDOR',
      ),
      NotificationModel(
        id: 'NOTIF-4',
        title: '⚠ Expiry Warning',
        message: '12 products expire within 3 days. Potential loss: ₹2,850. Create AI discount offer now.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        targetRole: 'KIRANA',
      ),
    ]);

    // Start default 8-minute cascade demo item
    _startDemoCascade(_surplusItems.first);
  }

  // Track declined cascade items for current NGO session
  final Set<String> _declinedCascadeItemIds = {};

  SurplusItem? _findNextActiveCascadeItem() {
    for (final item in _surplusItems) {
      if (item.status == 'active' && !_declinedCascadeItemIds.contains(item.id)) {
        return item;
      }
    }
    return null;
  }

  // 8-Minute Cascade Engine
  void _startDemoCascade(SurplusItem item) {
    _activeCascadeItem = item;
    _cascadeTimerSeconds = 480; // 8 minutes fresh countdown
    _isCascadeActive = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cascadeTimerSeconds > 0) {
        _cascadeTimerSeconds--;
        notifyListeners();
      } else {
        _cascadeTimeout();
      }
    });
    notifyListeners();
  }

  void _cascadeTimeout() {
    _timer?.cancel();
    if (_activeCascadeItem != null) {
      _declinedCascadeItemIds.add(_activeCascadeItem!.id);
      _notifications.insert(
        0,
        NotificationModel(
          id: 'NOTIF-EXPIRE-${DateTime.now().millisecondsSinceEpoch}',
          title: '⏱ 8-Minute Window Expired',
          message: 'Acceptance window expired for ${_activeCascadeItem!.title}. Cascading to next available opportunity...',
          timestamp: DateTime.now(),
          targetRole: 'NGO',
        ),
      );
    }

    final nextOpp = _findNextActiveCascadeItem();
    if (nextOpp != null) {
      _startDemoCascade(nextOpp);
    } else {
      _isCascadeActive = false;
      _activeCascadeItem = null;
      notifyListeners();
    }
  }

  void acceptCascadeOpportunity() {
    if (_activeCascadeItem == null) return;
    _timer?.cancel();

    _activeCascadeItem!.status = 'accepted';
    _activeCascadeItem!.acceptedByNgo = 'Helping Hands Foundation';

    // Add notification
    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-ACCEPT-${DateTime.now().millisecondsSinceEpoch}',
        title: '✅ Opportunity Accepted!',
        message: 'You accepted ${_activeCascadeItem!.mealsCount} meals from ${_activeCascadeItem!.restaurantName}. Pickup tracking initiated.',
        timestamp: DateTime.now(),
        targetRole: 'NGO',
      ),
    );

    final nextOpp = _findNextActiveCascadeItem();
    if (nextOpp != null) {
      _startDemoCascade(nextOpp);
    } else {
      _isCascadeActive = false;
      _activeCascadeItem = null;
      notifyListeners();
    }
  }

  void declineCascadeOpportunity() {
    if (_activeCascadeItem == null) return;
    final declinedTitle = _activeCascadeItem!.title;
    _declinedCascadeItemIds.add(_activeCascadeItem!.id);

    _timer?.cancel();

    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-DECLINE-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Opportunity Declined',
        message: 'Declined $declinedTitle. Cascaded opportunity to next best matching NGO opportunity in network.',
        timestamp: DateTime.now(),
        targetRole: 'NGO',
      ),
    );

    final nextOpp = _findNextActiveCascadeItem();
    if (nextOpp != null) {
      _startDemoCascade(nextOpp);
    } else {
      _isCascadeActive = false;
      _activeCascadeItem = null;
      notifyListeners();
    }
  }

  void rejectSurplusItem(SurplusItem item) {
    item.status = 'rejected';

    final newTxn = TransactionRecord(
      id: 'TXN${10483 + _transactions.length}',
      timestamp: DateTime.now(),
      itemTitle: '${item.mealsCount} Meals (${item.title})',
      quantityStr: '${item.mealsCount} Meals',
      roleType: 'NGO',
      originalValue: item.mealsCount * 120.0,
      finalValue: 0.0,
      savedValue: 0.0,
      status: 'CANCELLED',
      participant1: item.restaurantName,
      participant2: 'Helping Hands Foundation',
      impactSummary: 'Donation offer rejected by NGO',
      timeline: [
        TransactionStep(title: 'Food Posted by ${item.restaurantName}', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'Donation Rejected by NGO', timestamp: 'Just now', isCompleted: false),
      ],
    );

    _transactions.insert(0, newTxn);

    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-REJECT-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Donation Offer Rejected',
        message: 'You rejected ${item.mealsCount} meals from ${item.restaurantName}. Recorded in history.',
        timestamp: DateTime.now(),
        targetRole: 'NGO',
      ),
    );

    notifyListeners();
  }

  void completeFoodPickupAndDistribution(SurplusItem item, int peopleServedCount) {
    item.status = 'distributed';
    _totalMealsSaved += item.mealsCount;
    _peopleServed += peopleServedCount;
    _foodDivertedKg += (item.mealsCount * 0.4); // approx 400g per meal
    _successfulPickups += 1;

    // Dynamically update Trust Score (+4 points demo effect!)
    _trustScore.addSuccessfulDistribution();

    // Create transaction record
    final newTxn = TransactionRecord(
      id: 'TXN${10483 + _transactions.length}',
      timestamp: DateTime.now(),
      itemTitle: '${item.mealsCount} Meals (${item.title})',
      quantityStr: '${item.mealsCount} Meals',
      roleType: 'NGO',
      originalValue: item.mealsCount * 120.0,
      finalValue: 0.0,
      savedValue: item.mealsCount * 120.0,
      status: 'COMPLETED',
      participant1: item.restaurantName,
      participant2: 'Helping Hands Foundation',
      impactSummary: '${item.mealsCount} Meals Saved • $peopleServedCount People Served • ⭐ Trust Score Updated to ${_trustScore.overallScore}',
      timeline: [
        TransactionStep(title: 'Food Posted by ${item.restaurantName}', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'NGO Accepted (8-Min Window)', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'Food Collected', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'Distributed to Beneficiaries', timestamp: 'Just now', isCompleted: true),
      ],
    );

    _transactions.insert(0, newTxn);

    // Notification
    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-DIST-${DateTime.now().millisecondsSinceEpoch}',
        title: '🎉 Food Recovery Completed!',
        message: 'Successfully served $peopleServedCount people. Trust Score updated to ⭐ ${_trustScore.overallScore} (+4 points)!',
        timestamp: DateTime.now(),
        targetRole: 'NGO',
      ),
    );

    notifyListeners();
  }

  // Restaurant Action: Add Surplus
  void addSurplusItem({
    required String title,
    required int mealsCount,
    required String category,
    required String targetType,
    required String location,
    double? originalPrice,
    double? discountedPrice,
  }) {
    final newItem = SurplusItem(
      id: 'SUR-${104 + _surplusItems.length}',
      title: title,
      restaurantName: 'Urban Tadka',
      mealsCount: mealsCount,
      category: category,
      prepTime: DateTime.now(),
      safeUntilTime: DateTime.now().add(const Duration(hours: 4)),
      isVeg: true,
      location: location,
      distanceKm: 1.5,
      status: 'active',
      targetType: targetType,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
    );

    _surplusItems.insert(0, newItem);
    _restaurantSavedMealsToday += mealsCount;
    _restaurantRevenueToday += (discountedPrice ?? 0) * mealsCount;

    // Automatically trigger Smart Matching and 8-min Cascade
    _startDemoCascade(newItem);

    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-SURPLUS-${DateTime.now().millisecondsSinceEpoch}',
        title: '🚀 Surplus Posted & Smart Match Triggered',
        message: 'Smart Matching Engine ranked Helping Hands NGO (91% Match). 8-minute acceptance window dispatched.',
        timestamp: DateTime.now(),
        targetRole: 'RESTAURANT',
      ),
    );

    notifyListeners();
  }

  // Kirana Action: Create Discount Offer
  void createDiscountOffer({
    required String productName,
    required double originalPrice,
    required double discountedPrice,
    required int discountPercent,
    required int quantity,
    required String unit,
    required String category,
  }) {
    final newOffer = DiscountOffer(
      id: 'DIS-${204 + _discountOffers.length}',
      kiranaName: 'Sharma General Store',
      productName: productName,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      discountPercent: discountPercent,
      availableQuantity: quantity,
      unit: unit,
      expiresAt: DateTime.now().add(const Duration(days: 2)),
      distanceKm: 2.1,
      category: category,
      isHighRisk: true,
      aiReason: 'AI recommended 30% discount to prevent inventory loss',
    );

    _discountOffers.insert(0, newOffer);
    if (_kiranaExpiringProducts > 0) _kiranaExpiringProducts--;

    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-KIRANA-${DateTime.now().millisecondsSinceEpoch}',
        title: '🏷️ Discount Offer Published to Vendors',
        message: '$productName ($quantity $unit) published at $discountPercent% OFF (₹$discountedPrice). Visible to nearby Vendor buyers.',
        timestamp: DateTime.now(),
        targetRole: 'KIRANA',
      ),
    );

    notifyListeners();
  }

  // Vendor Action: Purchase Discount Offer
  void purchaseDiscountOffer(DiscountOffer offer) {
    offer.isPurchased = true;

    final totalPaid = offer.discountedPrice * offer.availableQuantity;
    final totalOriginal = offer.originalPrice * offer.availableQuantity;
    final saved = totalOriginal - totalPaid;

    _vendorTotalPurchases += totalPaid;
    _vendorMoneySaved += saved;
    _vendorOrdersCount += 1;

    _kiranaRevenueRecovered += totalPaid;
    if (_kiranaPotentialLoss >= saved) {
      _kiranaPotentialLoss -= saved;
    }

    final newTxn = TransactionRecord(
      id: 'TXN${10483 + _transactions.length}',
      timestamp: DateTime.now(),
      itemTitle: '${offer.availableQuantity} ${offer.unit} ${offer.productName}',
      quantityStr: '${offer.availableQuantity} ${offer.unit}',
      roleType: 'VENDOR',
      originalValue: totalOriginal,
      finalValue: totalPaid,
      savedValue: saved,
      status: 'COMPLETED',
      participant1: offer.kiranaName,
      participant2: 'FreshBuy Traders',
      impactSummary: 'Purchased at ${offer.discountPercent}% OFF • Saved ₹${saved.toStringAsFixed(0)} • Recovered ₹${totalPaid.toStringAsFixed(0)} for Kirana',
      timeline: [
        TransactionStep(title: 'Discount Published by ${offer.kiranaName}', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'Purchased by Vendor (FreshBuy)', timestamp: 'Just now', isCompleted: true),
        TransactionStep(title: 'Pickup Confirmed & Completed', timestamp: 'Just now', isCompleted: true),
      ],
    );

    _transactions.insert(0, newTxn);

    _notifications.insert(
      0,
      NotificationModel(
        id: 'NOTIF-BUY-${DateTime.now().millisecondsSinceEpoch}',
        title: '🛒 Deal Purchased Successfully!',
        message: 'You purchased ${offer.productName} for ₹${totalPaid.toStringAsFixed(0)}. You saved ₹${saved.toStringAsFixed(0)}!',
        timestamp: DateTime.now(),
        targetRole: 'VENDOR',
      ),
    );

    notifyListeners();
  }

  void markNotificationRead(String id) {
    final notif = _notifications.firstWhere((n) => n.id == id, orElse: () => _notifications.first);
    notif.isRead = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
