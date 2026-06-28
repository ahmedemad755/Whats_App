import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats();
  Future<Either<Failure, List<ChatEntity>>> sendMessage(String chatId, String text);
  Future<Either<Failure, List<ChatEntity>>> sendVoiceMessage(String chatId, String voicePath, int durationSeconds);
  Future<Either<Failure, List<ChatEntity>>> sendImageMessage(
  String chatId,
  String imagePath,
  String caption,
);
Future<Either<Failure, List<ChatEntity>>>
sendVideoMessage(
  String chatId,
  String videoPath,
  String caption,
  int durationSeconds,
);
  Future<Either<Failure, List<ChatEntity>>> sendDocumentMessage(
  String chatId,
  String documentPath,
  String documentName,
);
  Future<Either<Failure, List<ChatEntity>>> markAsRead(String chatId);
}
