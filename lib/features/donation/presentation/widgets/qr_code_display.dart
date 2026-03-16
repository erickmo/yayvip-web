import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Tampilan QR Code untuk pembayaran donasi.
class QrCodeDisplay extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onBackPressed;

  const QrCodeDisplay({
    super.key,
    required this.title,
    required this.description,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
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
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        // QR Code placeholder
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.divider, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // QR icon placeholder
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    size: 120,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Scan instruction
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.smartphone_rounded, size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Scan dengan e-wallet / mobile banking',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Back button (jika dari form named donor)
        if (onBackPressed != null) ...[
          const SizedBox(height: AppDimensions.spacingL),
          TextButton.icon(
            onPressed: onBackPressed,
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Kembali ke Form'),
          ),
        ],
      ],
    );
  }
}
