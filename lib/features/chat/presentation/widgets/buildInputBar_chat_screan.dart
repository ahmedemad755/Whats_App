import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/voice_recorder_service.dart';
import 'package:whatsapp/features/chat/presentation/widgets/attachment_bottom_sheet_chat_screan.dart';
import 'package:whatsapp/features/chat/presentation/widgets/mic_record_button.dart';

import '../cubit/chat_cubit.dart';
import '../screens/camera_screen.dart';

class ChatInputBar extends StatelessWidget {
  static const Color _backgroundColor = Color(0xFFF0F0F0);
  static const Color _sendButtonColor = Color(0xFF25D366);

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasText;
  final bool showEmojiPicker;
  final String chatId;
  final VoidCallback onSendMessage;
  final VoidCallback onToggleEmojiPicker;
  final VoidCallback onScrollToBottom;
  final VoiceRecorderController recorderController;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasText,
    required this.showEmojiPicker,
    required this.chatId,
    required this.onSendMessage,
    required this.onToggleEmojiPicker,
    required this.onScrollToBottom,
    required this.recorderController,
  });

  Future<void> _openAttachmentSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AttachmentBottomSheetChatScrean(
        chatId: chatId,
        onScrollToBottom: onScrollToBottom,
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScreen(),
        fullscreenDialog: true,
      ),
    );

    if (result == null || !context.mounted) return;

    final path = result['path'];
    if (path == null) return;

    if (result['type'] == 'video') {
      context.read<ChatCubit>().sendVideoMessage(chatId, path);
    } else {
      context.read<ChatCubit>().sendImageMessage(
            chatId,
            path,
            caption: result['caption'] ?? '',
          );
    }
    onScrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListenableBuilder(
        listenable: recorderController,
        builder: (context, _) {
          final isRecordingActive =
              recorderController.isRecording || recorderController.micPressed;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: _backgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: isRecordingActive
                      ? _RecordingArea(controller: recorderController)
                      : _TextInputArea(
                          textController: controller,
                          focusNode: focusNode,
                          hasText: hasText,
                          showEmojiPicker: showEmojiPicker,
                          onToggleEmojiPicker: onToggleEmojiPicker,
                          onSendMessage: onSendMessage,
                          onOpenAttachment: () =>
                              _openAttachmentSheet(context),
                          onOpenCamera: () => _openCamera(context),
                        ),
                ),
                const SizedBox(width: 8),
                if (hasText && !isRecordingActive)
                  GestureDetector(
                    onTap: onSendMessage,
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundColor: _sendButtonColor,
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  )
                else
                  MicRecordButton(
                    recorderController: recorderController,
                    chatId: chatId,
                    onScrollToBottom: onScrollToBottom,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Recording inline area (replaces text field)
// ─────────────────────────────────────────────

class _RecordingArea extends StatelessWidget {
  final VoiceRecorderController controller;

  const _RecordingArea({required this.controller});

  @override
  Widget build(BuildContext context) {
    final m = controller.recordingSeconds ~/ 60;
    final s = controller.recordingSeconds % 60;
    final timeStr = '$m:${s.toString().padLeft(2, '0')}';
    final slideProgress =
        (controller.cancelSlideX / -80).clamp(0.0, 1.0);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.stopRecording(cancel: true),
            child: Icon(
              Icons.delete_outline,
              color: Colors.red.shade400,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const _BlinkingDot(),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 15,
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
                    size: 18,
                  ),
                  Text(
                    'Slide to cancel',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Normal text input area
// ─────────────────────────────────────────────

class _TextInputArea extends StatelessWidget {
  static const Color _inputFieldColor = Colors.white;

  final TextEditingController textController;
  final FocusNode focusNode;
  final bool hasText;
  final bool showEmojiPicker;
  final VoidCallback onToggleEmojiPicker;
  final VoidCallback onSendMessage;
  final VoidCallback onOpenAttachment;
  final VoidCallback onOpenCamera;

  const _TextInputArea({
    required this.textController,
    required this.focusNode,
    required this.hasText,
    required this.showEmojiPicker,
    required this.onToggleEmojiPicker,
    required this.onSendMessage,
    required this.onOpenAttachment,
    required this.onOpenCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _inputFieldColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(
              showEmojiPicker
                  ? Icons.keyboard_alt_outlined
                  : Icons.emoji_emotions_outlined,
              color: Colors.grey.shade600,
            ),
            onPressed: onToggleEmojiPicker,
          ),
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Message',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => onSendMessage(),
            ),
          ),
          if (!hasText) ...[
            IconButton(
              icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
              onPressed: onOpenAttachment,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.grey.shade600),
              onPressed: onOpenCamera,
            ),
          ],
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
