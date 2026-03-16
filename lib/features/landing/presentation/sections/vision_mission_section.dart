import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Visi & Misi.
class VisionMissionSection extends StatelessWidget {
  const VisionMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppDimensions.spacingL : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        children: [
          // Vision
          if (isMobile) _buildVisionMobile() else _buildVisionDesktop(),
          const SizedBox(height: AppDimensions.spacingXXL * 2),
          // Mission
          _buildMission(isMobile),
        ],
      ),
    );
  }

  Widget _buildVisionDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — Image placeholder
        Expanded(
          flex: 4,
          child: Container(
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.greyLight.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.divider),
            ),
            child: const Center(
              child: Icon(Icons.visibility_rounded, size: 80, color: AppColors.greyLight),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL),
        // Right — Vision text
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: _c.getString('landing', 'vision.title'),
                alignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              Text(
                _c.getString('landing', 'vision.description'),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisionMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'vision.title'),
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Text(
          _c.getString('landing', 'vision.description'),
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
      ],
    );
  }

  Widget _buildMission(bool isMobile) {
    final missionItems = _c.getStringList('landing', 'mission.items');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'mission.title'),
          alignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        ...missionItems.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
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
