import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController controller;

  const EmojiPickerWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: controller,
      config: Config(
        height: 256,
        checkPlatformCompatibility: true,
        // Disable recent tab and skin tones to avoid shared_preferences channel error
        categoryViewConfig: const CategoryViewConfig(
          recentTabBehavior: RecentTabBehavior.NONE,
        ),
        skinToneConfig: const SkinToneConfig(enabled: false),
        emojiViewConfig: EmojiViewConfig(
          emojiSizeMax:
              28 * (Theme.of(context).platform == TargetPlatform.iOS ? 1.2 : 1.0),
        ),
      ),
    );
  }
}
