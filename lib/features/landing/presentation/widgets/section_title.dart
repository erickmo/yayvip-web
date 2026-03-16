import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Widget judul section yang konsisten di seluruh landing page.
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool onDark;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.onDark = false,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: onDark ? Colors.white : AppColors.textPrimary,
            height: 1.2,
          ),
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 18,
              color: onDark
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: alignment == CrossAxisAlignment.center
                ? TextAlign.center
                : TextAlign.start,
          ),
        ],
        const SizedBox(height: AppDimensions.spacingM),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
