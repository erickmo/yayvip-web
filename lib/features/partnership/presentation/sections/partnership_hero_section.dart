import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';

final _c = ContentProvider.instance;

/// Hero section halaman partnership.
class PartnershipHeroSection extends StatelessWidget {
  const PartnershipHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 400),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkOverlay,
            AppColors.darkOverlay.withValues(alpha: 0.9),
            AppColors.primary.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative icon
          Positioned(
            right: -40,
            bottom: -40,
            child: Icon(
              Icons.handshake_rounded,
              size: 300,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          // Red bar right
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: isMobile ? 12 : 60,
            child: Container(color: AppColors.primary),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? AppDimensions.spacingL
                  : AppDimensions.spacingXXL * 2,
              vertical: AppDimensions.spacingXXL * 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: const Icon(Icons.handshake_rounded,
                      size: 32, color: Colors.white),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                Text(
                  _c.getString('partnership', 'hero.caption'),
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 44,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    _c.getString('partnership', 'hero.subcaption'),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.8),
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
