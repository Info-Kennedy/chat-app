import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'attachment_state.dart';

class AttachmentCubit extends Cubit<AttachmentState> {
  AttachmentCubit() : super(AttachmentState.initial);

  Future<void> sendCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      final LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);

      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(error: () => true, errorMessage: () => "Location services are disabled. Please enable the services"));
      }

      // Check for permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(state.copyWith(error: () => true, errorMessage: () => "Location permissions are denied"));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(state.copyWith(error: () => true, errorMessage: () => "Location permissions are permanently denied"));
      }
      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
      emit(
        state.copyWith(
          error: () => false,
          errorMessage: () => "",
          location: () => position.toJson(),
          file: () => null,
          image: () => null,
          camera: () => null,
          contact: () => {},
        ),
      );
    } catch (error) {
      emit(state.copyWith(error: () => true, errorMessage: () => "Error: $error"));
    }
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf', 'xls', 'xlsx', 'ppt', 'pptx'],
    );

    if (result != null) {
      emit(
        state.copyWith(
          error: () => false,
          errorMessage: () => "",
          location: () => {},
          file: () => File(result.files.first.path!),
          image: () => null,
          camera: () => null,
          contact: () => {},
        ),
      );
    } else {
      emit(state.copyWith(error: () => true, errorMessage: () => "No file selected"));
    }
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      emit(
        state.copyWith(
          error: () => false,
          errorMessage: () => "",
          location: () => {},
          file: () => null,
          image: () => File(result.files.first.path!),
          camera: () => null,
          contact: () => {},
        ),
      );
    } else {
      emit(state.copyWith(error: () => true, errorMessage: () => "No image selected"));
    }
  }

  Future<void> captureCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      emit(
        state.copyWith(
          error: () => false,
          errorMessage: () => "",
          location: () => {},
          file: () => null,
          image: () => null,
          camera: () => File(photo.path),
          contact: () => {},
        ),
      );
    } else {
      emit(state.copyWith(error: () => true, errorMessage: () => "No image captured"));
    }
  }

  Future<void> pickContact() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        // For now, we'll just show a placeholder contact
        emit(
          state.copyWith(
            error: () => false,
            errorMessage: () => "",
            location: () => {},
            file: () => null,
            image: () => null,
            camera: () => null,
            contact: () => {'name': 'John Doe', 'phone': '+1234567890', 'email': 'john@example.com'},
          ),
        );
      } catch (e) {
        emit(state.copyWith(error: () => true, errorMessage: () => "Error: $e"));
      }
    } else {
      emit(state.copyWith(error: () => true, errorMessage: () => "Contact permission denied"));
    }
  }
}
