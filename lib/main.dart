import 'package:flutter/material.dart';

import 'core/content/content_provider.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi dependency injection
  await configureDependencies();

  // Preload semua konten dinamis dari JSON
  await ContentProvider.instance.preloadAll();

  runApp(const App());
}

/// Root widget aplikasi.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
