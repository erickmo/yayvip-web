import 'package:flutter/material.dart';

import '../../../../core/utils/nav_helper.dart';
import '../../../landing/presentation/sections/footer_section.dart';
import '../../../landing/presentation/sections/navbar_section.dart';
import '../sections/partnership_contact_section.dart';
import '../sections/partnership_hero_section.dart';
import '../sections/partnership_types_section.dart';

/// Halaman partnership — hero, jenis kemitraan, dan kontak.
class PartnershipPage extends StatefulWidget {
  const PartnershipPage({super.key});

  @override
  State<PartnershipPage> createState() => _PartnershipPageState();
}

class _PartnershipPageState extends State<PartnershipPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavbarSection(
            onNavTap: (s) =>
                handleNavTap(context, s, '/partnership', _scrollController),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: const Column(
                children: [
                  PartnershipHeroSection(),
                  PartnershipTypesSection(),
                  PartnershipContactSection(),
                  FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
