import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return switch (message.type) {
      MessageType.voice => _VoiceMessageBubble(message: message),
      MessageType.image => _ImageMessageBubble(message: message),
      MessageType.text => _TextMessageBubble(message: message),
      MessageType.video => _TextMessageBubble(message: message),
      MessageType.document => _DocumentMessageBubble(message: message),
    };
  }
}

class _ImageMessageBubble extends StatelessWidget {
  final MessageEntity message;
  const _ImageMessageBubble({required this.message});

  @override
@override
Widget build(BuildContext context) {
  final isMe = message.isMe;
  final path = message.imagePath;

  return Align(
    alignment: isMe
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: isMe ? 60 : 12,
        right: isMe ? 12 : 60,
      ),
      decoration: _bubbleDecoration(isMe),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isMe ? 14 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (path != null)
              GestureDetector(
                onTap: () => _showFullScreen(context, path),
                child: Image.file(
                  File(path),
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),

            if (message.text.trim().isNotEmpty)
Padding(
  padding: const EdgeInsets.fromLTRB(
    10,
    8,
    10,
    4,
  ),
  child: Text(
    message.text,
    style: const TextStyle(
      fontSize: 15,
    ),
    softWrap: true,
  ),
),

            Padding(
              padding: const EdgeInsets.only(
                right: 8,
                left: 8,
                bottom: 6,
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: _TimeAndStatus(
                  message: message,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showFullScreen(BuildContext context, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(path)),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextMessageBubble extends StatelessWidget {
  final MessageEntity message;

  const _TextMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: message.isMe ? 60 : 12,
          right: message.isMe ? 12 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: _bubbleDecoration(message.isMe),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                message.text,
                style: const TextStyle(fontSize: 15, height: 1.3),
              ),
            ),
            const SizedBox(width: 6),
            _TimeAndStatus(message: message),
          ],
        ),
      ),
    );
  }
}

class _VoiceMessageBubble extends StatefulWidget {
  final MessageEntity message;

  const _VoiceMessageBubble({required this.message});

  @override
  State<_VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<_VoiceMessageBubble> {
  late final AudioPlayer _player;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _audioDuration = Duration.zero;

  static const _waveHeights = [
    8.0, 14.0, 6.0, 20.0, 10.0, 16.0, 8.0, 22.0, 12.0, 6.0,
    18.0, 10.0, 16.0, 8.0, 20.0, 6.0, 14.0, 10.0, 18.0, 8.0,
  ];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _player.onDurationChanged.listen((dur) {
      if (mounted) setState(() => _audioDuration = dur);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      final path = widget.message.voicePath;
      if (path == null) return;
      if (_position > Duration.zero) {
        await _player.resume();
      } else {
        await _player.play(DeviceFileSource(path));
      }
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.isMe;
    final totalSecs = widget.message.voiceDurationSeconds ?? 0;
    final totalDuration = _audioDuration > Duration.zero
        ? _audioDuration
        : Duration(seconds: totalSecs);
    final progress = totalDuration.inMilliseconds > 0
        ? (_position.inMilliseconds / totalDuration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;
    final displayDuration = _isPlaying || _position > Duration.zero
        ? _formatDuration(_position)
        : _formatDuration(Duration(seconds: totalSecs));

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: isMe ? 40 : 12,
          right: isMe ? 12 : 40,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: _bubbleDecoration(isMe),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 260),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _togglePlayback,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isMe
                        ? const Color(0xFF075E54)
                        : const Color(0xFF25D366),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildWaveform(progress, isMe),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          displayDuration,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        _TimeAndStatus(message: widget.message),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform(double progress, bool isMe) {
    final activeColor = isMe
        ? const Color(0xFF075E54)
        : const Color(0xFF25D366);
    return SizedBox(
      height: 26,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _waveHeights.asMap().entries.map((entry) {
          final fraction = entry.key / _waveHeights.length;
          final isActive = fraction <= progress;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Container(
                height: entry.value,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DocumentMessageBubble extends StatelessWidget {
  final MessageEntity message;
  const _DocumentMessageBubble({required this.message});

  IconData _iconForName(String name) {
    final ext = name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf,
      'doc' || 'docx' => Icons.description,
      'xls' || 'xlsx' => Icons.table_chart,
      'ppt' || 'pptx' => Icons.slideshow,
      'zip' || 'rar' || '7z' => Icons.folder_zip,
      'mp3' || 'wav' || 'aac' => Icons.audio_file,
      _ => Icons.insert_drive_file,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final name = message.documentName ?? 'Document';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: isMe ? 60 : 12,
          right: isMe ? 12 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: _bubbleDecoration(isMe),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color(0xFF075E54).withValues(alpha: 0.15)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _iconForName(name),
                color: isMe ? const Color(0xFF075E54) : Colors.grey.shade700,
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  _TimeAndStatus(message: message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeAndStatus extends StatelessWidget {
  final MessageEntity message;

  const _TimeAndStatus({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('HH:mm').format(message.time),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        if (message.isMe) ...[
          const SizedBox(width: 3),
          _StatusIcon(status: message.status),
        ],
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      MessageStatus.sent =>
        Icon(Icons.check, size: 14, color: Colors.grey.shade500),
      MessageStatus.delivered =>
        Icon(Icons.done_all, size: 14, color: Colors.grey.shade500),
      MessageStatus.read =>
        const Icon(Icons.done_all, size: 14, color: Color(0xFF53BDEB)),
    };
  }
}

BoxDecoration _bubbleDecoration(bool isMe) => BoxDecoration(
      color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(16),
        topRight: const Radius.circular(16),
        bottomLeft: Radius.circular(isMe ? 16 : 4),
        bottomRight: Radius.circular(isMe ? 4 : 16),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
    );
