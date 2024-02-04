import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_favorite_places_app/app/modules/list/user_places_list_page.dart';

import '../theme/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const UserPlacesListPage(),
        theme: AppTheme().defaultTheme,
      ),
    );
  }
}
