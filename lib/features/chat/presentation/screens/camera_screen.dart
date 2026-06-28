import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/core/helper/Responsive_Helper.dart';
import 'package:whatsapp/features/chat/presentation/screens/PhotoPreviewScreen.dart';
import 'package:whatsapp/features/chat/presentation/widgets/cam_icon_button.dart';
import 'package:whatsapp/features/chat/presentation/widgets/capture_button.dart';
import 'package:whatsapp/features/chat/presentation/widgets/recording_badge.dart';

import 'camera_screen_controller.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraScreenController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = CameraScreenController()
      ..onPermissionDenied = _handlePermissionDenied
      ..onCameraError = _handleCameraError
      ..addListener(_onControllerChanged);

    _controller.initialize();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller
      ..removeListener(_onControllerChanged)
      ..disposeController()
      ..dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _handlePermissionDenied(
    String message, {
    bool showSettingsAction = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: showSettingsAction
            ? SnackBarAction(label: 'Settings', onPressed: openAppSettings)
            : null,
      ),
    );
    Navigator.pop(context);
  }

  void _handleCameraError() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera error, please try again')),
    );
  }

  Future<void> _handleTakePhoto() async {
    final imagePath = await _controller.takePhoto();
    if (imagePath == null || !mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(imagePath: imagePath),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  Future<void> _handlePickFromGallery() async {
    final imagePath = await _controller.pickImageFromGallery();
    if (imagePath == null || !mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoPreviewScreen(imagePath: imagePath),
      ),
    );

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  Future<void> _handleStopVideoRecording() async {
    final videoPath = await _controller.stopVideoRecording();
    if (videoPath == null || !mounted) return;

    Navigator.pop(context, {'type': 'video', 'path': videoPath});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _CameraPreviewArea(controller: _controller),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBar(
              controller: _controller,
              onClose: () => Navigator.pop(context),
            ),
          ),
          _BottomBar(
            controller: _controller,
            onTakePhoto: _handleTakePhoto,
            onStartRecording: _controller.startVideoRecording,
            onStopRecording: _handleStopVideoRecording,
          ),
          if (_controller.hasMultipleCameras && !_controller.isRecording)
            Positioned(
              left: context.w(.05),
              bottom: context.h(.14),
              child: CamIconButton(
                icon: Icons.cameraswitch_rounded,
                onTap: _controller.switchCamera,
              ),
            ),
          if (!_controller.isRecording)
            Positioned(
              right: context.w(.05),
              bottom: context.h(.14),
              child: CamIconButton(
                icon: Icons.photo_library_outlined,
                onTap: _handlePickFromGallery,
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// Internal layout sections — kept private to this file since they
// are purely presentational glue between the controller and the
// extracted widgets above.
// ============================================================

class _CameraPreviewArea extends StatelessWidget {
  final CameraScreenController controller;

  const _CameraPreviewArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cameraController = controller.cameraController;

    if (!controller.isInitialized || cameraController == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SizedBox.expand(
      child: AspectRatio(
        aspectRatio: cameraController.value.aspectRatio,
        child: CameraPreview(cameraController),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final CameraScreenController controller;
  final VoidCallback onClose;

  const _TopBar({required this.controller, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(.03),
          vertical: context.h(.008),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CamIconButton(
              icon: controller.flashIcon,
              onTap: controller.toggleFlash,
            ),
            if (controller.isRecording)
              RecordingBadge(seconds: controller.recordingSeconds)
            else
              const SizedBox.shrink(),
            CamIconButton(icon: Icons.close, onTap: onClose),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final CameraScreenController controller;
  final VoidCallback onTakePhoto;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const _BottomBar({
    required this.controller,
    required this.onTakePhoto,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: context.h(.08),
          top: context.h(.04),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.55),
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CaptureButton(
              isRecording: controller.isRecording,
              onTap: onTakePhoto,
              onLongPressStart: (_) => onStartRecording(),
              onLongPressEnd: (_) => onStopRecording(),
            ),
            const SizedBox(height: 12),
            if (!controller.isRecording)
              Text(
                'Tap for photo  •  Hold for video',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}