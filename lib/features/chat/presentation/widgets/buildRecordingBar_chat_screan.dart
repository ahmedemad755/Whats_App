import 'package:flutter/material.dart';

class RecordingBarWidget extends StatelessWidget {
  final int recordingSeconds;
  final double cancelSlideX;
  final VoidCallback onCancel;

  const RecordingBarWidget({
    super.key,
    required this.recordingSeconds,
    required this.cancelSlideX,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final m = recordingSeconds ~/ 60;
    final s = recordingSeconds % 60;
    final timeStr = '$m:${s.toString().padLeft(2, '0')}';
    final slideProgress = (cancelSlideX / -80).clamp(0.0, 1.0);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: const Color(0xFFF0F0F0),
        child: Row(
          children: [
            _RecordingDot(),
            const SizedBox(width: 10),
            Text(
              timeStr,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Opacity(
                opacity: 1 - slideProgress,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    Text(
                      'Slide to cancel',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onCancel,
              child: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingDot extends StatefulWidget {
  @override
  State<_RecordingDot> createState() => _RecordingDotState();
}

class _RecordingDotState extends State<_RecordingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
