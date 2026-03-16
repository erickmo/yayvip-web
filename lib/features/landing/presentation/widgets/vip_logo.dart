import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Logo VIP sesuai branding proposal.
/// "V" merah, "I" hitam, "P" hitam + teks "VERNON INDONESIA PINTAR" merah.
class VipLogo extends StatelessWidget {
  final double height;
  final bool showText;
  final bool onDark;

  const VipLogo({
    super.key,
    this.height = 40,
    this.showText = true,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = onDark ? Colors.white : AppColors.textPrimary;
    final scale = height / 40;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // VIP Letters
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // V — Red with checkmark style
            Text(
              'V',
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1,
              ),
            ),
            // I — Black
            Text(
              'I',
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1,
              ),
            ),
            // P — Black
            Text(
              'P',
              style: TextStyle(
                fontSize: 36 * scale,
                fontWeight: FontWeight.w900,
                color: textColor,
                height: 1,
              ),
            ),
          ],
        ),
        if (showText) ...[
          SizedBox(width: 8 * scale),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VERNON',
                style: TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1,
                  height: 1.2,
                ),
              ),
              Text(
                'INDONESIA',
                style: TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1,
                  height: 1.2,
                ),
              ),
              Text(
                'PINTAR',
                style: TextStyle(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
