import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendVideoMessageUseCase implements UseCase<List<ChatEntity>, SendVideoMessageParams> {
  final ChatRepository _repository;
  const SendVideoMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(SendVideoMessageParams params) =>
      _repository.sendVideoMessage(
        params.chatId,
        params.videoPath,
        params.caption,
        params.durationSeconds,
      );
}

class SendVideoMessageParams extends Equatable {
  final String chatId;
  final String videoPath;
  final String caption;
  final int durationSeconds;

  const SendVideoMessageParams({
    required this.chatId,
    required this.videoPath,
    this.caption = '',
    this.durationSeconds = 0,
  });

  @override
  List<Object> get props => [chatId, videoPath, caption, durationSeconds];
}
