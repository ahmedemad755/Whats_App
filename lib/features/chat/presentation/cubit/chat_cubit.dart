import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/mark_as_read_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/send_image_message_usecase.dart';
import '../../domain/usecases/send_document_message_usecase.dart';
import '../../domain/usecases/send_video_message_usecase.dart';
import '../../domain/usecases/send_voice_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetChatsUseCase _getChats;
  final SendMessageUseCase _sendMessage;
  final SendVoiceMessageUseCase _sendVoiceMessage;
  final SendImageMessageUseCase _sendImageMessage;
  final SendVideoMessageUseCase _sendVideoMessage;
  final SendDocumentMessageUseCase _sendDocumentMessage;
  final MarkAsReadUseCase _markAsRead;

  ChatCubit({
    required GetChatsUseCase getChats,
    required SendMessageUseCase sendMessage,
    required SendVoiceMessageUseCase sendVoiceMessage,
    required SendImageMessageUseCase sendImageMessage,
    required SendVideoMessageUseCase sendVideoMessage,
    required SendDocumentMessageUseCase sendDocumentMessage,
    required MarkAsReadUseCase markAsRead,
  })  : _getChats = getChats,
        _sendMessage = sendMessage,
        _sendVoiceMessage = sendVoiceMessage,
        _sendImageMessage = sendImageMessage,
        _sendVideoMessage = sendVideoMessage,
        _sendDocumentMessage = sendDocumentMessage,
        _markAsRead = markAsRead,
        super(const ChatState());

  Future<void> loadChats() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getChats(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (chats) => emit(state.copyWith(isLoading: false, chats: chats)),
    );
  }

  Future<void> sendMessage(String chatId, String text) async {
    final result = await _sendMessage(SendMessageParams(chatId: chatId, text: text));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (chats) => emit(state.copyWith(chats: chats, clearError: true)),
    );
  }

  Future<void> sendImageMessage(String chatId, String imagePath, {String caption = ''}) async {
    final result = await _sendImageMessage(
      SendImageMessageParams(chatId: chatId, imagePath: imagePath, caption: caption),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (chats) => emit(state.copyWith(chats: chats, clearError: true)),
    );
  }

  Future<void> sendVideoMessage(String chatId, String videoPath, {String caption = '', int durationSeconds = 0}) async {
    final result = await _sendVideoMessage(
      SendVideoMessageParams(
        chatId: chatId,
        videoPath: videoPath,
        caption: caption,
        durationSeconds: durationSeconds,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (chats) => emit(state.copyWith(chats: chats, clearError: true)),
    );
  }

  Future<void> sendVoiceMessage(String chatId, String voicePath, int durationSeconds) async {
    final result = await _sendVoiceMessage(
      SendVoiceMessageParams(chatId: chatId, voicePath: voicePath, durationSeconds: durationSeconds),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (chats) => emit(state.copyWith(chats: chats, clearError: true)),
    );
  }

  Future<void> sendDocumentMessage(String chatId, String documentPath, String documentName) async {
    final result = await _sendDocumentMessage(
      SendDocumentMessageParams(chatId: chatId, documentPath: documentPath, documentName: documentName),
    );
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (chats) => emit(state.copyWith(chats: chats, clearError: true)),
    );
  }

  Future<void> markAsRead(String chatId) async {
    final result = await _markAsRead(MarkAsReadParams(chatId: chatId));
    result.fold(
      (_) => null,
      (chats) => emit(state.copyWith(chats: chats)),
    );
  }
}
