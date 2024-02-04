import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_places_provider.dart';
import '../../../models/place.dart';
import 'dart:math' as math;

import '../../details/place_detail.page.dart';

class PlaceCardWidget extends ConsumerWidget {
  const PlaceCardWidget({
    super.key,
    required this.favoritePlace,
  });

  final UserPlace favoritePlace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(favoritePlace.id),
      onDismissed: (direction) {
        ref.read(userPlaces.notifier).remove(favoritePlace);
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaceDetailPage(
                favoritePlace: favoritePlace,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: FileImage(
              favoritePlace.image!,
            ),
          ),
          title: Text(
            favoritePlace.name!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            favoritePlace.location!.address,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
      ),
    );
  }
}
