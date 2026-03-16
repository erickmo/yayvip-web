import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section 2: Alur beasiswa dan syarat.
class ScholarshipFlowSection extends StatelessWidget {
  const ScholarshipFlowSection({super.key});

  static const _flowIcons = [
    Icons.app_registration_rounded,
    Icons.fact_check_rounded,
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
        horizontal: isMobile
            ? AppDimensions.spacingL
            : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        children: [
          // Alur Beasiswa
          SectionTitle(
            title: _c.getString('scholarship', 'flow.title'),
            subtitle: _c.getString('scholarship', 'flow.subtitle'),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          _buildFlowSteps(isMobile),
          const SizedBox(height: AppDimensions.spacingXXL * 2),
          // Syarat
          _buildRequirements(isMobile),
        ],
      ),
    );
  }

  Widget _buildFlowSteps(bool isMobile) {
    final steps = _c.getMapList('scholarship', 'flow.steps');

    if (isMobile) {
      return Column(
        children: List.generate(steps.length, (i) => _buildStepVertical(i, steps)),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (i) {
        return Expanded(
          child: Row(
            children: [
              Expanded(child: _buildStepHorizontal(i, steps)),
              if (i < steps.length - 1)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Icon(Icons.arrow_forward_rounded,
                      color: AppColors.primary, size: 24),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepHorizontal(int index, List<Map<String, dynamic>> steps) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(_flowIcons[index], size: 28, color: Colors.white),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          steps[index]['title'] ?? '',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            steps[index]['description'] ?? '',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStepVertical(int index, List<Map<String, dynamic>> steps) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(_flowIcons[index], size: 24, color: Colors.white),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${steps[index]['title'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      steps[index]['description'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (index < steps.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Container(
                width: 2,
                height: 24,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequirements(bool isMobile) {
    final requirements = _c.getStringList('scholarship', 'flow.requirements');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.darkOverlay,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist_rounded, color: AppColors.primary, size: 28),
              SizedBox(width: AppDimensions.spacingM),
              Text(
                'Syarat Pendaftaran',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          ...requirements.map((req) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        req,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.85),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
