import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Sistem Beasiswa — alur pelatihan, magang, kerja.
class ScholarshipSection extends StatelessWidget {
  const ScholarshipSection({super.key});

  static const _stepIcons = [
    Icons.menu_book_rounded,
    Icons.work_rounded,
    Icons.trending_up_rounded,
  ];

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
      child: isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — Description
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: _c.getString('landing', 'scholarship.title'),
                alignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              Text(
                _c.getString('landing', 'scholarship.description'),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL * 1.5),
        // Right — Steps
        Expanded(
          flex: 3,
          child: _buildSteps(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'scholarship.title'),
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Text(
          _c.getString('landing', 'scholarship.description'),
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        _buildSteps(),
      ],
    );
  }

  Widget _buildSteps() {
    final steps = _c.getMapList('landing', 'scholarship.steps');

    return Column(
      children: List.generate(steps.length, (index) {
        return Column(
          children: [
            _StepCard(
              icon: _stepIcons[index],
              title: steps[index]['title'] ?? '',
              description: steps[index]['description'] ?? '',
              stepNumber: index + 1,
            ),
            if (index < steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _StepCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int stepNumber;

  const _StepCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
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
