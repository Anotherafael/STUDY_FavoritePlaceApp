import 'dart:io';

import 'package:study_favorite_places_app/app/models/place_location.dart';
import 'package:uuid/uuid.dart';

class UserPlace {
  String id;
  String? name;
  File? image;
  PlaceLocation? location;

  UserPlace({
    this.name,
    this.image,
    this.location,
    String? id,
  }) : id = id ?? const Uuid().v4();
}
