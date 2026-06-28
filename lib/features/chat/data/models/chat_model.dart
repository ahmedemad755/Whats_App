import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import 'message_model.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.status,
    super.select = false,
    required super.lastMessage,
    required super.lastMessageTime,
    super.unreadCount = 0,
    super.isOnline = false,
    super.messages = const [],
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatarUrl'] as String,
        status: json['status'] as String,
        lastMessage: json['lastMessage'] as String,
        lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
        unreadCount: json['unreadCount'] as int? ?? 0,
        isOnline: json['isOnline'] as bool? ?? false,
        messages: (json['messages'] as List<dynamic>? ?? [])
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'lastMessage': lastMessage,
        'lastMessageTime': lastMessageTime.toIso8601String(),
        'unreadCount': unreadCount,
        'isOnline': isOnline,
        'messages': messages.map((m) => (m as MessageModel).toJson()).toList(),
      };

  @override
  ChatModel copyWith({
    bool? isOnline,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<MessageEntity>? messages,
    int? unreadCount,
    bool? select,
    String? status,
  }) =>
      ChatModel(
        id: id,
        name: name,
        avatarUrl: avatarUrl,
        status: status ?? this.status,
        select: select ?? this.select,
        lastMessage: lastMessage ?? this.lastMessage,
        lastMessageTime: lastMessageTime ?? this.lastMessageTime,
        unreadCount: unreadCount ?? this.unreadCount,
        isOnline: isOnline ?? this.isOnline,
        messages: messages ?? this.messages,
      );
}
