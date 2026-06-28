import 'package:flutter/material.dart';
import 'injection_container.dart' as di;
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const WhatsAppApp());
}

class WhatsAppApp extends StatelessWidget {
  const WhatsAppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF075E54),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.grey.withValues(alpha: 0.1),
      ),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRoutes.chatList,
    );
  }
}
