import 'dart:convert';

import 'package:chatapp/app/route_names.dart';
import 'package:chatapp/chat/bloc/chat_bloc.dart';
import 'package:chatapp/chat/models/message.dart';
import 'package:chatapp/chat/views/widgets/message_input_bar.dart';
import 'package:chatapp/chat/views/widgets/message_list.dart';
import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMobile extends StatefulWidget {
  final Recipient recipient;

  const ChatMobile({super.key, required this.recipient});

  @override
  State<ChatMobile> createState() => _ChatMobileState();
}

class _ChatMobileState extends State<ChatMobile> {
  final log = Logger();
  final CommonHelper commonHelper = CommonHelper();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state.status == ChatStatus.error) {
          ToastUtil.showErrorToast(context, state.message);
        }
        if (state.status == ChatStatus.deleted) {
          ToastUtil.showSuccessToast(context, state.message);
        }
        if (state.status == ChatStatus.starred) {
          ToastUtil.showSuccessToast(context, state.message);
        }
      },
      builder: (context, state) {
        ChatBloc chatBloc = context.read<ChatBloc>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.goNamed(RouteNames.recipient),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.amber[200],
                      backgroundImage: widget.recipient.avatarUrl != null ? NetworkImage(widget.recipient.avatarUrl!) : null,
                      child: widget.recipient.avatarUrl == null
                          ? Text(widget.recipient.name[0], style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black))
                          : null,
                    ),
                    if (widget.recipient.isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.recipient.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.recipient.isOnline ? 'Active now' : 'Offline',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.videocam, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
            child: Column(
              children: [
                Expanded(
                  child: MessageList(
                    messages: state.messageList,
                    onMessageTap: _handleMessageTap,
                    onMessageDoubleTap: (message) => message.isStarred
                        ? commonHelper.alertDialog(
                            context,
                            'Unstar Message',
                            'Are you sure you want to unstar this message?',
                            'Cancel',
                            () => Navigator.pop(context),
                            'Unstar',
                            () {
                              Navigator.pop(context);
                              context.read<ChatBloc>().add(StarMessage(messageId: message.id));
                            },
                          )
                        : context.read<ChatBloc>().add(StarMessage(messageId: message.id)),

                    onMessageLongPress: (message) => _showMessageOptions(chatBloc, message),
                  ),
                ),
                MessageInputBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleMessageTap(Message message) async {
    switch (message.type) {
      case MessageType.image:
      case MessageType.video:
        launchUrl(Uri.parse(message.content), mode: LaunchMode.externalApplication);
        break;
      case MessageType.location:
        final location = jsonDecode(message.content);
        final lat = location['latitude'];
        final lng = location['longitude'];
        final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
        launchUrl(uri, mode: LaunchMode.externalApplication);
        break;
      case MessageType.contact:
        CommonHelper commonHelper = CommonHelper();
        final contact = jsonDecode(message.content);
        final name = contact['name'];
        final phone = contact['phone'];
        commonHelper.alertDialog(context, 'Contact', 'Name: $name\nPhone: $phone', 'cancel', () {}, 'copy', () {
          Clipboard.setData(ClipboardData(text: 'Name: $name\nPhone: $phone'));
          ToastUtil.showSuccessToast(context, "Contact copied to clipboard");
        });

        break;
      default:
        break;
    }
  }

  void _showMessageOptions(ChatBloc chatBloc, Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: chatBloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text('Message Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.reply, color: Colors.black87),
                ),
                title: const Text('Reply'),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ChatBloc>().add(ReplyMessage(message: message));
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.forward, color: Colors.black87),
                ),
                title: const Text('Forward'),
                onTap: () {
                  Navigator.pop(context);
                  _showForwardDialog(chatBloc, context, message);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.copy, color: Colors.black87),
                ),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(ClipboardData(text: message.content));
                  ToastUtil.showSuccessToast(context, "Copied to clipboard");
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ChatBloc>().add(DeleteMessage(messageId: message.id));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForwardDialog(ChatBloc chatBloc, BuildContext context, Message message) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: chatBloc,
        child: AlertDialog(
          title: const Text('Forward Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a chat to forward to:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('John Doe'),
                onTap: () {
                  Navigator.pop(context);
                  chatBloc.add(ForwardMessage(message: message, recipientId: '1'));
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Jane Smith'),
                onTap: () {
                  Navigator.pop(context);
                  chatBloc.add(ForwardMessage(message: message, recipientId: '2'));
                },
              ),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
        ),
      ),
    );
  }
}
