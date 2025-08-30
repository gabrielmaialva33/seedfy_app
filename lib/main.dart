import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/auth_provider.dart';
import 'services/supabase_service.dart';
import 'services/firebase_service.dart';
import 'services/mongodb_service.dart';
import 'firebase_options.dart';
import 'features/ai_camera/screens/ai_camera_screen.dart';
import 'features/ai_chat/screens/ai_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize other services
  await SupabaseService.initialize();
  await FirebaseService.initialize();
  
  // Only initialize MongoDB on mobile/desktop platforms (not web)
  if (!kIsWeb) {
    try {
      await MongoDBService.initialize();
    } catch (e) {
      debugPrint('MongoDB initialization failed: $e');
      // Continue without MongoDB - app will use Supabase only
    }
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SeedfyApp(),
    ),
  );
}

class SeedfyApp extends StatelessWidget {
  const SeedfyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, AuthProvider>(
      builder: (context, localeProvider, authProvider, child) {
        return MaterialApp.router(
          title: 'Seedfy',
          debugShowCheckedModeBanner: false,
          
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4CAF50),
              brightness: Brightness.light,
            ),
          ),
          
          routerConfig: _createRouter(authProvider),
        );
      },
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? '/map' : '/login',
      redirect: (context, state) {
        final isAuth = authProvider.isAuthenticated;
        final path = state.fullPath ?? '';
        final isAuthRoute = path.startsWith('/auth') || 
                           path == '/login' || 
                           path == '/signup';
        
        if (!isAuth && !isAuthRoute) {
          return '/login';
        }
        
        if (isAuth && isAuthRoute) {
          return '/map';
        }
        
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/ai-camera',
          builder: (context, state) => const AICameraScreen(),
        ),
        GoRoute(
          path: '/ai-chat',
          builder: (context, state) => const AIChatScreen(),
        ),
      ],
    );
  }
}

