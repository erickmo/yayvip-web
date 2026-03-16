import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Data untuk setiap slide di hero slider.
class HeroSlideData {
  final IconData icon;
  final String caption;
  final String subcaption;
  final Color overlayColor;

  const HeroSlideData({
    required this.icon,
    required this.caption,
    required this.subcaption,
    this.overlayColor = AppColors.darkOverlay,
  });
}

/// Hero slider dengan auto-advance dan dot indicators.
class HeroSlider extends StatefulWidget {
  final List<HeroSlideData> slides;
  final double height;

  const HeroSlider({
    super.key,
    required this.slides,
    this.height = 450,
  });

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoAdvance();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoAdvance() {
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % widget.slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: widget.slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                _SlideItem(data: widget.slides[index]),
          ),
          // Dot indicators
          Positioned(
            bottom: AppDimensions.spacingL,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.slides.length,
                (index) => _DotIndicator(isActive: index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Item slide individual dengan gradient overlay dan teks.
class _SlideItem extends StatelessWidget {
  final HeroSlideData data;

  const _SlideItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            data.overlayColor,
            data.overlayColor.withValues(alpha: 0.85),
            AppColors.primary.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background icon (decorative)
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              data.icon,
              size: 250,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingXXL * 2,
              vertical: AppDimensions.spacingXXL,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Icon(data.icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                // Caption
                Text(
                  data.caption,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                // Subcaption
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    data.subcaption,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dot indicator untuk slider.
class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
