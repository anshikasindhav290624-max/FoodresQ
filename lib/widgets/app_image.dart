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
  static const String groceryFruits = 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=600&auto=format&fit=crop&q=80';
  static const String groceryOil = 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&auto=format&fit=crop&q=80';
  static const String groceryAtta = 'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=600&auto=format&fit=crop&q=80';
  static const String groceryPackaged = 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=600&auto=format&fit=crop&q=80';

  static const String restaurantKitchen = 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80';
  static const String ngoCommunity = 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=600&auto=format&fit=crop&q=80';
  static const String vendorWholesale = 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=600&auto=format&fit=crop&q=80';
  static const String kiranaStore = 'https://images.unsplash.com/photo-1604719312566-8912e9227c6a?w=600&auto=format&fit=crop&q=80';

  /// Dynamically maps item/product titles to realistic high quality food imagery.
  static String getProductImage(String itemTitle) {
    final title = itemTitle.toLowerCase();
    if (title.contains('tomato') || title.contains('🍅')) {
      return groceryTomatoes;
    } else if (title.contains('milk') || title.contains('dairy') || title.contains('🥛')) {
      return groceryMilk;
    } else if (title.contains('biryani')) {
      return foodBiryani;
    } else if (title.contains('rice') || title.contains('basmati') || title.contains('🍚')) {
      return groceryRice;
    } else if (title.contains('bread') || title.contains('bakery') || title.contains('pastr') || title.contains('🍞')) {
      return foodBakery;
    } else if (title.contains('thali') || title.contains('meal') || title.contains('north indian') || title.contains('south indian') || title.contains('🍱')) {
      return foodThali;
    } else if (title.contains('paneer') || title.contains('gravy') || title.contains('masala') || title.contains('curry') || title.contains('🍛')) {
      return foodPaneer;
    } else if (title.contains('oil') || title.contains('sunflower') || title.contains('mustard') || title.contains('🌻')) {
      return groceryOil;
    } else if (title.contains('atta') || title.contains('wheat') || title.contains('flour') || title.contains('grain') || title.contains('staple') || title.contains('🌾')) {
      return groceryAtta;
    } else if (title.contains('fruit') || title.contains('apple') || title.contains('banana') || title.contains('orange') || title.contains('mango') || title.contains('🍎') || title.contains('🍌')) {
      return groceryFruits;
    } else if (title.contains('veggie') || title.contains('vegetable') || title.contains('organic')) {
      return groceryVeggies;
    } else if (title.contains('packaged') || title.contains('snack') || title.contains('biscuit') || title.contains('pack')) {
      return groceryPackaged;
    }
    return groceryVeggies;
  }


  @override
  Widget build(BuildContext context) {
    final bgColor = fallbackBgColor ?? AppColors.ngoPrimary.withValues(alpha: 0.1);
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
                valueColor: AlwaysStoppedAnimation<Color>(iconColor.withValues(alpha: 0.6)),
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
