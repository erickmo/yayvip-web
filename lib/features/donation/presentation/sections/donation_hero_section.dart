import 'package:flutter/material.dart';

import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';
import '../widgets/hero_slider.dart';

final _c = ContentProvider.instance;

/// Section 1: Hero slider dengan gambar dan caption.
class DonationHeroSection extends StatelessWidget {
  const DonationHeroSection({super.key});

  static const _slideIcons = [
    Icons.volunteer_activism_rounded,
    Icons.school_rounded,
    Icons.people_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final heroSlides = _c.getMapList('donation', 'hero_slides');

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
