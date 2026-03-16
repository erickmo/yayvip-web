import 'package:flutter/material.dart';

import '../../../../core/utils/nav_helper.dart';
import '../../../landing/presentation/sections/footer_section.dart';
import '../../../landing/presentation/sections/navbar_section.dart';
import '../sections/stories_hero_section.dart';
import '../sections/stories_list_section.dart';

/// Halaman cerita VIP — blog berita terbaru dari yayasan.
class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
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
                handleNavTap(context, s, '/cerita', _scrollController),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: const Column(
                children: [
                  StoriesHeroSection(),
                  StoriesListSection(),
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