// Placeholder screens
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.eco, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text('Seedfy AI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text(
              '🚀 Powered by NVIDIA AI',
              style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              '🌱 Plant Recognition • 🤖 Garden Assistant • 📊 Smart Analytics',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => context.go('/signup'),
              child: const Text('Criar Conta'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/map'),
              child: const Text('Entrar (Demo)'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: const Center(
        child: Text('Tela de cadastro será implementada'),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: const Center(
        child: Text('Onboarding será implementado'),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<BedData> _beds = [
    const BedData(
      id: '1',
      x: 1,
      y: 1,
      widthM: 1.2,
      heightM: 2.0,
      cropName: 'Alface',
      status: BedStatus.healthy,
      daysUntilHarvest: 25,
    ),
    const BedData(
      id: '2',
      x: 3,
      y: 1,
      widthM: 1.0,
      heightM: 1.5,
      cropName: 'Tomate',
      status: BedStatus.warning,
      daysUntilHarvest: 15,
    ),
    const BedData(
      id: '3',
      x: 1,
      y: 4,
      widthM: 2.0,
      heightM: 1.0,
      cropName: 'Cenoura',
      status: BedStatus.critical,
      daysUntilHarvest: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa da Horta'),
        backgroundColor: theme.colorScheme.primaryContainer,
        actions: [
          // 🚀 NOVO: Botão de Câmera AI
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => context.go('/ai-camera'),
            tooltip: '🤖 AI Plant Scanner',
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => context.go('/ai-chat'),
            tooltip: '💬 AI Garden Chat',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddBedDialog,
            tooltip: 'Adicionar Canteiro',
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Exportar CSV'),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Text('Configurações'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'logout':
                  context.read<AuthProvider>().signOut();
                  break;
                case 'export':
                  _exportToCsv();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainer,
            child: Row(
              children: [
                _buildStatusLegend('Saudável', Colors.green),
                const SizedBox(width: 16),
                _buildStatusLegend('Atenção', Colors.orange),
                const SizedBox(width: 16),
                _buildStatusLegend('Crítico', Colors.red),
                const SizedBox(width: 16),
                _buildStatusLegend('Vazio', Colors.grey),
              ],
            ),
          ),
          Expanded(
            child: GardenGrid(
              plotLength: 6.0,
              plotWidth: 8.0,
              pathGap: 0.4,
              beds: _beds,
              onBedTapped: _handleBedTapped,
              onAddBed: _handleAddBed,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBedDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _handleBedTapped(BedData bed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Canteiro: ${bed.cropName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posição: (${bed.x}, ${bed.y})'),
            Text('Tamanho: ${bed.widthM}m x ${bed.heightM}m'),
            Text('Área: ${(bed.widthM * bed.heightM).toStringAsFixed(1)}m²'),
            if (bed.daysUntilHarvest >= 0)
              Text('Dias para colheita: ${bed.daysUntilHarvest}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _handleAddBed(Offset position) {
    const scale = 50.0;
    final gridX = (position.dx / scale).round();
    final gridY = (position.dy / scale).round();
    
    debugPrint('Add bed at grid position: ($gridX, $gridY)');
  }

  void _showAddBedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Canteiro'),
        content: const Text('Funcionalidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _exportToCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportação CSV em desenvolvimento'),
      ),
    );
  }
}

// Incluir as classes do GardenGrid aqui temporariamente
enum BedStatus {
  healthy,
  warning,
  critical,
  empty,
}

class BedData {
  final String id;
  final double x;
  final double y;
  final double widthM;
  final double heightM;
  final String cropName;
  final BedStatus status;
  final int daysUntilHarvest;

  const BedData({
    required this.id,
    required this.x,
    required this.y,
    required this.widthM,
    required this.heightM,
    this.cropName = '',
    this.status = BedStatus.empty,
    this.daysUntilHarvest = -1,
  });
}

class GardenGrid extends StatefulWidget {
  final double plotLength;
  final double plotWidth;
  final double pathGap;
  final List<BedData> beds;
  final Function(BedData) onBedTapped;
  final Function(Offset) onAddBed;

  const GardenGrid({
    super.key,
    required this.plotLength,
    required this.plotWidth,
    required this.pathGap,
    required this.beds,
    required this.onBedTapped,
    required this.onAddBed,
  });

  @override
  State<GardenGrid> createState() => _GardenGridState();
}

class _GardenGridState extends State<GardenGrid> {
  final TransformationController _transformationController = TransformationController();
  static const double _gridScale = 50.0;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 0.5,
      maxScale: 4.0,
      constrained: false,
      child: Container(
        width: widget.plotLength * _gridScale + 100,
        height: widget.plotWidth * _gridScale + 100,
        color: Colors.brown[100],
        child: CustomPaint(
          painter: GardenGridPainter(
            plotLength: widget.plotLength,
            plotWidth: widget.plotWidth,
            pathGap: widget.pathGap,
            beds: widget.beds,
            scale: _gridScale,
          ),
          child: GestureDetector(
            onTapDown: (details) {
              final offset = details.localPosition;
              widget.onAddBed(offset);
            },
            child: Stack(
              children: widget.beds.map((bed) => _buildBedWidget(bed)).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBedWidget(BedData bed) {
    return Positioned(
      left: bed.x * _gridScale,
      top: bed.y * _gridScale,
      child: GestureDetector(
        onTap: () => widget.onBedTapped(bed),
        child: Container(
          width: bed.widthM * _gridScale,
          height: bed.heightM * _gridScale,
          decoration: BoxDecoration(
            color: _getBedColor(bed.status),
            border: Border.all(color: Colors.brown[400]!, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (bed.cropName.isNotEmpty)
                  Text(
                    bed.cropName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (bed.daysUntilHarvest >= 0)
                  Text(
                    '${bed.daysUntilHarvest}d',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBedColor(BedStatus status) {
    switch (status) {
      case BedStatus.healthy:
        return Colors.green;
      case BedStatus.warning:
        return Colors.orange;
      case BedStatus.critical:
        return Colors.red;
      case BedStatus.empty:
        return Colors.grey[300]!;
    }
  }
}

class GardenGridPainter extends CustomPainter {
  final double plotLength;
  final double plotWidth;
  final double pathGap;
  final List<BedData> beds;
  final double scale;

  GardenGridPainter({
    required this.plotLength,
    required this.plotWidth,
    required this.pathGap,
    required this.beds,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown[300]!
      ..strokeWidth = 1;

    // Desenhar grid de referência
    for (double x = 0; x <= plotLength; x += 0.5) {
      canvas.drawLine(
        Offset(x * scale, 0),
        Offset(x * scale, plotWidth * scale),
        paint,
      );
    }

    for (double y = 0; y <= plotWidth; y += 0.5) {
      canvas.drawLine(
        Offset(0, y * scale),
        Offset(plotLength * scale, y * scale),
        paint,
      );
    }

    // Desenhar bordas da área
    final borderPaint = Paint()
      ..color = Colors.brown[700]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, plotLength * scale, plotWidth * scale),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}