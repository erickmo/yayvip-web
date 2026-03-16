import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/nav_helper.dart';
import '../../../landing/presentation/sections/footer_section.dart';
import '../../../landing/presentation/sections/navbar_section.dart';
import '../cubits/donation_form_cubit.dart';
import '../sections/app_download_section.dart';
import '../sections/donation_form_section.dart';
import '../sections/donation_hero_section.dart';

/// Halaman donasi — hero slider, form, dan CTA download app.
class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DonationFormCubit(),
      child: Scaffold(
        body: Column(
          children: [
            NavbarSection(
              onNavTap: (s) =>
                  handleNavTap(context, s, '/donasi', _scrollController),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: const Column(
                  children: [
                    DonationHeroSection(),
                    DonationFormSection(),
                    AppDownloadSection(),
                    FooterSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
