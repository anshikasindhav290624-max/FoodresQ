import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData fallbackIcon;
  final Color? fallbackBgColor;
  final Color? fallbackIconColor;

  const AppImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12.0,
    this.fallbackIcon = Icons.fastfood_rounded,
    this.fallbackBgColor,
    this.fallbackIconColor,
  });

  // Curated High Quality Image URLs for FoodresQ
  static const String foodThali = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=600&auto=format&fit=crop&q=80';
  static const String foodPaneer = 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=600&auto=format&fit=crop&q=80';
  static const String foodBiryani = 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&auto=format&fit=crop&q=80';
  static const String foodBakery = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80';
  
  static const String groceryTomatoes = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80';
  static const String groceryMilk = 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&auto=format&fit=crop&q=80';
  static const String groceryRice = 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80';
  static const String groceryVeggies = 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?w=600&auto=format&fit=crop&q=80';
  
  static const String restaurantKitchen = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80';
  static const String restaurantDining = 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&auto=format&fit=crop&q=80';
  static const String ngoCommunity = 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600&auto=format&fit=crop&q=80';
  static const String ngoDistribution = 'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=600&auto=format&fit=crop&q=80';
  static const String vendorWholesale = 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=600&auto=format&fit=crop&q=80';
  static const String vendorMarket = 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&auto=format&fit=crop&q=80';
  static const String kiranaStore = 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=600&auto=format&fit=crop&q=80';
  static const String kiranaShop = 'https://images.unsplash.com/photo-1601598851547-4302969d0614?w=600&auto=format&fit=crop&q=80';

  @override
  Widget build(BuildContext context) {
    final bgColor = fallbackBgColor ?? AppColors.ngoPrimary.withOpacity(0.1);
    final iconColor = fallbackIconColor ?? AppColors.ngoPrimary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(iconColor.withOpacity(0.6)),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: bgColor,
            child: Icon(fallbackIcon, color: iconColor, size: 28),
          );
        },
      ),
    );
  }
}
