import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/modern_card.dart';

class ModernProfileScreen extends StatefulWidget {
  const ModernProfileScreen({super.key});

  @override
  State<ModernProfileScreen> createState() => _ModernProfileScreenState();
}

class _ModernProfileScreenState extends State<ModernProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildHeader(),
                  _buildStatsCards(),
                  _buildAchievements(),
                  _buildMenuOptions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar grande com gradiente (estilo Nubank)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.primaryGradient,
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.person,
                  size: 48,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nome e nível
            Text(
              'Gabriel Maia',
              style: AppTheme.headingStyle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🌱 Jardineiro Experiente • Nível 7',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Suas Estatísticas',
              style: AppTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '24',
                    'Plantas\nCultivadas',
                    const [AppTheme.primaryGreen, Color(0xFF34D399)],
                    Icons.eco,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '12',
                    'Colheitas\nRealizadas',
                    const [AppTheme.accentOrange, Color(0xFFFF8A80)],
                    Icons.agriculture,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    '89%',
                    'Taxa de\nSucesso',
                    const [AppTheme.primaryPurple, Color(0xFF9F7AEA)],
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    '156',
                    'Dias\nJardingando',
                    const [Color(0xFF06B6D4), Color(0xFF67E8F9)],
                    Icons.calendar_today,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, List<Color> colors, IconData icon) {
    return GradientCard(
      colors: colors,
      height: 100,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Conquistas Recentes 🏆',
              style: AppTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ModernCard(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.eco,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primeira Colheita',
                          style: AppTheme.titleStyle,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Parabéns pela sua primeira colheita de alface!',
                          style: AppTheme.captionStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Novo',
                      style: TextStyle(
                        color: AppTheme.successGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configurações',
              style: AppTheme.titleStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ModernCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildMenuOption(
                    Icons.notifications_outlined,
                    'Notificações',
                    'Gerencie suas notificações',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuOption(
                    Icons.help_outline,
                    'Ajuda & Suporte',
                    'Central de ajuda e contato',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuOption(
                    Icons.privacy_tip_outlined,
                    'Privacidade',
                    'Política de privacidade',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuOption(
                    Icons.star_outline,
                    'Avaliar o App',
                    'Deixe sua avaliação na loja',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuOption(
                    Icons.logout,
                    'Sair',
                    'Fazer logout da conta',
                    onTap: () {},
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    'Seedfy v1.0.0',
                    style: AppTheme.captionStyle.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Feito com 💚 para jardineiros',
                    style: AppTheme.captionStyle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppTheme.errorRed : AppTheme.textDark;
    final iconColor = isDestructive ? AppTheme.errorRed : AppTheme.primaryPurple;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyStyle.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTheme.captionStyle.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textGray,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.backgroundLight,
    );
  }
}