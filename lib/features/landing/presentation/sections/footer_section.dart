import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../widgets/vip_logo.dart';

/// Footer section.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.secondary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXXL,
        vertical: AppDimensions.spacingL,
      ),
      child: Column(
        children: [
          const VipLogo(height: 28, showText: false, onDark: true),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            '\u00a9 2026 Yayasan Vernon Indonesia Pintar. All rights reserved.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
