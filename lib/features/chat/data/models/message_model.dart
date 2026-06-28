import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.text,
    required super.time,
    required super.isMe,
    super.type = MessageType.text,
    super.status = MessageStatus.sent,
    super.voicePath,
    super.voiceDurationSeconds,
    super.imagePath,
    super.videoPath,
    super.thumbnailPath,
    super.videoDurationSeconds,
    super.documentPath,
    super.documentName,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        text: json['text'] as String,
        time: DateTime.parse(json['time'] as String),
        isMe: json['isMe'] as bool,
        type: MessageType.values.byName(json['type'] as String? ?? 'text'),
        status: MessageStatus.values.byName(json['status'] as String? ?? 'sent'),
        voicePath: json['voicePath'] as String?,
        voiceDurationSeconds: json['voiceDurationSeconds'] as int?,
        imagePath: json['imagePath'] as String?,
        videoPath: json['videoPath'] as String?,
        thumbnailPath: json['thumbnailPath'] as String?,
        videoDurationSeconds: json['videoDurationSeconds'] as int?,
        documentPath: json['documentPath'] as String?,
        documentName: json['documentName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'time': time.toIso8601String(),
        'isMe': isMe,
        'type': type.name,
        'status': status.name,
        'voicePath': voicePath,
        'voiceDurationSeconds': voiceDurationSeconds,
        'imagePath': imagePath,
        'videoPath': videoPath,
        'thumbnailPath': thumbnailPath,
        'videoDurationSeconds': videoDurationSeconds,
        'documentPath': documentPath,
        'documentName': documentName,
      };
}
