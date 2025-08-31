import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart' as di;
import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/ai_camera/screens/ai_camera_screen.dart';
import 'features/ai_chat/screens/ai_chat_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/map/screens/map_screen.dart';
import 'features/onboarding/screens/onboarding_wizard.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'core/firebase_options.dart';
import 'shared/data/datasources/firebase_service.dart';
import 'shared/data/datasources/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize other services
  await SupabaseService.initialize();
  await FirebaseService.initialize();
  
  // Initialize dependency injection
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(const AuthEvent.checkRequested()),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const SeedfyApp(),
      ),
    ),
  );
}

class SeedfyApp extends StatelessWidget {
  const SeedfyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp.router(
          title: 'Seedfy',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: _createRouter(),
        );
      },
    );
  }

  GoRouter _createRouter() {
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
          builder: (context, state) => const OnboardingWizard(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
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
        GoRoute(
          path: '/analytics',
          builder: (context, state) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}
