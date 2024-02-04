import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_favorite_places_app/app/models/place.dart';
import 'package:study_favorite_places_app/app/modules/map/map.dart';

class PlaceDetailPage extends ConsumerStatefulWidget {
  const PlaceDetailPage({super.key, required this.favoritePlace});

  final UserPlace favoritePlace;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlaceDetailPageState();
}

class _PlaceDetailPageState extends ConsumerState<PlaceDetailPage> {
  bool isLoading = false;

  String get locationImage {
    setState(() {
      isLoading = true;
    });
    if (widget.favoritePlace.location == null) {
      return '';
    }
    final lat = widget.favoritePlace.location?.latitude;
    final lon = widget.favoritePlace.location?.longitude;

    final imageUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lon&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lon&key=AIzaSyD6yHhHX1erl_VH6Lx65HEtHqUDhysT0Kg';

    setState(() {
      isLoading = false;
    });

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.favoritePlace.name!),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.file(
              widget.favoritePlace.image!,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  isLoading
                      ? const CircularProgressIndicator()
                      : Container(
                          child: locationImage.isEmpty
                              ? Text(
                                  'No location selected.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                      ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen(
                                          location:
                                              widget.favoritePlace.location!,
                                          isSelecting: false,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                      locationImage,
                                    ),
                                  ),
                                ),
                        ),
                  Text(
                    widget.favoritePlace.location!.address,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
