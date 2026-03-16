import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section jenis-jenis kemitraan.
class PartnershipTypesSection extends StatelessWidget {
  const PartnershipTypesSection({super.key});

  static const _icons = [
    Icons.business_rounded,
    Icons.work_rounded,
    Icons.handshake_rounded,
    Icons.school_rounded,
    Icons.campaign_rounded,
    Icons.account_balance_rounded,
  ];

  static const _colors = [
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFFE65100),
    Color(0xFF7B1FA2),
    Color(0xFFE53935),
    Color(0xFF37474F),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final partnershipItems = _c.getMapList('partnership', 'types.items');

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
          SectionTitle(
            title: _c.getString('partnership', 'types.title'),
            subtitle: _c.getString('partnership', 'types.subtitle'),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppDimensions.spacingL,
              crossAxisSpacing: AppDimensions.spacingL,
              childAspectRatio: isMobile ? 1.8 : 0.85,
            ),
            itemCount: partnershipItems.length,
            itemBuilder: (context, index) => _PartnershipCard(
              icon: _icons[index],
              color: _colors[index],
              name: partnershipItems[index]['name'] ?? '',
              description: partnershipItems[index]['description'] ?? '',
              benefits: partnershipItems[index]['benefits'] ?? '',
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnershipCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final String benefits;

  const _PartnershipCard({
    required this.icon,
    required this.color,
    required this.name,
    required this.description,
    required this.benefits,
  });

  @override
  State<_PartnershipCard> createState() => _PartnershipCardState();
}

class _PartnershipCardState extends State<_PartnershipCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: _hovering ? widget.color : AppColors.divider,
            width: _hovering ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovering
                  ? widget.color.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: _hovering ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Icon(widget.icon, size: 26, color: widget.color),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Title
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            // Description
            Expanded(
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Benefits
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.06),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.star_rounded,
                      size: 16, color: widget.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.benefits,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.color,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
