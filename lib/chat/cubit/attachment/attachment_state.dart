part of 'attachment_cubit.dart';

class AttachmentState extends Equatable {
  final bool error;
  final String errorMessage;
  final File? file;
  final File? image;
  final File? camera;
  final Map<String, dynamic> location;
  final Map<String, dynamic> contact;

  const AttachmentState({
    required this.error,
    required this.errorMessage,
    required this.location,
    required this.file,
    required this.image,
    required this.camera,
    required this.contact,
  });

  static AttachmentState initial = AttachmentState(error: false, errorMessage: "", location: {}, file: null, image: null, camera: null, contact: {});

  AttachmentState copyWith({
    bool Function()? error,
    String Function()? errorMessage,
    Map<String, dynamic> Function()? location,
    File? Function()? file,
    File? Function()? image,
    File? Function()? camera,
    Map<String, dynamic> Function()? contact,
  }) {
    return AttachmentState(
      error: error != null ? error() : this.error,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      location: location != null ? location() : this.location,
      file: file != null ? file() : this.file,
      image: image != null ? image() : this.image,
      camera: camera != null ? camera() : this.camera,
      contact: contact != null ? contact() : this.contact,
    );
  }

  @override
  List<Object?> get props => [error, errorMessage, location, file, image, camera, contact];
}
