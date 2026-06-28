import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/features/chat/presentation/screens/SelectContact.dart';
import '../features/chat/domain/entities/chat_entity.dart';
import '../features/chat/presentation/cubit/chat_cubit.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../injection_container.dart' as di;

class AppRoutes {
  static const chatList = '/';
  static const chat = '/chat';
  static const selectContact = 'select_contact';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.chatList:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<ChatCubit>()..loadChats(),
            child: const ChatListScreen(),
          ),
        );

      case AppRoutes.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: args['cubit'] as ChatCubit,
            child: ChatScreen(chat: args['chat'] as ChatEntity),
          ),
        );
        case AppRoutes.selectContact:
        return MaterialPageRoute(
          builder: (_) => SelectContact(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
