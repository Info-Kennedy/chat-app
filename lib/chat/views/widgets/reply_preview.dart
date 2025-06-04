import 'package:chatapp/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/chat/models/message.dart';

class ReplyPreview extends StatelessWidget {
  final Message message;
  final VoidCallback onCancel;

  const ReplyPreview({super.key, required this.message, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getMessageTypeIcon(message.type), color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Replying to ${message.senderId == Constants.PREF_KEY_SENDER_ID ? 'yourself' : 'message'}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: onCancel, tooltip: 'Cancel reply'),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(8)),
            child: _buildMessagePreview(context, message),
          ),
        ],
      ),
    );
  }

  IconData _getMessageTypeIcon(MessageType type) {
    switch (type) {
      case MessageType.text:
        return Icons.message;
      case MessageType.image:
        return Icons.image;
      case MessageType.video:
        return Icons.video_file;
      case MessageType.voice:
        return Icons.mic;
      case MessageType.document:
        return Icons.insert_drive_file;
      case MessageType.location:
        return Icons.location_on;
      case MessageType.contact:
        return Icons.person;
    }
  }

  Widget _buildMessagePreview(BuildContext context, Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis);
      case MessageType.image:
        return Row(
          children: [
            Icon(Icons.image, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Photo', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.video:
        return Row(
          children: [
            Icon(Icons.video_file, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Video', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.voice:
        return Row(
          children: [
            Icon(Icons.mic, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Voice message', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.document:
        return Row(
          children: [
            Icon(Icons.insert_drive_file, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(message.metadata?['fileName'] ?? 'Document', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.location:
        return Row(
          children: [
            Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(message.metadata?['address'] ?? 'Location', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.contact:
        return Row(
          children: [
            Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(message.metadata?['name'] ?? 'Contact', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
    }
  }
}
