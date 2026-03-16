import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/content/content_provider.dart';
import '../../../landing/presentation/widgets/responsive_layout.dart';

final _c = ContentProvider.instance;

/// Section daftar artikel/berita VIP.
class StoriesListSection extends StatelessWidget {
  const StoriesListSection({super.key});

  static const _categoryColors = {
    'Karier': Color(0xFF2E7D32),
    'Inspirasi': Color(0xFFE53935),
    'Partnership': Color(0xFF1565C0),
    'Kegiatan': Color(0xFF7B1FA2),
    'Transparansi': Color(0xFF00838F),
    'Pengumuman': Color(0xFFE65100),
    'Donatur': Color(0xFF795548),
    'Penghargaan': Color(0xFFFFC107),
    'Program': Color(0xFF37474F),
  };

  static const _categoryIcons = {
    'Karier': Icons.work_rounded,
    'Inspirasi': Icons.favorite_rounded,
    'Partnership': Icons.handshake_rounded,
    'Kegiatan': Icons.event_rounded,
    'Transparansi': Icons.assessment_rounded,
    'Pengumuman': Icons.campaign_rounded,
    'Donatur': Icons.volunteer_activism_rounded,
    'Penghargaan': Icons.emoji_events_rounded,
    'Program': Icons.school_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);
    final articles = _c.getMapList('stories', 'articles');

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? AppDimensions.spacingL
            : AppDimensions.spacingXXL * 2,
        vertical: AppDimensions.spacingXXL * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured article (first item)
          if (articles.isNotEmpty)
            _FeaturedCard(
              title: articles[0]['title'] ?? '',
              summary: articles[0]['summary'] ?? '',
              date: articles[0]['date'] ?? '',
              category: articles[0]['category'] ?? '',
              isMobile: isMobile,
            ),
          const SizedBox(height: AppDimensions.spacingXXL),
          // Grid of remaining articles
          if (articles.length > 1)
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isMobile ? 1 : (constraints.maxWidth > 900 ? 3 : 2);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: AppDimensions.spacingL,
                    crossAxisSpacing: AppDimensions.spacingL,
                    childAspectRatio: isMobile ? 2.5 : 1.15,
                  ),
                  itemCount: articles.length - 1,
                  itemBuilder: (context, index) {
                    final i = index + 1;
                    return _ArticleCard(
                      title: articles[i]['title'] ?? '',
                      summary: articles[i]['summary'] ?? '',
                      date: articles[i]['date'] ?? '',
                      category: articles[i]['category'] ?? '',
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Card artikel utama (featured).
class _FeaturedCard extends StatefulWidget {
  final String title;
  final String summary;
  final String date;
  final String category;
  final bool isMobile;

  const _FeaturedCard({
    required this.title,
    required this.summary,
    required this.date,
    required this.category,
    required this.isMobile,
  });

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = StoriesListSection._categoryColors[widget.category] ??
        AppColors.primary;
    final icon = StoriesListSection._categoryIcons[widget.category] ??
        Icons.article_rounded;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: _hovering ? color : AppColors.divider,
            width: _hovering ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovering
                  ? color.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: _hovering ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: widget.isMobile
              ? _buildMobileLayout(color, icon)
              : _buildDesktopLayout(color, icon),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(Color color, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — Image placeholder
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: Center(
            child: Icon(icon, size: 64, color: color.withValues(alpha: 0.3)),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXL),
        // Right — Content
        Expanded(child: _buildContent(color)),
      ],
    );
  }

  Widget _buildMobileLayout(Color color, IconData icon) {
    return _buildContent(color);
  }

  Widget _buildContent(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category badge
        _CategoryBadge(category: widget.category, color: color),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          widget.summary,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 14, color: AppColors.greyLight),
            const SizedBox(width: 6),
            Text(
              widget.date,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.greyLight),
            ),
            const Spacer(),
            Text(
              'Baca Selengkapnya →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Card artikel biasa.
class _ArticleCard extends StatefulWidget {
  final String title;
  final String summary;
  final String date;
  final String category;

  const _ArticleCard({
    required this.title,
    required this.summary,
    required this.date,
    required this.category,
  });

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = StoriesListSection._categoryColors[widget.category] ??
        AppColors.primary;
    final icon = StoriesListSection._categoryIcons[widget.category] ??
        Icons.article_rounded;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: _hovering ? color : AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovering
                  ? color.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: _hovering ? 16 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              // Category
              _CategoryBadge(category: widget.category, color: color),
              const SizedBox(height: AppDimensions.spacingS),
              // Title
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.spacingS),
              // Summary
              Expanded(
                child: Text(
                  widget.summary,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 12, color: AppColors.greyLight),
                  const SizedBox(width: 4),
                  Text(
                    widget.date,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.greyLight),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  final Color color;

  const _CategoryBadge({required this.category, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
