import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class SendDocumentMessageUseCase implements UseCase<List<ChatEntity>, SendDocumentMessageParams> {
  final ChatRepository _repository;
  const SendDocumentMessageUseCase(this._repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(SendDocumentMessageParams params) =>
      _repository.sendDocumentMessage(params.chatId, params.documentPath, params.documentName);
}

class SendDocumentMessageParams extends Equatable {
  final String chatId;
  final String documentPath;
  final String documentName;

  const SendDocumentMessageParams({
    required this.chatId,
    required this.documentPath,
    required this.documentName,
  });

  @override
  List<Object> get props => [chatId, documentPath, documentName];
}
