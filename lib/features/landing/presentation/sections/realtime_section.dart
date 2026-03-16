import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Realtime Check — transparansi donasi.
class RealtimeSection extends StatelessWidget {
  const RealtimeSection({super.key});

  static const _icons = [
    Icons.account_balance_wallet_rounded,
    Icons.smartphone_rounded,
    Icons.assessment_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Stack(
        children: [
          // Red accent bar — right side
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: isMobile ? 12 : 40,
            child: Container(color: AppColors.primary),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? AppDimensions.spacingL
                  : AppDimensions.spacingXXL * 2,
              vertical: AppDimensions.spacingXXL * 1.5,
            ),
            child: isMobile ? _buildMobile() : _buildDesktop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — Image placeholder
        Expanded(
          flex: 4,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: AppColors.greyLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tablet_mac_rounded, size: 80, color: AppColors.greyLight),
                  SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'Screenshot Aplikasi',
                    style: TextStyle(color: AppColors.greyLight, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL),
        // Right — Content
        Expanded(
          flex: 5,
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return _buildContent();
  }

  Widget _buildContent() {
    final features = _c.getMapList('landing', 'realtime.features');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'realtime.title'),
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        ...List.generate(features.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingL),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(_icons[index], size: 24, color: AppColors.primary),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        features[index]['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        features[index]['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
