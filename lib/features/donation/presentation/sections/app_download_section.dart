import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section 3: CTA download aplikasi VIP.
class AppDownloadSection extends StatelessWidget {
  const AppDownloadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.darkOverlay,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDimensions.spacingL
            : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left — Phone mockup placeholder
        Expanded(
          flex: 4,
          child: Center(
            child: Container(
              width: 260,
              height: 460,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_android_rounded,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'VIP App',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
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
    final features = _c.getStringList('donation', 'app_download.features');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('donation', 'app_download.title'),
          subtitle: _c.getString('donation', 'app_download.subtitle'),
          onDark: true,
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        // Features list
        ...features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      feature,
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
        const SizedBox(height: AppDimensions.spacingXL),
        // Store badges
        Text(
          _c.getString('donation', 'app_download.cta'),
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        const Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingS,
          children: [
            _StoreBadge(
              icon: Icons.apple_rounded,
              storeName: 'App Store',
              label: 'Download on the',
            ),
            _StoreBadge(
              icon: Icons.play_arrow_rounded,
              storeName: 'Google Play',
              label: 'GET IT ON',
            ),
          ],
        ),
      ],
    );
  }
}

class _StoreBadge extends StatefulWidget {
  final IconData icon;
  final String storeName;
  final String label;

  const _StoreBadge({
    required this.icon,
    required this.storeName,
    required this.label,
  });

  @override
  State<_StoreBadge> createState() => _StoreBadgeState();
}

class _StoreBadgeState extends State<_StoreBadge> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingL,
          vertical: AppDimensions.spacingM,
        ),
        decoration: BoxDecoration(
          color:
              _hovering ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 32, color: Colors.white),
            const SizedBox(width: AppDimensions.spacingS),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1,
                  ),
                ),
                Text(
                  widget.storeName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
