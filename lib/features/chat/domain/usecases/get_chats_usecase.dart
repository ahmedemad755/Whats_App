import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatsUseCase extends UseCase<List<ChatEntity>, NoParams> {
  final ChatRepository _repository;

  GetChatsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(NoParams params) =>
      _repository.getChats();
}
