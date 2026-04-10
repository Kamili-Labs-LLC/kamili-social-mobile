import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/theme.dart';
import 'router/app_router.dart';

class KamiliSocialApp extends ConsumerWidget {
  const KamiliSocialApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Kamili Social',
      debugShowCheckedModeBanner: false,
      theme: KamiliTheme.light,
      routerConfig: router,
    );
  }
}
