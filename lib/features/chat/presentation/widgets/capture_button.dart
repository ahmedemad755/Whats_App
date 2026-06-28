import 'package:flutter/material.dart';
import 'package:whatsapp/core/helper/Responsive_Helper.dart';

class CaptureButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final void Function(LongPressStartDetails) onLongPressStart;
  final void Function(LongPressEndDetails) onLongPressEnd;

  const CaptureButton({
    super.key,
    required this.isRecording,
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
  });

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton>
    with TickerProviderStateMixin {
  static const _pressDuration = Duration(milliseconds: 180);
  static const _pulseDuration = Duration(milliseconds: 900);

  late final AnimationController _pressController;
  late final Animation<double> _pressScale;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: _pressDuration,
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: _pulseDuration,
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CaptureButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _pressController.forward().then((_) => _pressController.reverse());
    widget.onTap();
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    _pressController.forward();
    widget.onLongPressStart(details);
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    _pressController.reverse();
    widget.onLongPressEnd(details);
  }

  @override
  Widget build(BuildContext context) {
    final size = context.w(.20);

    return GestureDetector(
      onTap: _handleTap,
      onLongPressStart: _handleLongPressStart,
      onLongPressEnd: _handleLongPressEnd,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pressScale, _pulseScale]),
        builder: (context, child) {
          final combinedScale = _pressScale.value *
              (widget.isRecording ? _pulseScale.value : 1.0);

          return Transform.scale(
            scale: combinedScale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  width: widget.isRecording ? 28 : 60,
                  height: widget.isRecording ? 28 : 60,
                  decoration: BoxDecoration(
                    color: widget.isRecording ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(
                      widget.isRecording ? 6 : 30,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}