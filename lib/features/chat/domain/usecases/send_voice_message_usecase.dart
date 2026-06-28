import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendVoiceMessageParams {
  final String chatId;
  final String voicePath;
  final int durationSeconds;

  const SendVoiceMessageParams({
    required this.chatId,
    required this.voicePath,
    required this.durationSeconds,
  });
}

class SendVoiceMessageUseCase
    extends UseCase<List<ChatEntity>, SendVoiceMessageParams> {
  final ChatRepository _repository;

  SendVoiceMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(
    SendVoiceMessageParams params,
  ) =>
      _repository.sendVoiceMessage(
        params.chatId,
        params.voicePath,
        params.durationSeconds,
      );
}
