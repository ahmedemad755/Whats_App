import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickedDocument {
  final String path;
  final String name;
  const PickedDocument({required this.path, required this.name});
}

class PickedMedia {
  final String path;
  final bool isVideo;
  const PickedMedia({required this.path, required this.isVideo});
}

sealed class GalleryPickResult {}

final class GalleryPickSuccess extends GalleryPickResult {
  final PickedMedia media;
  GalleryPickSuccess(this.media);
}

final class GalleryPickPermissionDenied extends GalleryPickResult {
  final bool isPermanent;
  GalleryPickPermissionDenied({required this.isPermanent});
}

final class GalleryPickCancelled extends GalleryPickResult {}

class MediaPickerService {
  static final _imagePicker = ImagePicker();

  static Future<PickedDocument?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.first;
    final path = file.path;
    if (path == null) return null;
    return PickedDocument(path: path, name: file.name);
  }

  static Future<GalleryPickResult> pickFromGallery() async {
    final status = await _resolveGalleryPermission();

    if (status.isPermanentlyDenied) {
      return GalleryPickPermissionDenied(isPermanent: true);
    }
    if (status.isDenied) {
      return GalleryPickPermissionDenied(isPermanent: false);
    }

    final picked = await _imagePicker.pickMedia();
    if (picked == null) return GalleryPickCancelled();

    final path = picked.path;
    final isVideo = picked.mimeType?.startsWith('video') == true ||
        path.endsWith('.mp4') ||
        path.endsWith('.mov') ||
        path.endsWith('.avi');

    return GalleryPickSuccess(PickedMedia(path: path, isVideo: isVideo));
  }

  static Future<PermissionStatus> _resolveGalleryPermission() async {
    if (await Permission.photos.request().isGranted) {
      return PermissionStatus.granted;
    }
    return Permission.storage.request();
  }
}
