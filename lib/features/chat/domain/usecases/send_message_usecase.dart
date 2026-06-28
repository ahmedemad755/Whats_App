import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String text;

  const SendMessageParams({required this.chatId, required this.text});
}

class SendMessageUseCase extends UseCase<List<ChatEntity>, SendMessageParams> {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(SendMessageParams params) =>
      _repository.sendMessage(params.chatId, params.text);
}
