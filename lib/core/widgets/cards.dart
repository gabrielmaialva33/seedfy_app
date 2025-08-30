import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

// Helper functions for plant UI
List<Color> _getPlantGradient(String title) {
  switch (title.toLowerCase()) {
    case 'alface crespa':
      return [
        const Color(0xFF4CAF50), // Verde vibrante
        const Color(0xFF8BC34A),
        const Color(0xFFCDDC39),
      ];
    case 'tomate cereja':
      return [
        const Color(0xFFE53935), // Vermelho vibrante
        const Color(0xFFFF5722),
        const Color(0xFFFF9800),
      ];
    case 'manjericão':
      return [
        const Color(0xFF2E7D32), // Verde escuro
        const Color(0xFF388E3C),
        const Color(0xFF66BB6A),
      ];
    case 'cenoura':
      return [
        const Color(0xFFFF9800), // Laranja vibrante
        const Color(0xFFFFB74D),
        const Color(0xFFFFC107),
      ];
    default:
      return [
        const Color(0xFF6A1B9A), // Roxo
        const Color(0xFF8E24AA),
        const Color(0xFFAB47BC),
      ];
  }
}

String _getPlantEmoji(String title) {
  switch (title.toLowerCase()) {
    case 'alface crespa':
      return '🥬';
    case 'tomate cereja':
      return '🍅';
    case 'manjericão':
      return '🌿';
    case 'cenoura':
      return '🥕';
    default:
      return '🌱';
  }
}

String _getPlantSubtitle(String title) {
  switch (title.toLowerCase()) {
    case 'alface crespa':
      return 'FRESH\nLETTUCE';
    case 'tomate cereja':
      return 'CHERRY\nTOMATO';
    case 'manjericão':
      return 'BASIL\nHERBS';
    case 'cenoura':
      return 'ORGANIC\nCARROT';
    default:
      return 'GARDEN\nPLANT';
  }
}

List<Color> _getStoryGradient(String label) {
  switch (label.toLowerCase()) {
    case 'adicionar':
      return [const Color(0xFF6A1B9A), const Color(0xFF9C27B0)];
    case 'alfaces':
      return [const Color(0xFF2E7D32), const Color(0xFF4CAF50)];
    case 'tomates':
      return [const Color(0xFFD32F2F), const Color(0xFFFF5722)];
    case 'cenouras':
      return [const Color(0xFFFF8F00), const Color(0xFFFFB300)];
    case 'ervas':
      return [const Color(0xFF388E3C), const Color(0xFF66BB6A)];
    case 'flores':
      return [const Color(0xFFE91E63), const Color(0xFFFF4081)];
    default:
      return [const Color(0xFF6A1B9A), const Color(0xFF9C27B0)];
  }
}

IconData _getPlantIcon(String label) {
  switch (label.toLowerCase()) {
    case 'adicionar':
      return Icons.add_circle_outline;
    case 'alfaces':
      return Icons.grass;
    case 'tomates':
      return Icons.circle;
    case 'cenouras':
      return Icons.agriculture;
    case 'ervas':
      return Icons.local_florist;
    case 'flores':
      return Icons.local_florist;
    default:
      return Icons.eco;
  }
}

class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.gradient,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.cardGradient,
        borderRadius: AppTheme.cardRadius,
        boxShadow: elevation != null 
          ? (elevation! > 0 ? AppTheme.cardShadow : null)
          : AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.cardRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? height;
  final double? width;

  const GradientCard({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding,
    this.margin,
    this.onTap,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
        borderRadius: AppTheme.cardRadius,
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.cardRadius,
          child: Container(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(duration: 400.ms)
    .scale(begin: const Offset(0.9, 0.9))
    .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.2));
  }
}

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;
  final bool isFavorite;

  const PlantCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    this.onTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem com aspect ratio 4:3 (Instagram style)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: _getPlantGradient(title),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getPlantGradient(title)[0].withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Placeholder com emoji personalizado
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getPlantEmoji(title),
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getPlantSubtitle(title),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padrão decorativo
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: AppTheme.smallStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Botão de favorito
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFavorite ? AppTheme.errorRed : AppTheme.textGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Conteúdo do card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.titleStyle.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.captionStyle.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Indicadores de progresso (estilo iFood)
                Row(
                  children: [
                    Expanded(
                      child: _buildProgressIndicator(),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppTheme.textGray,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms, delay: 200.ms)
    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
    .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.3));
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: AppTheme.backgroundLight,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.7, // 70% de progresso
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: AppTheme.primaryGradient,
          ),
        ),
      ),
    )
    .animate()
    .scaleX(
      duration: 1500.ms,
      delay: 800.ms,
      curve: Curves.elasticOut,
    )
    .shimmer(
      duration: 2000.ms,
      delay: 1000.ms,
      color: Colors.white.withValues(alpha: 0.5),
    );
  }
}

class StoryCircle extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;
  final bool hasNewStory;
  final Color? borderColor;

  const StoryCircle({
    super.key,
    required this.imageUrl,
    required this.label,
    this.onTap,
    this.hasNewStory = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasNewStory 
                  ? AppTheme.primaryGradient
                  : null,
                border: !hasNewStory 
                  ? Border.all(color: AppTheme.textGray.withValues(alpha: 0.3), width: 2)
                  : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: _getStoryGradient(label),
                  ),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: _getStoryGradient(label)[0].withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getPlantIcon(label),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: AppTheme.smallStyle.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    )
    .animate(delay: (200 * 1).ms)
    .fadeIn(duration: 500.ms)
    .scale(begin: const Offset(0.5, 0.5))
    .then()
    .shimmer(duration: 2000.ms, color: hasNewStory ? Colors.purple.withValues(alpha: 0.4) : Colors.transparent);
  }





}