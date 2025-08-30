import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedIndex = 0;

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
    return Scaffold(
      body: Container(
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
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            StoryCircle(
              imageUrl: '',
              label: 'Adicionar',
              hasNewStory: false,
              borderColor: AppTheme.primaryPurple,
              onTap: () => context.go('/ai-camera'),
            ),
            StoryCircle(
              imageUrl: '',
              label: 'Alfaces',
              hasNewStory: true,
              onTap: () {},
            ),
            StoryCircle(
              imageUrl: '',
              label: 'Tomates',
              hasNewStory: true,
              onTap: () {},
            ),
            StoryCircle(
              imageUrl: '',
              label: 'Cenouras',
              hasNewStory: false,
              onTap: () {},
            ),
            StoryCircle(
              imageUrl: '',
              label: 'Ervas',
              hasNewStory: true,
              onTap: () {},
            ),
            StoryCircle(
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
              child: GradientCard(
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
              child: GradientCard(
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
            return PlantCard(
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

  Widget _buildBottomNavigation() {
    return Container(
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
            _buildNavItem(Icons.home, 'Home', 0),
            _buildNavItem(Icons.search, 'Explorar', 1),
            const Spacer(),
            _buildNavItem(Icons.favorite_outline, 'Favoritos', 2),
            _buildNavItem(Icons.person_outline, 'Perfil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.textGray,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryPurple : AppTheme.textGray,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
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
}