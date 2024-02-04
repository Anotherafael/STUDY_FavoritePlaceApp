import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:study_favorite_places_app/app/core/providers/place_image_provider.dart';

class ImageFieldWidget extends ConsumerStatefulWidget {
  const ImageFieldWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends ConsumerState<ImageFieldWidget> {
  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      ref.read(placeImage.notifier).state = File(pickedImage.path);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(placeImage) == null
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            height: 250,
            width: double.infinity,
            alignment: Alignment.center,
            child: TextButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () => takePicture(),
              label: const Text('Take Picture'),
            ),
          )
        : Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                height: 250,
                width: double.infinity,
                alignment: Alignment.center,
                child: Image.file(
                  ref.watch(placeImage.notifier).state!,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () => takePicture(),
                label: const Text('Change Picture'),
              )
            ],
          );
  }
}
