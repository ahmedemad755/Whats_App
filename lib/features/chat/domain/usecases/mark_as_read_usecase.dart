import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class MarkAsReadParams {
  final String chatId;

  const MarkAsReadParams({required this.chatId});
}

class MarkAsReadUseCase extends UseCase<List<ChatEntity>, MarkAsReadParams> {
  final ChatRepository _repository;

  MarkAsReadUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(MarkAsReadParams params) =>
      _repository.markAsRead(params.chatId);
}
