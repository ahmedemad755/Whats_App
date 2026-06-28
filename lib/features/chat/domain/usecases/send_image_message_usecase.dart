import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendImageMessageUseCase implements UseCase<List<ChatEntity>, SendImageMessageParams> {
  final ChatRepository _repository;
  const SendImageMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(SendImageMessageParams params) =>
      _repository.sendImageMessage(params.chatId, params.imagePath, params.caption);
}

class SendImageMessageParams extends Equatable {
  final String chatId;
  final String imagePath;
  final String caption;

  const SendImageMessageParams({
    required this.chatId,
    required this.imagePath,
    this.caption = '',
  });

  @override
  List<Object> get props => [
        chatId,
        imagePath,
        caption,
      ];
}