import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable FoodResQ branding component displaying the official logo alongside the brand name.
/// Matches the [Logo Icon] BrandName horizontal layout pattern (similar to YouTube).
class FoodResQLogo extends StatelessWidget {
  /// Logo width/height (square aspect ratio preserved). If null, automatically scales responsively.
  final double? size;

  /// Font size for "FoodResQ". If null, automatically scales responsively.
  final double? fontSize;

  /// Color for the "FoodResQ" text. Defaults to [AppColors.textPrimary].
  final Color? textColor;

  /// Horizontal spacing between the logo and the text.
  final double spacing;

  /// Whether to display the "FoodResQ" text next to the logo.
  final bool showText;

  /// Text to display. Defaults to 'FoodResQ'.
  final String brandText;

  /// Whether to wrap the logo in a polished rounded squircle container with border and subtle shadow.
  final bool withContainer;

  /// Optional tap callback for the brand identity.
  final VoidCallback? onTap;

  const FoodResQLogo({
    super.key,
    this.size,
    this.fontSize,
    this.textColor,
    this.spacing = 10.0,
    this.showText = true,
    this.brandText = 'FoodResQ',
    this.withContainer = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 400.0;

    // Responsive scaling based on device width
    final effectiveSize = size ??
        (screenWidth < 360
            ? 34.0
            : screenWidth > 768
                ? 46.0
                : 40.0);

    final effectiveFontSize = fontSize ??
        (screenWidth < 360
            ? 20.0
            : screenWidth > 768
                ? 28.0
                : 24.0);

    final borderRadius = effectiveSize * 0.22;

    Widget logoImage = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        'assets/images/foodresq_logo.png',
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.contain,
        semanticLabel: 'FoodResQ Logo',
        errorBuilder: (context, error, stackTrace) {
          // Fallback if asset is missing or loading
          return Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: AppColors.ngoPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Icon(
              Icons.eco_rounded,
              size: effectiveSize * 0.65,
              color: AppColors.ngoPrimary,
            ),
          );
        },
      ),
    );

    Widget logoWidget = withContainer
        ? Container(
            width: effectiveSize,
            height: effectiveSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: AppColors.border.withOpacity(0.8),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: logoImage,
          )
        : logoImage;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        if (showText) ...[
          SizedBox(width: spacing),
          Flexible(
            child: Text(
              brandText,
              style: TextStyle(
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.w900,
                color: textColor ?? AppColors.textPrimary,
                letterSpacing: -0.6,
                height: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
