import 'package:flutter/material.dart';

class SurplusItem {
  final String id;
  final String title;
  final String restaurantName;
  final int mealsCount;
  final String category;
  final DateTime prepTime;
  final DateTime safeUntilTime;
  final bool isVeg;
  final String location;
  final double distanceKm;
  String status; // 'active', 'accepted', 'in_pickup', 'distributed', 'expired'
  String? acceptedByNgo;
  final String targetType; // 'DONATE', 'DISCOUNT', 'BOTH'
  final double? originalPrice;
  final double? discountedPrice;

  SurplusItem({
    required this.id,
    required this.title,
    required this.restaurantName,
    required this.mealsCount,
    required this.category,
    required this.prepTime,
    required this.safeUntilTime,
    this.isVeg = true,
    required this.location,
    required this.distanceKm,
    this.status = 'active',
    this.acceptedByNgo,
    this.targetType = 'DONATE',
    this.originalPrice,
    this.discountedPrice,
  });
}

class DiscountOffer {
  final String id;
  final String kiranaName;
  final String productName;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercent;
  final int availableQuantity;
  final String unit; // 'kg', 'packs', 'boxes'
  final DateTime expiresAt;
  final double distanceKm;
  final String category;
  final bool isHighRisk;
  final String aiReason;
  bool isPurchased;

  DiscountOffer({
    required this.id,
    required this.kiranaName,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.availableQuantity,
    required this.unit,
    required this.expiresAt,
    required this.distanceKm,
    required this.category,
    this.isHighRisk = false,
    required this.aiReason,
    this.isPurchased = false,
  });

  bool get isExpiring {
    final days = expiresAt.difference(DateTime.now()).inDays;
    return isHighRisk || days <= 3;
  }

  bool get isLowStock {
    return availableQuantity <= 5;
  }
}

class TransactionStep {
  final String title;
  final String timestamp;
  final bool isCompleted;

  TransactionStep({
    required this.title,
    required this.timestamp,
    required this.isCompleted,
  });
}

class TransactionRecord {
  final String id;
  final DateTime timestamp;
  final String itemTitle;
  final String quantityStr;
  final String roleType; // 'NGO', 'RESTAURANT', 'VENDOR', 'KIRANA'
  final double originalValue;
  final double finalValue;
  final double savedValue;
  final String status; // 'COMPLETED', 'PENDING', 'ACCEPTED', 'EXPIRED'
  final List<TransactionStep> timeline;
  final String participant1;
  final String participant2;
  final String impactSummary;

  TransactionRecord({
    required this.id,
    required this.timestamp,
    required this.itemTitle,
    required this.quantityStr,
    required this.roleType,
    required this.originalValue,
    required this.finalValue,
    required this.savedValue,
    required this.status,
    required this.timeline,
    required this.participant1,
    required this.participant2,
    required this.impactSummary,
  });
}

class ScoreComponent {
  final String name;
  final int current;
  final int max;

  ScoreComponent({
    required this.name,
    required this.current,
    required this.max,
  });
}

class NgoTrustScore {
  int overallScore;
  String trustLevel;
  Color levelColor;
  int collectionScore; // max 25
  int distributionScore; // max 30
  int acceptanceScore; // max 15
  int pickupScore; // max 15
  int completionScore; // max 10
  int verifiedImpactScore; // max 5
  int monthlyDelta;
  List<String> recentImprovements;

  NgoTrustScore({
    required this.overallScore,
    required this.trustLevel,
    required this.levelColor,
    required this.collectionScore,
    required this.distributionScore,
    required this.acceptanceScore,
    required this.pickupScore,
    required this.completionScore,
    required this.verifiedImpactScore,
    required this.monthlyDelta,
    required this.recentImprovements,
  });

  void addSuccessfulDistribution() {
    overallScore = (overallScore + 4).clamp(0, 100);
    monthlyDelta += 4;
    collectionScore = (collectionScore + 1).clamp(0, 25);
    distributionScore = (distributionScore + 1).clamp(0, 30);
    pickupScore = (pickupScore + 1).clamp(0, 15);
    verifiedImpactScore = (verifiedImpactScore + 1).clamp(0, 5);
    recentImprovements.insert(0, '+4 Verified Distribution & Pickup');
    _recalculateLevel();
  }

  void _recalculateLevel() {
    if (overallScore >= 90) {
      trustLevel = 'EXCELLENT';
      levelColor = const Color(0xFF36A269);
    } else if (overallScore >= 75) {
      trustLevel = 'TRUSTED';
      levelColor = const Color(0xFF126B68);
    } else if (overallScore >= 60) {
      trustLevel = 'GOOD';
      levelColor = const Color(0xFFF2A93B);
    } else if (overallScore >= 40) {
      trustLevel = 'DEVELOPING';
      levelColor = const Color(0xFFE45757);
    } else {
      trustLevel = 'NEW / LOW TRUST';
      levelColor = Colors.grey;
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String targetRole;
  final String? actionKey;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.targetRole,
    this.actionKey,
    this.isRead = false,
  });
}

class SmartMatchResult {
  final String ngoName;
  final int overallMatch;
  final int capacityScore;
  final int distanceScore;
  final int requirementScore;
  final int trustScore;
  final int pickupReliability;

  SmartMatchResult({
    required this.ngoName,
    required this.overallMatch,
    required this.capacityScore,
    required this.distanceScore,
    required this.requirementScore,
    required this.trustScore,
    required this.pickupReliability,
  });
}

class PointTransaction {
  final String id;
  final int points; // positive for earned, negative for redeemed
  final String title;
  final String description;
  final String quantityStr;
  final DateTime timestamp;
  final bool isEarned;
  final String relatedId;

  PointTransaction({
    required this.id,
    required this.points,
    required this.title,
    required this.description,
    required this.quantityStr,
    required this.timestamp,
    required this.isEarned,
    this.relatedId = '',
  });
}

