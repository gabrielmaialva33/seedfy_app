import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/locale_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../tasks/screens/tasks_screen.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const TasksScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          notchMargin: 8,
          child: Row(
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: _getLocalizedString('nav_map'),
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.assignment_outlined,
                activeIcon: Icons.assignment,
                label: _getLocalizedString('nav_tasks'),
                index: 1,
              ),
              const Spacer(), // Space for FAB
              _buildNavItem(
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: _getLocalizedString('nav_analytics'),
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: _getLocalizedString('nav_settings'),
                index: 3,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          _currentIndex == 0 ? _buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.textGray,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? AppTheme.primaryPurple : AppTheme.textGray,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => context.go('/ai-camera'),
      backgroundColor: AppTheme.primaryPurple,
      elevation: 8,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  String _getLocalizedString(String key) {
    final localeProvider = context.read<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    // This is a simplified approach. In a real app, you'd use the generated
    // AppLocalizations class to access localized strings
    switch (key) {
      case 'nav_map':
        return isPortuguese ? 'Mapa' : 'Map';
      case 'nav_tasks':
        return isPortuguese ? 'Tarefas' : 'Tasks';
      case 'nav_analytics':
        return isPortuguese ? 'Análises' : 'Analytics';
      case 'nav_settings':
        return isPortuguese ? 'Configurações' : 'Settings';
      default:
        return key;
    }
  }
}

// Extracted content from HomeScreen for reuse
class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
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
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildStoriesSection(),
        _buildQuickActions(),
        _buildPlantsGrid(),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              // Avatar do usuário (estilo Instagram)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.primaryGradient,
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppTheme.primaryPurple,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Saudação e stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Olá, Jardineiro! 🌱',
                      style: AppTheme.headingStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '12 plantas • 3 colheitas prontas',
                      style: AppTheme.captionStyle,
                    ),
                  ],
                ),
              ),
              // Notificações
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Stack(
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textDark,
                      size: 24,
                    ),
                    // Badge de notificação
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.errorRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            // Adicionar nova planta (estilo Instagram)
            _StoryCircle(
              imageUrl: '',
              label: 'Adicionar',
              hasNewStory: false,
              borderColor: AppTheme.primaryPurple,
              onTap: () => context.go('/ai-camera'),
            ),
            _StoryCircle(
              imageUrl: '',
              label: 'Alfaces',
              hasNewStory: true,
              onTap: () {},
            ),
            _StoryCircle(
              imageUrl: '',
              label: 'Tomates',
              hasNewStory: true,
              onTap: () {},
            ),
            _StoryCircle(
              imageUrl: '',
              label: 'Cenouras',
              hasNewStory: false,
              onTap: () {},
            ),
            _StoryCircle(
              imageUrl: '',
              label: 'Ervas',
              hasNewStory: true,
              onTap: () {},
            ),
            _StoryCircle(
              imageUrl: '',
              label: 'Flores',
              hasNewStory: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: _GradientCard(
                colors: const [AppTheme.primaryPurple, AppTheme.primaryGreen],
                height: 80,
                onTap: () => context.go('/ai-chat'),
                child: const Row(
                  children: [
                    Icon(Icons.chat_outlined, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AI Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Pergunte qualquer coisa',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GradientCard(
                colors: const [AppTheme.accentOrange, Color(0xFFFF8A80)],
                height: 80,
                onTap: () => context.go('/map'),
                child: const Row(
                  children: [
                    Icon(Icons.map_outlined, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mapa Interativo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Visualize sua horta',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantsGrid() {
    final plants = [
      {
        'title': 'Alface Crespa',
        'subtitle': 'Plantado há 25 dias • Pronto em 5 dias',
        'status': 'Pronto',
        'statusColor': AppTheme.successGreen,
        'isFavorite': true,
      },
      {
        'title': 'Tomate Cereja',
        'subtitle': 'Plantado há 45 dias • Crescendo bem',
        'status': 'Crescendo',
        'statusColor': AppTheme.warningYellow,
        'isFavorite': false,
      },
      {
        'title': 'Manjericão',
        'subtitle': 'Plantado há 15 dias • Needs água',
        'status': 'Atenção',
        'statusColor': AppTheme.accentOrange,
        'isFavorite': true,
      },
      {
        'title': 'Cenoura',
        'subtitle': 'Plantado há 60 dias • Quase pronto',
        'status': 'Crescendo',
        'statusColor': AppTheme.warningYellow,
        'isFavorite': false,
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final plant = plants[index % plants.length];
            return _PlantCard(
              imageUrl: '',
              title: plant['title'] as String,
              subtitle: plant['subtitle'] as String,
              status: plant['status'] as String,
              statusColor: plant['statusColor'] as Color,
              isFavorite: plant['isFavorite'] as bool,
              onTap: () {
                // Navigate to plant details
              },
            );
          },
          childCount: plants.length,
        ),
      ),
    );
  }
}

// Simplified versions of the UI components used in HomeScreen
class _StoryCircle extends StatelessWidget {
  final String imageUrl;
  final String label;
  final bool hasNewStory;
  final Color? borderColor;
  final VoidCallback onTap;

  const _StoryCircle({
    required this.imageUrl,
    required this.label,
    required this.hasNewStory,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasNewStory
                    ? AppTheme.primaryGradient
                    : LinearGradient(colors: [
                        borderColor ?? Colors.grey,
                        borderColor ?? Colors.grey
                      ]),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: imageUrl.isEmpty
                      ? Icon(
                          Icons.add,
                          color: borderColor ?? AppTheme.primaryPurple,
                          size: 24,
                        )
                      : Container(), // Placeholder for image
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientCard extends StatelessWidget {
  final List<Color> colors;
  final double height;
  final Widget child;
  final VoidCallback onTap;

  const _GradientCard({
    required this.colors,
    required this.height,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: child,
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final bool isFavorite;
  final VoidCallback onTap;

  const _PlantCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: AppTheme.backgroundGradient,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.eco,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
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
