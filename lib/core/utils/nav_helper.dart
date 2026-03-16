import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';

/// Helper navigasi dari navbar untuk halaman-halaman selain landing.
/// [currentRoute] — route halaman saat ini (contoh: '/donasi').
void handleNavTap(
  BuildContext context,
  String section,
  String currentRoute,
  ScrollController scrollController,
) {
  const routeMap = {
    AppStrings.navDonation: '/donasi',
    AppStrings.navScholarship: '/beasiswa',
    AppStrings.navStories: '/cerita',
    AppStrings.navPartnership: '/partnership',
  };

  // Jika tap menu yang sama dengan halaman saat ini, scroll ke atas
  if (routeMap[section] == currentRoute) {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut);
    return;
  }

  // Navigasi ke route lain
  if (routeMap.containsKey(section)) {
    context.go(routeMap[section]!);
    return;
  }

  // Default: kembali ke landing
  context.go('/');
}
