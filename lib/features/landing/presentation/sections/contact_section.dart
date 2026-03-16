import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section Contact — informasi kontak yayasan.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
        // Left — Title & image placeholder
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: _c.getString('landing', 'contact.title'),
                subtitle: _c.getString('landing', 'contact.subtitle'),
                onDark: true,
                alignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: AppDimensions.spacingXL),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
                child: const Center(
                  child: Icon(Icons.support_agent_rounded,
                      size: 80, color: Colors.white24),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXXL * 1.5),
        // Right — Contact info
        Expanded(
          flex: 5,
          child: _buildContactInfo(),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: _c.getString('landing', 'contact.title'),
          subtitle: _c.getString('landing', 'contact.subtitle'),
          onDark: true,
          alignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        _buildContactInfo(),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Office Address
        const Text(
          'Office Address',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _ContactItem(
          icon: Icons.location_on_rounded,
          text: _c.getString('landing', 'contact.address'),
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        // Hotline
        const Text(
          'Hotline',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _ContactItem(
          icon: Icons.language_rounded,
          text: _c.getString('landing', 'contact.website'),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _ContactItem(
          icon: Icons.email_rounded,
          text: _c.getString('landing', 'contact.email'),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _ContactItem(
          icon: Icons.camera_alt_rounded,
          text: '@${_c.getString('landing', 'contact.instagram')}',
          label: 'Instagram',
        ),
        const SizedBox(height: AppDimensions.spacingS),
        _ContactItem(
          icon: Icons.music_note_rounded,
          text: '@${_c.getString('landing', 'contact.tiktok')}',
          label: 'TikTok',
        ),
      ],
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? label;

  const _ContactItem({
    required this.icon,
    required this.text,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
