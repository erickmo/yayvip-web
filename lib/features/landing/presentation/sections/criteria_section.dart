import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Kriteria Penerima Beasiswa.
class CriteriaSection extends StatelessWidget {
  const CriteriaSection({super.key});

  static const _icons = [
    Icons.handshake_rounded,
    Icons.school_rounded,
    Icons.favorite_rounded,
    Icons.lightbulb_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final crossAxisCount = isMobile ? 2 : (isTablet ? 2 : 4);
    final criteriaItems = _c.getMapList('landing', 'criteria.items');

    return Container(
      width: double.infinity,
      color: AppColors.darkOverlay,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppDimensions.spacingL : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        children: [
          SectionTitle(
            title: _c.getString('landing', 'criteria.title'),
            onDark: true,
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppDimensions.spacingL,
              crossAxisSpacing: AppDimensions.spacingL,
              childAspectRatio: isMobile ? 0.9 : 1.0,
            ),
            itemCount: criteriaItems.length,
            itemBuilder: (context, index) => _CriteriaCard(
              icon: _icons[index],
              title: criteriaItems[index]['title'] ?? '',
              description: criteriaItems[index]['description'] ?? '',
            ),
          ),
        ],
      ),
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _CriteriaCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 36, color: Colors.white),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Flexible(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
