import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';

final _c = ContentProvider.instance;

/// Hero section — bagian utama di atas landing page.
class HeroSection extends StatelessWidget {
  final VoidCallback? onDonatePressed;
  final VoidCallback? onLearnMorePressed;

  const HeroSection({
    super.key,
    this.onDonatePressed,
    this.onLearnMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 500),
      child: Stack(
        children: [
          // Red accent bar — right side
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: isMobile ? 20 : 80,
            child: Container(color: AppColors.primary),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppDimensions.spacingL : AppDimensions.spacingXXL * 2,
              vertical: AppDimensions.spacingXXL,
            ),
            child: isMobile ? _buildMobile() : _buildDesktop(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(double screenWidth) {
    return Row(
      children: [
        // Left — Image placeholder
        Expanded(
          flex: 4,
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: AppColors.greyLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_alt_rounded, size: 80, color: AppColors.greyLight),
                  SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'Foto Tim / Kegiatan',
                    style: TextStyle(color: AppColors.greyLight, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL),
        // Right — Text content
        Expanded(
          flex: 5,
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _c.getString('landing', 'hero.tagline'),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          color: AppColors.primary,
          child: Text(
            _c.getString('landing', 'hero.subtagline'),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingS,
          children: [
            ElevatedButton(
              onPressed: onDonatePressed,
              child: Text(_c.getString('landing', 'hero.cta_donate')),
            ),
            OutlinedButton(
              onPressed: onLearnMorePressed,
              child: Text(_c.getString('landing', 'hero.cta_learn_more')),
            ),
          ],
        ),
      ],
    );
  }
}
