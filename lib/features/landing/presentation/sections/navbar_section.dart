import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/vip_logo.dart';

/// Navbar section — fixed di atas halaman.
class NavbarSection extends StatelessWidget {
  final Function(String) onNavTap;

  const NavbarSection({super.key, required this.onNavTap});

  static const _navItems = [
    AppStrings.navHome,
    AppStrings.navScholarship,
    AppStrings.navStories,
    AppStrings.navPartnership,
    AppStrings.navDonation,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? AppDimensions.spacingM : AppDimensions.spacingXXL,
        vertical: AppDimensions.spacingM,
      ),
      child: Row(
        children: [
          const VipLogo(height: 36),
          const Spacer(),
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => _showMobileMenu(context),
            )
          else
            Row(
              children: _navItems
                  .map((item) => _NavItem(
                        label: item,
                        onTap: () => onNavTap(item),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _navItems
              .map((item) => ListTile(
                    title: Text(item),
                    onTap: () {
                      Navigator.pop(context);
                      onNavTap(item);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _hovering ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
