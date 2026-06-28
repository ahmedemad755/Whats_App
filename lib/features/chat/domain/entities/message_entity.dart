import 'package:equatable/equatable.dart';

enum MessageType { text, image, voice, video, document }

enum MessageStatus { sent, delivered, read }

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final DateTime time;
  final bool isMe;
  final MessageType type;
  final MessageStatus status;
  final String? voicePath;
  final int? voiceDurationSeconds;
  final String? imagePath;
  final String? videoPath;
  final String? thumbnailPath;
  final int? videoDurationSeconds;
  final String? documentPath;
  final String? documentName;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.voicePath,
    this.voiceDurationSeconds,
    this.imagePath,
    this.videoPath,
    this.thumbnailPath,
    this.videoDurationSeconds,
    this.documentPath,
    this.documentName,
  });

  @override
  List<Object?> get props => [
        id, text, time, isMe, type, status,
        voicePath, voiceDurationSeconds,
        imagePath, videoPath, thumbnailPath, videoDurationSeconds,
        documentPath, documentName,
      ];
}
