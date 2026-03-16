import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section kontak partnership — CTA dan nomor yang bisa dihubungi.
class PartnershipContactSection extends StatelessWidget {
  const PartnershipContactSection({super.key});

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
        // Left — CTA
        Expanded(
          flex: 5,
          child: _buildCta(),
        ),
        const SizedBox(width: AppDimensions.spacingXXL * 1.5),
        // Right — Contact cards
        Expanded(
          flex: 4,
          child: _buildContactCards(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        _buildCta(),
        const SizedBox(height: AppDimensions.spacingXXL),
        _buildContactCards(),
      ],
    );
  }

  Widget _buildCta() {
    final stats = _c.getMapList('partnership', 'contact.stats');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('partnership', 'contact.cta_title'),
          subtitle: _c.getString('partnership', 'contact.cta_desc'),
          onDark: true,
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        // Stats
        Row(
          children: stats.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                left: entry.key > 0 ? AppDimensions.spacingL : 0,
              ),
              child: _StatBadge(
                value: entry.value['value'] ?? '',
                label: entry.value['label'] ?? '',
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactCards() {
    return Column(
      children: [
        _ContactCard(
          icon: Icons.phone_rounded,
          title: 'Telepon / WhatsApp',
          value: _c.getString('partnership', 'contact.phone'),
          subtitle: _c.getString('partnership', 'contact.phone_hours'),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _ContactCard(
          icon: Icons.email_rounded,
          title: 'Email',
          value: _c.getString('partnership', 'contact.email'),
          subtitle: _c.getString('partnership', 'contact.email_note'),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _ContactCard(
          icon: Icons.location_on_rounded,
          title: 'Kantor',
          value: _c.getString('partnership', 'contact.address'),
          subtitle: _c.getString('partnership', 'contact.address_note'),
        ),
      ],
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;

  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.4),
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
