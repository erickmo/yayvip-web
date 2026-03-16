import 'dart:convert';

import 'package:flutter/services.dart';

/// Service untuk load konten dinamis dari JSON files di assets/content/.
/// Semua caption/teks website di-load dari sini agar bisa diedit
/// tanpa rebuild — cukup ubah file JSON lalu hot restart.
class ContentProvider {
  ContentProvider._();

  static final ContentProvider instance = ContentProvider._();

  final Map<String, Map<String, dynamic>> _cache = {};

  /// Load JSON content file dan cache di memory.
  Future<Map<String, dynamic>> load(String name) async {
    if (_cache.containsKey(name)) return _cache[name]!;
    final raw = await rootBundle.loadString('assets/content/$name.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    _cache[name] = data;
    return data;
  }

  /// Ambil dari cache (harus sudah di-load sebelumnya).
  Map<String, dynamic>? get(String name) => _cache[name];

  /// Preload semua content files saat app startup.
  Future<void> preloadAll() async {
    await Future.wait([
      load('landing'),
      load('donation'),
      load('scholarship'),
      load('stories'),
      load('partnership'),
    ]);
  }

  /// Clear cache (untuk refresh konten).
  void clearCache() => _cache.clear();

  /// Helper: ambil nested value dengan dot notation.
  /// Contoh: `getString('landing', 'hero.tagline')`
  String getString(String file, String path, {String fallback = ''}) {
    final data = _cache[file];
    if (data == null) return fallback;
    return _resolve(data, path) as String? ?? fallback;
  }

  /// Helper: ambil list string.
  List<String> getStringList(String file, String path) {
    final data = _cache[file];
    if (data == null) return [];
    final result = _resolve(data, path);
    if (result is List) return result.cast<String>();
    return [];
  }

  /// Helper: ambil list of maps.
  List<Map<String, dynamic>> getMapList(String file, String path) {
    final data = _cache[file];
    if (data == null) return [];
    final result = _resolve(data, path);
    if (result is List) {
      return result.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Helper: ambil map.
  Map<String, dynamic> getMap(String file, String path) {
    final data = _cache[file];
    if (data == null) return {};
    final result = _resolve(data, path);
    if (result is Map<String, dynamic>) return result;
    return {};
  }

  /// Resolve dot-notation path dalam nested map.
  dynamic _resolve(Map<String, dynamic> data, String path) {
    final parts = path.split('.');
    dynamic current = data;
    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else {
        return null;
      }
    }
    return current;
  }
}
