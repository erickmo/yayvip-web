import 'package:flutter/material.dart';

import '../../../../core/content/content_provider.dart';
import '../../../donation/presentation/widgets/hero_slider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';

final _c = ContentProvider.instance;

/// Section 1: Hero slider beasiswa.
class ScholarshipHeroSection extends StatelessWidget {
  const ScholarshipHeroSection({super.key});

  static const _slideIcons = [
    Icons.school_rounded,
    Icons.work_rounded,
    Icons.trending_up_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final heroSlides = _c.getMapList('scholarship', 'hero_slides');

    return HeroSlider(
      height: isMobile ? 320 : 450,
      slides: List.generate(heroSlides.length, (i) {
        return HeroSlideData(
          icon: _slideIcons[i],
          caption: heroSlides[i]['caption'] ?? '',
          subcaption: heroSlides[i]['subcaption'] ?? '',
        );
      }),
    );
  }
}
