import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SubtleBackgroundAnimation extends StatefulWidget {
  final UserRole role;
  final Widget child;

  const SubtleBackgroundAnimation({
    super.key,
    required this.role,
    required this.child,
  });

  @override
  State<SubtleBackgroundAnimation> createState() => _SubtleBackgroundAnimationState();
}

class _SubtleBackgroundAnimationState extends State<SubtleBackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _getRoleEmojis() {
    switch (widget.role) {
      case UserRole.ngo:
        return ['🍃', '🍱', '❤️', '🤝', '🌱'];
      case UserRole.restaurant:
        return ['🍽️', '🍳', '🥖', '🥗', '🍲'];
      case UserRole.vendor:
        return ['🛒', '📦', '🏷️', '🍇', '🥑'];
      case UserRole.kirana:
        return ['🏪', '🥛', '🌾', '🍎', '🧺'];
    }
  }

  Color _getParticleColor() {
    return AppColors.getPrimaryForRole(widget.role).withOpacity(0.05);
  }

  @override
  Widget build(BuildContext context) {
    final emojis = _getRoleEmojis();
    final particleColor = _getParticleColor();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animVal = _controller.value;
        return Stack(
          children: [
            // Background Particle Circles & Ambient Blobs
            Positioned(
              top: -40 + (math.sin(animVal * math.pi * 2) * 20),
              right: -30 + (math.cos(animVal * math.pi * 2) * 15),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: particleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 100 + (math.cos(animVal * math.pi) * 25),
              left: -50 + (math.sin(animVal * math.pi) * 20),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: particleColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Floating Emojis / Elements (Soft & Low Opacity)
            Positioned(
              top: 120 + (math.sin(animVal * math.pi * 2) * 12),
              left: 24,
              child: Opacity(
                opacity: 0.12,
                child: Text(emojis[0], style: const TextStyle(fontSize: 22)),
              ),
            ),
            Positioned(
              top: 260 + (math.cos(animVal * math.pi * 2) * 14),
              right: 28,
              child: Opacity(
                opacity: 0.12,
                child: Text(emojis[1], style: const TextStyle(fontSize: 24)),
              ),
            ),
            Positioned(
              bottom: 200 + (math.sin(animVal * math.pi) * 15),
              right: 45,
              child: Opacity(
                opacity: 0.12,
                child: Text(emojis[2], style: const TextStyle(fontSize: 20)),
              ),
            ),
            Positioned(
              bottom: 80 + (math.cos(animVal * math.pi) * 10),
              left: 35,
              child: Opacity(
                opacity: 0.12,
                child: Text(emojis[3], style: const TextStyle(fontSize: 22)),
              ),
            ),
            // Main Content
            widget.child,
          ],
        );
      },
    );
  }
}
