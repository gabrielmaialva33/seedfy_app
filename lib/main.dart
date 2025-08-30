import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/locale_provider.dart';
import 'core/providers/auth_provider.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SupabaseService.initialize();
  
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
            const Text('Seedfy', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa da Horta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text('Editor de mapa será implementado aqui', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}