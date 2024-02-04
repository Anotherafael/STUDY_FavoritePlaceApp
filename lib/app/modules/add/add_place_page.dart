import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_favorite_places_app/app/modules/add/components/custom_text_field.dart';
import 'package:study_favorite_places_app/app/modules/add/components/image_field.dart';
import 'package:study_favorite_places_app/app/modules/add/components/location_field.dart';

import '../../core/providers/place_image_provider.dart';
import '../../core/providers/user_places_provider.dart';
import '../../core/providers/place_location_provider.dart';
import '../../models/place.dart';
import '../list/user_places_list_page.dart';

class AddPlacePage extends ConsumerStatefulWidget {
  const AddPlacePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends ConsumerState<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _favoritePlaceModel = UserPlace();
  var _isLoading = false;

  void addItem(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      if (_isLoading) {
        setState(() {
          _isLoading = true;
        });
      }
      if (ref.read(placeImage) == null) {
        return;
      }
      _formKey.currentState!.save();
      _favoritePlaceModel.image = File(ref.read(placeImage)!.path);
      _favoritePlaceModel.location = ref.read(placeLocation);
      ref.read(userPlaces.notifier).add(_favoritePlaceModel);
      _clearInputs();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) {
            return const UserPlacesListPage();
          },
        ),
        (route) => false,
      );
    }
  }

  void _clearInputs() {
    _formKey.currentState!.reset();
    ref.read(placeImage.notifier).state = null;
    ref.read(placeLocation.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Favorite Place'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                CustomTextFieldWidget(
                  labelText: 'Name',
                  onSaved: (value) => _favoritePlaceModel.name = value,
                ),
                const SizedBox(height: 10),
                const ImageFieldWidget(),
                const SizedBox(height: 10),
                const LocationFieldWidget(),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => addItem(ref),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
