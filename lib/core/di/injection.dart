import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Inisialisasi dependency injection.
/// Dipanggil satu kali di main() sebelum runApp().
@InjectableInit()
Future<void> configureDependencies() async {
  // External dependencies yang butuh async
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerSingleton<Connectivity>(Connectivity());

  getIt.init();
}
