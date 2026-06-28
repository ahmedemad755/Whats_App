import 'package:equatable/equatable.dart';
import 'message_entity.dart';

class ChatEntity extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String status;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final bool select;
  final List<MessageEntity> messages;

  const ChatEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.status,
    required this.lastMessageTime,
     this.select =false,
    this.unreadCount = 0,
    this.isOnline = false,
    this.messages = const [],
  });

  ChatEntity copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    bool? isOnline,
    List<MessageEntity>? messages,
    String? status,
    bool? select,
  }) {
    return ChatEntity(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      status: status ?? this.status,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      select: select ?? this.select,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isOnline,
        messages,
        status,
        select,
      ];
}
