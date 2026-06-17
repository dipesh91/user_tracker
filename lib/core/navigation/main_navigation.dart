import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_tracker/core/navigation/main_screen.dart';
import 'package:user_tracker/core/widgets/app_loading.dart';
import 'package:user_tracker/features/auth/screens/login_screen.dart';
import 'package:user_tracker/features/auth/screens/signup_screen.dart';
import 'package:user_tracker/providers/ui_provider.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: appLoading(text: 'Try again.')),
          );
        }
        final session = Supabase.instance.client.auth.currentSession;
        final scopeKey = ValueKey(session?.user.id ?? 'logged-out');
        return ProviderScope(
          key: scopeKey,
          child: session != null ? MainScreen() : AuthNavigation(),
        );
      },
    );
  }
}

class AuthNavigation extends ConsumerWidget {
  const AuthNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authPageProvider) ? LoginScreen() : SignupScreen();
  }
}
