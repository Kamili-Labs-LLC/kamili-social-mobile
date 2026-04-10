import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/constants.dart';
import '../services/secure_storage_service.dart';

final selectedBrandIdProvider = StateProvider<String?>((ref) => null);

/// Loads the persisted selected brand ID from storage on startup
final initialBrandIdProvider = FutureProvider<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  return storage.read(AppConstants.selectedBrandIdKey);
});
