import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/core/services/media_picker_service.dart';

import '../cubit/chat_cubit.dart';
import '../screens/camera_screen.dart';
import 'iconCreation_chat_screan.dart';

class AttachmentBottomSheetChatScrean extends StatelessWidget {
  final String chatId;
  final VoidCallback onScrollToBottom;

  const AttachmentBottomSheetChatScrean({
    super.key,
    required this.chatId,
    required this.onScrollToBottom,
  });

  Future<void> _pickDocument(BuildContext context) async {
    Navigator.pop(context);
    final doc = await MediaPickerService.pickDocument();
    if (doc == null || !context.mounted) return;
    context.read<ChatCubit>().sendDocumentMessage(chatId, doc.path, doc.name);
    onScrollToBottom();
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    Navigator.pop(context);
    final result = await MediaPickerService.pickFromGallery();
    if (!context.mounted) return;

    switch (result) {
      case GalleryPickSuccess(:final media):
        if (media.isVideo) {
          context.read<ChatCubit>().sendVideoMessage(chatId, media.path);
        } else {
          context.read<ChatCubit>().sendImageMessage(chatId, media.path);
        }
        onScrollToBottom();
      case GalleryPickPermissionDenied(:final isPermanent):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gallery permission denied'),
            action: isPermanent
                ? SnackBarAction(label: 'Settings', onPressed: openAppSettings)
                : null,
          ),
        );
      case GalleryPickCancelled():
        break;
    }
  }

  Future<void> _openCamera(BuildContext context) async {
    Navigator.pop(context);
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraScreen(),
        fullscreenDialog: true,
      ),
    );
    if (result == null || !context.mounted) return;
    final path = result['path'];
    if (path == null) return;
    if (result['type'] == 'video') {
      context.read<ChatCubit>().sendVideoMessage(chatId, path);
    } else {
      context.read<ChatCubit>().sendImageMessage(chatId, path);
    }
    onScrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconcreationChatScrean(
                    icons: Icons.insert_drive_file,
                    color: Colors.indigo,
                    text: 'Document',
                    onTap: () => _pickDocument(context),
                  ),
                  const SizedBox(width: 40),
                  IconcreationChatScrean(
                    icons: Icons.camera_alt,
                    color: Colors.pink,
                    text: 'Camera',
                    onTap: () => _openCamera(context),
                  ),
                  const SizedBox(width: 40),
                  IconcreationChatScrean(
                    icons: Icons.insert_photo,
                    color: Colors.purple,
                    text: 'Gallery',
                    onTap: () => _pickFromGallery(context),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconcreationChatScrean(
                    icons: Icons.headset,
                    color: Colors.orange,
                    text: 'Audio',
                  ),
                  const SizedBox(width: 40),
                  IconcreationChatScrean(
                    icons: Icons.location_pin,
                    color: Colors.teal,
                    text: 'Location',
                  ),
                  const SizedBox(width: 40),
                  IconcreationChatScrean(
                    icons: Icons.person,
                    color: Colors.blue,
                    text: 'Contact',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
