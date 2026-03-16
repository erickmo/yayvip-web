import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Introduction — tentang yayasan.
class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.darkOverlay,
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
        // Left — Text
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: _c.getString('landing', 'intro.title'),
                onDark: true,
                alignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              Text(
                _c.getString('landing', 'intro.description'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                _c.getString('landing', 'intro.description2'),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL),
        // Right — Image placeholder
        Expanded(
          flex: 4,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: Colors.white24),
            ),
            child: const Center(
              child: Icon(Icons.school_rounded, size: 80, color: Colors.white24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'intro.title'),
          onDark: true,
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Text(
          _c.getString('landing', 'intro.description'),
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.7,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          _c.getString('landing', 'intro.description2'),
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.9),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
