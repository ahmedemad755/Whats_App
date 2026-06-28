import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/voice_recorder_service.dart';
import '../cubit/chat_cubit.dart';

class MicRecordButton extends StatefulWidget {
  final VoiceRecorderController recorderController;
  final String chatId;
  final VoidCallback onScrollToBottom;

  const MicRecordButton({
    super.key,
    required this.recorderController,
    required this.chatId,
    required this.onScrollToBottom,
  });

  @override
  State<MicRecordButton> createState() => _MicRecordButtonState();
}

class _MicRecordButtonState extends State<MicRecordButton>
    with SingleTickerProviderStateMixin {
  static const Color _buttonColor = Color(0xFF25D366);

  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    widget.recorderController.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (!mounted) return;
    if (widget.recorderController.micPressed && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.recorderController.micPressed) {
      _pulseController.stop();
      _pulseController.animateTo(0, duration: const Duration(milliseconds: 150));
    }
  }

  @override
  void dispose() {
    widget.recorderController.removeListener(_onControllerChange);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (e) =>
          widget.recorderController.onMicPointerDown(context, e),
      onPointerMove: (e) => widget.recorderController.onMicPointerMove(e),
      onPointerUp: (e) async {
        final result = await widget.recorderController.onMicPointerUp(e);
        if (result == null || result['error'] != null) return;
        if (!context.mounted) return;
        context.read<ChatCubit>().sendVoiceMessage(
              widget.chatId,
              result['path'] as String,
              result['duration'] as int,
            );
        widget.onScrollToBottom();
      },
      onPointerCancel: (e) =>
          widget.recorderController.onMicPointerCancel(e),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: const CircleAvatar(
          radius: 24,
          backgroundColor: _buttonColor,
          child: Icon(Icons.mic, color: Colors.white),
        ),
      ),
    );
  }
}
