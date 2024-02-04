import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_favorite_places_app/app/modules/list/components/place_card.dart';

import '../../core/providers/user_places_provider.dart';
import '../add/add_place_page.dart';

class UserPlacesListPage extends ConsumerStatefulWidget {
  const UserPlacesListPage({super.key});

  @override
  ConsumerState<UserPlacesListPage> createState() => _UserPlacesListPageState();
}

class _UserPlacesListPageState extends ConsumerState<UserPlacesListPage> {
  late Future<void> _places;

  @override
  void initState() {
    super.initState();
    _places = ref.read(userPlaces.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    final favoritePlaces = ref.watch(userPlaces.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddPlacePage(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ref.watch(userPlaces).isEmpty
          ? Center(
              child: Text(
                'No favorite places',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            )
          : FutureBuilder(
              future: _places,
              builder: ((context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: ref.watch(userPlaces).length,
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        itemBuilder: (_, index) {
                          final favoritePlace = ref.watch(userPlaces)[index];
                          return PlaceCardWidget(
                            favoritePlace: favoritePlace,
                          );
                        },
                      );
              }),
            ),
    );
  }
}
