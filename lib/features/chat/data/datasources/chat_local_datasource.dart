import '../../domain/entities/message_entity.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<ChatModel>> sendMessage(String chatId, String text);
  Future<List<ChatModel>> sendVoiceMessage(String chatId, String voicePath, int durationSeconds);
  Future<List<ChatModel>> sendImageMessage(
  String chatId,
  String imagePath,
  String caption,
);
  Future<List<ChatModel>> sendVideoMessage(
  String chatId,
  String videoPath,
  String caption,
  int durationSeconds,
);
  Future<List<ChatModel>> sendDocumentMessage(
  String chatId,
  String documentPath,
  String documentName,
);
  Future<List<ChatModel>> markAsRead(String chatId);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  List<ChatModel> _chats = [];
  bool _initialized = false;

  @override
  Future<List<ChatModel>> getChats() async {
    if (!_initialized) {
      _chats = _seedChats();
      _initialized = true;
    }
    return _chats;
  }

  @override
  Future<List<ChatModel>> sendMessage(String chatId, String text) async {
    final now = DateTime.now();
    final message = MessageModel(
      id: now.millisecondsSinceEpoch.toString(),
      text: text,
      time: now,
      isMe: true,
      status: MessageStatus.sent,
    );
    _chats = _chats.map((chat) {
      if (chat.id != chatId) return chat;
      return chat.copyWith(
        messages: <MessageEntity>[...chat.messages, message],
        lastMessage: text,
        lastMessageTime: now,
        unreadCount: 0,
      );
    }).toList();
    return _chats;
  }

  @override
  Future<List<ChatModel>> sendVoiceMessage(
    String chatId,
    String voicePath,
    int durationSeconds,
  ) async {
    final now = DateTime.now();
    final message = MessageModel(
      id: now.millisecondsSinceEpoch.toString(),
      text: '',
      time: now,
      isMe: true,
      type: MessageType.voice,
      status: MessageStatus.sent,
      voicePath: voicePath,
      voiceDurationSeconds: durationSeconds,
    );
    _chats = _chats.map((chat) {
      if (chat.id != chatId) return chat;
      return chat.copyWith(
        messages: <MessageEntity>[...chat.messages, message],
        lastMessage: '🎤 Voice message',
        lastMessageTime: now,
        unreadCount: 0,
      );
    }).toList();
    return _chats;
  }

@override
Future<List<ChatModel>> sendImageMessage(
  String chatId,
  String imagePath,
  String caption,
) async {
  final now = DateTime.now();

  final message = MessageModel(
    id: now.millisecondsSinceEpoch.toString(),
    text: caption,
    time: now,
    isMe: true,
    type: MessageType.image,
    status: MessageStatus.sent,
    imagePath: imagePath,
  );

  _chats = _chats.map((chat) {
    if (chat.id != chatId) return chat;

    return chat.copyWith(
      messages: <MessageEntity>[
        ...chat.messages,
        message,
      ],
      lastMessage: caption.isEmpty
          ? '📷 Photo'
          : '📷 $caption',
      lastMessageTime: now,
      unreadCount: 0,
    );
  }).toList();

  return _chats;
}

  @override
  Future<List<ChatModel>> markAsRead(String chatId) async {
    _chats = _chats.map((chat) {
      if (chat.id != chatId) return chat;
      return chat.copyWith(unreadCount: 0);
    }).toList();
    return _chats;
  }

  List<ChatModel> _seedChats() {
    final now = DateTime.now();
    return [
      _createMockChat('1', 'Ahmed Emad', 'https://i.pravatar.cc/150?img=1', 'Hey! How are you doing?', now.subtract(const Duration(minutes: 2)), 3, true),
      _createMockChat('2', 'Sara Mohamed', 'https://i.pravatar.cc/150?img=5', 'See you tomorrow', now.subtract(const Duration(minutes: 30)), 0, false),
      _createMockChat('3', 'Flutter Dev Group', 'https://i.pravatar.cc/150?img=12', 'Ahmed: Check the latest update!', now.subtract(const Duration(hours: 1)), 12, false),
      _createMockChat('4', 'Omar Hassan', 'https://i.pravatar.cc/150?img=8', 'Thanks for your help', now.subtract(const Duration(hours: 3)), 1, true),
      _createMockChat('5', 'Nour Ali', 'https://i.pravatar.cc/150?img=9', 'Voice message', now.subtract(const Duration(days: 1)), 0, false),
    ];
  }

  // Helper method to keep code clean and avoid missing required fields
  ChatModel _createMockChat(String id, String name, String avatar, String lastMsg, DateTime time, int unread, bool online) {
    return ChatModel(
      id: id,
      name: name,
      avatarUrl: avatar,
      status: "Available", // يمكنك تخصيص الـ status لكل شخص هنا
      lastMessage: lastMsg,
      lastMessageTime: time,
      unreadCount: unread,
      isOnline: online,
      messages: _seedMessages(id, DateTime.now()),
    );
  }

  List<MessageEntity> _seedMessages(String chatId, DateTime now) => [
        MessageModel(id: '${chatId}_1', text: 'Hello!', time: now.subtract(const Duration(hours: 2)), isMe: false, status: MessageStatus.read),
        MessageModel(id: '${chatId}_2', text: 'Hi there! How are you?', time: now.subtract(const Duration(hours: 1, minutes: 55)), isMe: true, status: MessageStatus.read),
        MessageModel(id: '${chatId}_3', text: 'I am doing great, thanks for asking!', time: now.subtract(const Duration(hours: 1, minutes: 50)), isMe: false, status: MessageStatus.read),
        MessageModel(id: '${chatId}_4', text: 'That is wonderful to hear', time: now.subtract(const Duration(hours: 1, minutes: 45)), isMe: true, status: MessageStatus.delivered),
        MessageModel(id: '${chatId}_5', text: 'Are you free this weekend?', time: now.subtract(const Duration(minutes: 10)), isMe: false, status: MessageStatus.read),
      ];
      
      
@override
Future<List<ChatModel>> sendDocumentMessage(
  String chatId,
  String documentPath,
  String documentName,
) async {
  final now = DateTime.now();
  final message = MessageModel(
    id: now.millisecondsSinceEpoch.toString(),
    text: '',
    time: now,
    isMe: true,
    type: MessageType.document,
    status: MessageStatus.sent,
    documentPath: documentPath,
    documentName: documentName,
  );
  _chats = _chats.map((chat) {
    if (chat.id != chatId) return chat;
    return chat.copyWith(
      messages: [...chat.messages, message],
      lastMessage: '📄 $documentName',
      lastMessageTime: now,
      unreadCount: 0,
    );
  }).toList();
  return _chats;
}

@override
Future<List<ChatModel>> sendVideoMessage(
  String chatId,
  String videoPath,
  String caption,
  int durationSeconds,
) async {
  final now = DateTime.now();

  final message = MessageModel(
    id: now.millisecondsSinceEpoch.toString(),
    text: caption,
    time: now,
    isMe: true,
    type: MessageType.video,
    status: MessageStatus.sent,
    videoPath: videoPath,
    videoDurationSeconds: durationSeconds,
  );

  _chats = _chats.map((chat) {
    if (chat.id != chatId) return chat;

    return chat.copyWith(
      messages: [
        ...chat.messages,
        message,
      ],
      lastMessage: caption.isEmpty
          ? '🎥 Video'
          : '🎥 $caption',
      lastMessageTime: now,
      unreadCount: 0,
    );
  }).toList();

  return _chats;
}
}