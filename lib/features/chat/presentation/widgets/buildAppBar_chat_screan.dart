import 'package:flutter/material.dart';
import '../../domain/entities/chat_entity.dart';
// تأكد من استيراد ملف ChatAvatar الصحيح لديك
import 'chat_avatar.dart'; 

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ChatEntity chat;

  const ChatAppBar({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF075E54),
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          ChatAvatar(
            url: chat.avatarUrl,
            radius: 20,
            isOnline: chat.isOnline,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                chat.isOnline ? 'online' : 'last seen recently',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.call, color: Colors.white),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (_) {},
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'view_contact', child: Text('View contact')),
            PopupMenuItem(value: 'media', child: Text('Media, links and docs')),
            PopupMenuItem(value: 'clear', child: Text('Clear chat')),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}