import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/auth_provider.dart';
import 'services/supabase_service.dart';
import 'services/firebase_service.dart';
import 'firebase_options.dart';
import 'features/ai_camera/screens/ai_camera_screen.dart';
import 'features/ai_chat/screens/ai_chat_screen.dart';
import 'features/map/screens/map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize other services
  await SupabaseService.initialize();
  await FirebaseService.initialize();
  
  
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
      initialLocation: '/login',
      debugLogDiagnostics: true,
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
              onPressed: () {
                print('Navegando para signup');
                context.go('/signup');
              },
              child: const Text('Criar Conta'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                print('Navegando para map');
                context.go('/map');
              },
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

