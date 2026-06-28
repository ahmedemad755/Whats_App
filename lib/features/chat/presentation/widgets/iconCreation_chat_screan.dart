import 'package:flutter/material.dart';

class IconcreationChatScrean extends StatelessWidget {
  final IconData icons;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const IconcreationChatScrean({
    super.key,
    required this.icons,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icons, size: 29, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
