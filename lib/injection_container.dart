import 'package:get_it/get_it.dart';
import 'features/chat/data/datasources/chat_local_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart';
import 'features/chat/domain/usecases/mark_as_read_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/send_image_message_usecase.dart';
import 'features/chat/domain/usecases/send_document_message_usecase.dart';
import 'features/chat/domain/usecases/send_video_message_usecase.dart';
import 'features/chat/domain/usecases/send_voice_message_usecase.dart';
import 'features/chat/presentation/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => ChatCubit(
      getChats: sl(),
      sendMessage: sl(),
      sendVoiceMessage: sl(),
      sendImageMessage: sl(),
      sendVideoMessage: sl(),
      sendDocumentMessage: sl(),
      markAsRead: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetChatsUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => SendVoiceMessageUseCase(sl()));
  sl.registerLazySingleton(() => SendImageMessageUseCase(sl()));
  sl.registerLazySingleton(() => SendVideoMessageUseCase(sl()));
  sl.registerLazySingleton(() => SendDocumentMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkAsReadUseCase(sl()));

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatLocalDataSource>(() => ChatLocalDataSourceImpl());
}
