import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_entity.dart';

class ChatState extends Equatable {
  final List<ChatEntity> chats;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    this.chats = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ChatState copyWith({
    List<ChatEntity>? chats,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [chats, isLoading, errorMessage];
}
