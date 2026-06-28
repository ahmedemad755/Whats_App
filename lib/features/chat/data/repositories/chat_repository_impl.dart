import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource _localDataSource;

  const ChatRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      return Right(await _localDataSource.getChats());
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> sendMessage(
    String chatId,
    String text,
  ) async {
    try {
      return Right(await _localDataSource.sendMessage(chatId, text));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> sendVoiceMessage(
    String chatId,
    String voicePath,
    int durationSeconds,
  ) async {
    try {
      return Right(await _localDataSource.sendVoiceMessage(chatId, voicePath, durationSeconds));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override

Future<Either<Failure, List<ChatEntity>>> sendImageMessage(
  String chatId,
  String imagePath,
  String caption,
) async {
  try {
    return Right(
      await _localDataSource.sendImageMessage(
        chatId,
        imagePath,
        caption,
      ),
    );
  } catch (_) {
    return const Left(CacheFailure());
  }
}

@override
Future<Either<Failure, List<ChatEntity>>> sendVideoMessage(
  String chatId,
  String videoPath,
  String caption,
  int durationSeconds,
) async {
  try {
    return Right(
      await _localDataSource.sendVideoMessage(
        chatId,
        videoPath,
        caption,
        durationSeconds,
      ),
    );
  } catch (_) {
    return const Left(CacheFailure());
  }
} 

  @override
  Future<Either<Failure, List<ChatEntity>>> sendDocumentMessage(
    String chatId,
    String documentPath,
    String documentName,
  ) async {
    try {
      return Right(
        await _localDataSource.sendDocumentMessage(chatId, documentPath, documentName),
      );
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> markAsRead(String chatId) async {
    try {
      return Right(await _localDataSource.markAsRead(chatId));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
