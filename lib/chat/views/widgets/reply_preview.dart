import 'package:chatapp/common/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/chat/models/message.dart';

class ReplyPreview extends StatelessWidget {
  final Message message;
  final VoidCallback onCancel;

  const ReplyPreview({super.key, required this.message, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == Constants.PREF_KEY_SENDER_ID;
    final senderName = isMe ? 'You' : 'Sender';
    final bgColor = isMe ? Colors.grey[200] : Colors.grey[100];
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  senderName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                _buildMessagePreview(context, message),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Align(
            alignment: Alignment.topCenter,
            child: IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.black54),
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Cancel reply',
            ),
          ),
        ],
      ),
    );
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
      case MessageType.emoji:
        return Row(
          children: [
            Icon(Icons.emoji_emotions, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Emoji', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
      case MessageType.link:
        return Row(
          children: [
            Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Link', style: Theme.of(context).textTheme.bodyMedium),
          ],
        );
    }
  }
}
