import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/donation/presentation/pages/donation_page.dart';
import '../../features/donatur/presentation/pages/register_donatur_page.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/partnership/presentation/pages/partnership_page.dart';
import '../../features/scholarship/presentation/pages/scholarship_page.dart';
import '../../features/stories/presentation/pages/stories_page.dart';

/// Router aplikasi menggunakan go_router.
class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
      ),
      GoRoute(
        path: '/donasi',
        builder: (context, state) => const DonationPage(),
      ),
      GoRoute(
        path: '/beasiswa',
        builder: (context, state) => const ScholarshipPage(),
      ),
      GoRoute(
        path: '/cerita',
        builder: (context, state) => const StoriesPage(),
      ),
      GoRoute(
        path: '/partnership',
        builder: (context, state) => const PartnershipPage(),
      ),
      GoRoute(
        path: '/daftar-donatur',
        builder: (context, state) => const RegisterDonaturPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  );
}
