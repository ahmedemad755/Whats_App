import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/voice_recorder_service.dart';
import '../../domain/entities/chat_entity.dart';
import '../cubit/chat_cubit.dart';
import '../widgets/buildAppBar_chat_screan.dart';
import '../widgets/buildInputBar_chat_screan.dart';
import '../widgets/buildMessageList_chat_screan.dart';
import '../widgets/emoji_picker_widget.dart';

class ChatScreen extends StatefulWidget {
  final ChatEntity chat;

  const ChatScreen({
    super.key,
    required this.chat,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color _backgroundColor = Color(0xFFECE5DD);
  static const Duration _scrollAnimationDuration = Duration(milliseconds: 300);
  static const Duration _emojiPickerSwitchDelay = Duration(milliseconds: 100);

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late final VoiceRecorderController _voiceRecorderController;

  bool _hasText = false;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _voiceRecorderController = VoiceRecorderController();

    _textController.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _textController
      ..removeListener(_handleTextChanged)
      ..dispose();
    _scrollController.dispose();
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    _voiceRecorderController.disposeRecorder();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _scrollAnimationDuration,
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    context.read<ChatCubit>().sendMessage(widget.chat.id, text);
    _scrollToBottom();
  }

  Future<void> _toggleEmojiPicker() async {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
      _focusNode.requestFocus();
      return;
    }

    _focusNode.unfocus();
    await Future.delayed(_emojiPickerSwitchDelay);

    if (!mounted) return;
    setState(() => _showEmojiPicker = true);
  }

  void _closeEmojiPicker() {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_showEmojiPicker,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeEmojiPicker();
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: ChatAppBar(chat: widget.chat),
        body: Column(
          children: [
            Expanded(
              child: ChatMessagesList(
                initialChat: widget.chat,
                scrollController: _scrollController,
                onScrollToBottom: _scrollToBottom,
              ),
            ),
            ChatInputBar(
              controller: _textController,
              focusNode: _focusNode,
              hasText: _hasText,
              showEmojiPicker: _showEmojiPicker,
              chatId: widget.chat.id,
              recorderController: _voiceRecorderController,
              onSendMessage: _sendMessage,
              onToggleEmojiPicker: _toggleEmojiPicker,
              onScrollToBottom: _scrollToBottom,
            ),
            if (_showEmojiPicker)
              EmojiPickerWidget(controller: _textController),
          ],
        ),
      ),
    );
  }
}