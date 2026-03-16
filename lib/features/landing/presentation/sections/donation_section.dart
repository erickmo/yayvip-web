import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Sistem Donasi — mudah & fleksibel.
class DonationSection extends StatelessWidget {
  const DonationSection({super.key});

  static const _featureIcons = [
    Icons.volunteer_activism_rounded,
    Icons.verified_rounded,
    Icons.phone_android_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final features = _c.getMapList('landing', 'donation.features');

    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Column(
        children: [
          // Top red bar
          Container(width: double.infinity, height: 4, color: AppColors.primary),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? AppDimensions.spacingL
                  : AppDimensions.spacingXXL * 2,
              vertical: AppDimensions.spacingXXL * 1.5,
            ),
            child: Column(
              children: [
                SectionTitle(
                  title: _c.getString('landing', 'donation.title'),
                  subtitle: _c.getString('landing', 'donation.tagline'),
                ),
                const SizedBox(height: AppDimensions.spacingXXL),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isMobile) {
                      return Column(
                        children: List.generate(
                          features.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimensions.spacingM),
                            child: _DonationFeatureCard(
                              icon: _featureIcons[i],
                              title: features[i]['title'] ?? '',
                              description: features[i]['description'] ?? '',
                            ),
                          ),
                        ),
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        features.length,
                        (i) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: i > 0 ? AppDimensions.spacingM : 0,
                            ),
                            child: _DonationFeatureCard(
                              icon: _featureIcons[i],
                              title: features[i]['title'] ?? '',
                              description: features[i]['description'] ?? '',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _DonationFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
