import 'dart:io';

import 'package:chatapp/common/common.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/chat/models/message.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final Function(Message) onMessageTap;
  final Function(Message) onMessageLongPress;
  final Function(Message) onMessageDoubleTap;

  const MessageList({
    super.key,
    required this.messages,
    required this.onMessageTap,
    required this.onMessageDoubleTap,
    required this.onMessageLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageItem(context, message);
      },
    );
  }

  Widget _buildMessageItem(BuildContext context, Message message) {
    final isMe = message.senderId == Constants.PREF_KEY_SENDER_ID;

    return GestureDetector(
      onTap: () => onMessageTap(message),
      onDoubleTap: () => onMessageDoubleTap(message),
      onLongPress: () => onMessageLongPress(message),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) _buildAvatar(context),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [_buildMessageContent(context, message), _buildMessageTimestamp(context, message)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (isMe) _buildAvatar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(Icons.person, size: 20, color: Theme.of(context).colorScheme.onPrimaryContainer),
    );
  }

  Widget _buildMessageTimestamp(BuildContext context, Message message) {
    CommonHelper commonHelper = CommonHelper();
    return Wrap(
      children: [
        message.isStarred
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(Icons.star, size: 12, color: Theme.of(context).colorScheme.surface),
              )
            : SizedBox.shrink(),
        Text(
          commonHelper.convertDateTimeToTime(message.timestamp.toLocal().toString()),
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ],
    );
  }

  Widget _buildMessageContent(BuildContext context, Message message) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            color: message.senderId == Constants.PREF_KEY_SENDER_ID
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        );
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(File(message.content), width: 200, height: 200, fit: BoxFit.cover),
        );
      case MessageType.video:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_filled,
              color: message.senderId == Constants.PREF_KEY_SENDER_ID
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              message.metadata?['fileName'] ?? 'Video',
              style: TextStyle(
                color: message.senderId == Constants.PREF_KEY_SENDER_ID
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic,
              color: message.senderId == Constants.PREF_KEY_SENDER_ID
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Voice message',
              style: TextStyle(
                color: message.senderId == Constants.PREF_KEY_SENDER_ID
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      case MessageType.document:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: message.senderId == Constants.PREF_KEY_SENDER_ID
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              message.metadata?['fileName'] ?? 'Document',
              style: TextStyle(
                color: message.senderId == Constants.PREF_KEY_SENDER_ID
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      case MessageType.location:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: message.senderId == Constants.PREF_KEY_SENDER_ID
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              message.metadata?['address'] ?? 'Location',
              style: TextStyle(
                color: message.senderId == Constants.PREF_KEY_SENDER_ID
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      case MessageType.contact:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              color: message.senderId == Constants.PREF_KEY_SENDER_ID
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              message.metadata?['name'] ?? 'Contact',
              style: TextStyle(
                color: message.senderId == Constants.PREF_KEY_SENDER_ID
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
    }
  }
}
