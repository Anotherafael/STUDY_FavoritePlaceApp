import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_favorite_places_app/app/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../../models/place_location.dart';

class UserPlacesNotifier extends StateNotifier<List<UserPlace>> {
  UserPlacesNotifier() : super(const []);

  Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
      ),
      version: 1,
    );
    return db;
  }

  Future<void> loadData() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => UserPlace(
            id: row['id'] as String,
            name: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void add(UserPlace place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(place.image!.path);
    final copiedImage = await place.image!.copy('${appDir.path}/$fileName');
    place.image = copiedImage;

    final db = await getDatabase();

    db.insert('user_places', {
      'id': place.id,
      'title': place.name,
      'image': place.image!.path,
      'lat': place.location!.latitude,
      'lng': place.location!.longitude,
      'address': place.location!.address,
    });
    state = [...state, place];
  }

  void remove(UserPlace place) {
    state.removeWhere((element) => element.id == place.id);
  }

  void clear() {
    state = [];
  }

  void set(List<UserPlace> userPlaces) {
    state = userPlaces;
  }
}

final userPlaces =
    StateNotifierProvider<UserPlacesNotifier, List<UserPlace>>((ref) {
  return UserPlacesNotifier();
});
