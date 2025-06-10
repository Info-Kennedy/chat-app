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
    final bubbleColor = isMe ? const Color(0xFF23272F) : Colors.white;
    final textColor = isMe ? Colors.white : Colors.black;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isMe ? 16 : 4),
      topRight: Radius.circular(isMe ? 4 : 16),
      bottomLeft: const Radius.circular(16),
      bottomRight: const Radius.circular(16),
    );

    return GestureDetector(
      onTap: () => onMessageTap(message),
      onDoubleTap: () => onMessageDoubleTap(message),
      onLongPress: () => onMessageLongPress(message),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe) _buildAvatar(context),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                        decoration: BoxDecoration(color: bubbleColor, borderRadius: borderRadius),
                        child: Column(
                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            _buildMessageContentCustom(context, message, isMe, textColor),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [_buildMessageTimestampCustom(context, message, isMe)],
                            ),
                          ],
                        ),
                      ),
                      if (message.isForwarded == true || message.isReply == true)
                        Positioned(top: 6, right: 8, child: Icon(Icons.reply, size: 16, color: isMe ? Colors.white54 : Colors.black38)),
                    ],
                  ),
                  if (message.reactions != null && message.reactions!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: message.reactions!
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(e, style: const TextStyle(fontSize: 20)),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
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

  Widget _buildMessageTimestampCustom(BuildContext context, Message message, bool isMe) {
    CommonHelper commonHelper = CommonHelper();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.isStarred)
          Padding(
            padding: const EdgeInsets.only(right: 3.0),
            child: Icon(Icons.star, size: 13, color: isMe ? Colors.amber[300] : Colors.amber[700]),
          ),
        Text(
          commonHelper.convertDateTimeToTime(message.timestamp.toLocal().toString()),
          textAlign: TextAlign.end,
          style: TextStyle(color: isMe ? Colors.white54 : Colors.black38, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildMessageContentCustom(BuildContext context, Message message, bool isMe, Color textColor) {
    switch (message.type) {
      case MessageType.text:
        return Text(message.content, style: TextStyle(fontSize: 16, color: textColor, height: 1.4));
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(File(message.content), width: 220, height: 180, fit: BoxFit.cover),
        );
      case MessageType.document:
        return Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: isMe ? Colors.white10 : Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file, color: isMe ? Colors.white : Colors.black54, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.metadata?['fileName'] ?? 'Document',
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                    ),
                    Text(message.metadata?['fileSize'] ?? '', style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            ],
          ),
        );
      case MessageType.voice:
        return Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: isMe ? Colors.white12 : Colors.grey[200], borderRadius: BorderRadius.circular(24)),
          child: Row(
            children: [
              Icon(Icons.play_arrow, color: isMe ? Colors.white : Colors.black87),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  height: 18,
                  decoration: BoxDecoration(color: isMe ? Colors.white24 : Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                  // Placeholder for waveform
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(height: 4, margin: const EdgeInsets.symmetric(vertical: 7), color: isMe ? Colors.white54 : Colors.black26),
                      ),
                    ],
                  ),
                ),
              ),
              Text(message.metadata?['duration'] ?? '0:00', style: TextStyle(fontSize: 12, color: textColor)),
            ],
          ),
        );
      case MessageType.emoji:
        return Center(child: Text(message.content, style: const TextStyle(fontSize: 32)));
      case MessageType.link:
        return Container(
          width: 220,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: isMe ? Colors.white10 : Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.metadata?['imageUrl'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(message.metadata!['imageUrl'], height: 80, width: double.infinity, fit: BoxFit.cover),
                ),
              const SizedBox(height: 6),
              Text(
                message.metadata?['title'] ?? '',
                style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
              ),
              const SizedBox(height: 2),
              Text(message.metadata?['description'] ?? '', style: TextStyle(fontSize: 13, color: textColor.withValues(alpha: 0.8))),
              const SizedBox(height: 4),
              Text(message.content, style: TextStyle(fontSize: 12, color: Colors.blue)),
            ],
          ),
        );
      default:
        return Text(message.content, style: TextStyle(fontSize: 16, color: textColor, height: 1.4));
    }
  }
}
