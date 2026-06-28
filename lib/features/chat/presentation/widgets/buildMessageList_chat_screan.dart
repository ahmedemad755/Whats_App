import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chat/presentation/widgets/date_header.dart';

import '../../domain/entities/chat_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import 'message_bubble.dart';

class ChatMessagesList extends StatelessWidget {
  final ChatEntity initialChat;
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;

  const ChatMessagesList({
    super.key,
    required this.initialChat,
    required this.scrollController,
    required this.onScrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        final chat = state.chats
            .where((c) => c.id == initialChat.id)
            .fold(initialChat, (_, c) => c);

        onScrollToBottom();

        return ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: chat.messages.length,
          itemBuilder: (context, index) {
            final message = chat.messages[index];

            final prev =
                index > 0 ? chat.messages[index - 1] : null;

            return Column(
              children: [
                if (prev == null ||
                    !_isSameDay(message.time, prev.time))
                  DateHeader(
                    date: message.time,
                  ),

                MessageBubble(
                  message: message,
                ),
              ],
            );
          },
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}