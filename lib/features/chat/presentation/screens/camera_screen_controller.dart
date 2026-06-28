import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Holds all camera state and logic, fully separated from any widget.
///
/// The screen only reads state from here and calls these methods —
/// it never touches the [CameraController] directly.
class CameraScreenController extends ChangeNotifier
    with WidgetsBindingObserver {
  static const Duration _recordingTickInterval = Duration(seconds: 1);

  final ImagePicker _imagePicker = ImagePicker();

  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  int _cameraIndex = 0;

  bool _isInitialized = false;
  bool _isRecording = false;
  bool _audioEnabled = false;
  int _recordingSeconds = 0;
  FlashMode _flashMode = FlashMode.off;

  Timer? _recordingTimer;

  /// Set by the screen so the controller can show snackbars / pop on
  /// permission errors without holding a BuildContext itself across awaits.
  void Function(String message, {bool showSettingsAction})?
      onPermissionDenied;
  VoidCallback? onCameraError;

  bool get isInitialized => _isInitialized;
  bool get isRecording => _isRecording;
  int get recordingSeconds => _recordingSeconds;
  FlashMode get flashMode => _flashMode;
  bool get hasMultipleCameras => _cameras.length > 1;
  CameraController? get cameraController => _cameraController;

  IconData get flashIcon => switch (_flashMode) {
        FlashMode.auto => Icons.flash_auto,
        FlashMode.always => Icons.flash_on,
        _ => Icons.flash_off,
      };

  Future<void> initialize() async {
    WidgetsBinding.instance.addObserver(this);

    final statuses = await [Permission.camera, Permission.microphone].request();
    final cameraStatus = statuses[Permission.camera]!;

    if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
      onPermissionDenied?.call(
        'Camera permission denied',
        showSettingsAction: cameraStatus.isPermanentlyDenied,
      );
      return;
    }

    _audioEnabled = statuses[Permission.microphone]?.isGranted ?? false;

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        await _initCameraController(_cameras[_cameraIndex]);
      }
    } catch (_) {
      onCameraError?.call();
    }
  }

  Future<void> _initCameraController(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: _audioEnabled,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _cameraController = controller;

    try {
      await controller.initialize();
      await controller.setFlashMode(_flashMode);
      _isInitialized = true;
      notifyListeners();
    } catch (_) {
      onCameraError?.call();
    }
  }

  /// Returns the captured file path, or null if capture failed/was skipped.
  Future<String?> takePhoto() async {
    final controller = _cameraController;
    if (controller == null || !_isInitialized || _isRecording) return null;

    try {
      final file = await controller.takePicture();
      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// Opens the system gallery picker and returns the selected image path,
  /// or null if the user cancelled or picking failed.
  Future<String?> pickImageFromGallery() async {
    if (_isRecording) return null;

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      return pickedFile?.path;
    } catch (_) {
      onCameraError?.call();
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    final controller = _cameraController;
    if (controller == null || !_isInitialized || _isRecording) return;

    try {
      await controller.startVideoRecording();

      _isRecording = true;
      _recordingSeconds = 0;
      notifyListeners();

      _recordingTimer = Timer.periodic(_recordingTickInterval, (_) {
        _recordingSeconds++;
        notifyListeners();
      });
    } catch (_) {
      // Recording failed to start — state stays unchanged.
    }
  }

  /// Returns the recorded video file path, or null if recording was not
  /// active or stopping failed.
  Future<String?> stopVideoRecording() async {
    final controller = _cameraController;
    if (controller == null || !_isRecording) return null;

    _recordingTimer?.cancel();

    try {
      final file = await controller.stopVideoRecording();
      _isRecording = false;
      notifyListeners();
      return file.path;
    } catch (_) {
      _isRecording = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2 || _isRecording) return;

    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    _isInitialized = false;
    notifyListeners();

    await _cameraController?.dispose();
    await _initCameraController(_cameras[_cameraIndex]);
  }

  Future<void> toggleFlash() async {
    if (_isRecording) return;

    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };

    try {
      await _cameraController?.setFlashMode(next);
      _flashMode = next;
      notifyListeners();
    } catch (_) {
      // Flash mode unsupported on this device/camera — ignore.
    }
  }

  /// Call from the screen's [WidgetsBindingObserver] lifecycle hook,
  /// or rely on this controller being the observer itself (already mixed in).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraController(_cameras[_cameraIndex]);
    }
  }

  void disposeController() {
    WidgetsBinding.instance.removeObserver(this);
    _recordingTimer?.cancel();
    _cameraController?.dispose();
  }
}