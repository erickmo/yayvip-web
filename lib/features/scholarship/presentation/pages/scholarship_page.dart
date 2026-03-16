import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/nav_helper.dart';
import '../../../landing/presentation/sections/footer_section.dart';
import '../../../landing/presentation/sections/navbar_section.dart';
import '../cubits/scholarship_form_cubit.dart';
import '../sections/program_list_section.dart';
import '../sections/scholarship_flow_section.dart';
import '../sections/scholarship_form_section.dart';
import '../sections/scholarship_hero_section.dart';

/// Halaman beasiswa — hero, alur, program, form pendaftaran.
class ScholarshipPage extends StatefulWidget {
  const ScholarshipPage({super.key});

  @override
  State<ScholarshipPage> createState() => _ScholarshipPageState();
}

class _ScholarshipPageState extends State<ScholarshipPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScholarshipFormCubit(),
      child: Scaffold(
        body: Column(
          children: [
            NavbarSection(
              onNavTap: (s) =>
                  handleNavTap(context, s, '/beasiswa', _scrollController),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: const Column(
                  children: [
                    ScholarshipHeroSection(),
                    ScholarshipFlowSection(),
                    ProgramListSection(),
                    ScholarshipFormSection(),
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
