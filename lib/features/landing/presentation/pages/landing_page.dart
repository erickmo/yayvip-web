import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';
import '../sections/navbar_section.dart';
import '../sections/hero_section.dart';
import '../sections/intro_section.dart';
import '../sections/vision_mission_section.dart';
import '../sections/criteria_section.dart';
import '../sections/scholarship_section.dart';
import '../sections/donation_section.dart';
import '../sections/realtime_section.dart';
import '../sections/contact_section.dart';
import '../sections/footer_section.dart';

/// Landing page utama website Vernon Indonesia Pintar.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();

  // Keys untuk setiap section agar bisa di-scroll
  final _sectionKeys = {
    AppStrings.navHome: GlobalKey(),
    AppStrings.navAbout: GlobalKey(),
    AppStrings.navProgram: GlobalKey(),
    AppStrings.navDonation: GlobalKey(),
    AppStrings.navContact: GlobalKey(),
  };

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    // Navigasi ke halaman terpisah
    const routeMap = {
      AppStrings.navDonation: '/donasi',
      AppStrings.navScholarship: '/beasiswa',
      AppStrings.navStories: '/cerita',
      AppStrings.navPartnership: '/partnership',
    };
    if (routeMap.containsKey(section)) {
      context.go(routeMap[section]!);
      return;
    }
    final key = _sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed Navbar
          NavbarSection(onNavTap: _scrollToSection),
          const Divider(height: 1),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Hero
                  Container(
                    key: _sectionKeys[AppStrings.navHome],
                    child: HeroSection(
                      onDonatePressed: () =>
                          _scrollToSection(AppStrings.navDonation),
                      onLearnMorePressed: () =>
                          _scrollToSection(AppStrings.navAbout),
                    ),
                  ),
                  // Introduction
                  Container(
                    key: _sectionKeys[AppStrings.navAbout],
                    child: const IntroSection(),
                  ),
                  // Vision & Mission
                  const VisionMissionSection(),
                  // Kriteria Beasiswa
                  Container(
                    key: _sectionKeys[AppStrings.navProgram],
                    child: const CriteriaSection(),
                  ),
                  // Sistem Beasiswa
                  const ScholarshipSection(),
                  // Donasi
                  Container(
                    key: _sectionKeys[AppStrings.navDonation],
                    child: const DonationSection(),
                  ),
                  // Realtime Check
                  const RealtimeSection(),
                  // Contact
                  Container(
                    key: _sectionKeys[AppStrings.navContact],
                    child: const ContactSection(),
                  ),
                  // Footer
                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
