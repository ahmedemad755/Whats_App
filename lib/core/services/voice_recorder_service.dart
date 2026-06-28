import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorderController extends ChangeNotifier {
  static const Duration _timerTickInterval = Duration(seconds: 1);
  static const double _cancelSlideThreshold = -80;
  static const int _minimumValidDurationSeconds = 1;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final Stopwatch _recordingStopwatch = Stopwatch();

  bool isRecording = false;
  bool micPressed = false;
  bool recordingStarted = false;

  int recordingSeconds = 0;
  double cancelSlideX = 0;

  Offset micPressOrigin = Offset.zero;

  Timer? _recordingTimer;

  Future<void> startRecording(BuildContext context) async {
    recordingStarted = true;

    final messenger = ScaffoldMessenger.of(context);

    final hasPermission = await _audioRecorder.hasPermission();

    if (!hasPermission) {
      _resetRecordingFlags();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Microphone permission denied'),
        ),
      );
      notifyListeners();
      return;
    }

    if (!micPressed) {
      recordingStarted = false;
      notifyListeners();
      return;
    }

    try {
      final path = await _generateRecordingPath();

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      if (!micPressed) {
        recordingStarted = false;
        await _audioRecorder.stop();
        notifyListeners();
        return;
      }

      _beginTrackingRecording();
    } catch (_) {
      _resetRecordingFlags();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to start recording'),
        ),
      );
      notifyListeners();
    }
  }

  Future<String> _generateRecordingPath() async {
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/voice_$timestamp.m4a';
  }

  void _beginTrackingRecording() {
    _recordingStopwatch
      ..reset()
      ..start();

    isRecording = true;
    recordingSeconds = 0;
    cancelSlideX = 0;

    notifyListeners();

    _recordingTimer = Timer.periodic(_timerTickInterval, (_) {
      recordingSeconds = _recordingStopwatch.elapsed.inSeconds;
      notifyListeners();
    });
  }

  void _resetRecordingFlags() {
    recordingStarted = false;
    micPressed = false;
  }

  Future<Map<String, dynamic>?> stopRecording({bool cancel = false}) async {
    if (!isRecording) return null;

    _recordingStopwatch.stop();
    _recordingTimer?.cancel();

    final path = await _audioRecorder.stop();
    final durationSeconds = _recordingStopwatch.elapsed.inSeconds;

    isRecording = false;
    recordingStarted = false;
    micPressed = false;
    cancelSlideX = 0;

    notifyListeners();

    if (cancel || path == null) {
      return null;
    }

    if (durationSeconds < _minimumValidDurationSeconds) {
      return {'error': 'short_recording'};
    }

    return {
      'path': path,
      'duration': durationSeconds,
    };
  }

  Future<Map<String, dynamic>?> onMicPointerDown(
    BuildContext context,
    PointerDownEvent event,
  ) async {
    micPressOrigin = event.position;
    micPressed = true;
    recordingStarted = false;

    notifyListeners();

    await startRecording(context);

    return null;
  }

  Future<Map<String, dynamic>?> onMicPointerMove(
    PointerMoveEvent event,
  ) async {
    if (!isRecording) return null;

    final dx = event.position.dx - micPressOrigin.dx;
    cancelSlideX = dx;
    notifyListeners();

    if (dx < _cancelSlideThreshold) {
      await stopRecording(cancel: true);
    }

    return null;
  }

  Future<Map<String, dynamic>?> onMicPointerUp(
    PointerUpEvent event,
  ) async {
    micPressed = false;
    notifyListeners();

    if (isRecording) {
      return stopRecording();
    }

    return null;
  }

  Future<void> onMicPointerCancel(
    PointerCancelEvent event,
  ) async {
    micPressed = false;
    notifyListeners();

    if (isRecording) {
      await stopRecording(cancel: true);
    }
  }

  void disposeRecorder() {
    _recordingTimer?.cancel();
    _audioRecorder.dispose();
  }
}