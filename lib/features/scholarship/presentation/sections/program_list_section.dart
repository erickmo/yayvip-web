import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../../../landing/presentation/widgets/section_title.dart';

final _c = ContentProvider.instance;

/// Section 3: List program beasiswa.
class ProgramListSection extends StatelessWidget {
  const ProgramListSection({super.key});

  static const _programIcons = [
    Icons.coffee_rounded,
    Icons.campaign_rounded,
    Icons.business_center_rounded,
    Icons.palette_rounded,
    Icons.computer_rounded,
    Icons.restaurant_rounded,
  ];

  static const _programColors = [
    Color(0xFF795548),
    Color(0xFF1565C0),
    Color(0xFF37474F),
    Color(0xFF7B1FA2),
    Color(0xFF00838F),
    Color(0xFFE65100),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final isTablet = ResponsiveLayout.isTablet(context);
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
    final programs = _c.getMapList('scholarship', 'programs.items');

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDimensions.spacingL
            : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        children: [
          SectionTitle(
            title: _c.getString('scholarship', 'programs.title'),
            subtitle: _c.getString('scholarship', 'programs.subtitle'),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppDimensions.spacingL,
              crossAxisSpacing: AppDimensions.spacingL,
              childAspectRatio: isMobile ? 2.2 : 1.1,
            ),
            itemCount: programs.length,
            itemBuilder: (context, index) => _ProgramCard(
              icon: _programIcons[index],
              color: _programColors[index],
              name: programs[index]['name'] ?? '',
              description: programs[index]['description'] ?? '',
              duration: programs[index]['duration'] ?? '',
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final String duration;

  const _ProgramCard({
    required this.icon,
    required this.color,
    required this.name,
    required this.description,
    required this.duration,
  });

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
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
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + Title
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(widget.icon, size: 24, color: widget.color),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
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
            const SizedBox(height: AppDimensions.spacingS),
            // Duration badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
                vertical: AppDimensions.spacingXS,
              ),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded, size: 14, color: widget.color),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      widget.duration,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: widget.color,
                      ),
                      overflow: TextOverflow.ellipsis,
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
