import 'dart:io';
import 'package:chatapp/chat/bloc/chat_bloc.dart';
import 'package:chatapp/chat/views/widgets/audio_recording.dart';
import 'package:chatapp/chat/views/widgets/reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/chat/views/widgets/attachment_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MessageInputBar extends StatefulWidget {
  const MessageInputBar({super.key});

  @override
  State<MessageInputBar> createState() => MessageInputBarState();
}

class MessageInputBarState extends State<MessageInputBar> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        _textController.text = state.messageText;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -1))],
              ),
              child: FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState?.save();
                  context.read<ChatBloc>().add(ChangeFormValue(formData: _formKey.currentState!.value));
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.replyingTo != null)
                      ReplyPreview(message: state.replyingTo!, onCancel: () => context.read<ChatBloc>().add(ReplyMessage(message: null))),
                    if (!state.isRecording)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                        child: Row(
                          spacing: 5.0,
                          children: [
                            IconButton(
                              icon: Icon(state.showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions, color: Theme.of(context).colorScheme.primary),
                              onPressed: () => context.read<ChatBloc>().add(ShowEmojiPicker()),
                            ),
                            IconButton(
                              icon: Icon(state.showAttachmentMenu ? Icons.close : Icons.attach_file, color: Theme.of(context).colorScheme.primary),
                              onPressed: () => context.read<ChatBloc>().add(ShowAttachmentMenu()),
                            ),
                            Expanded(
                              child: FormBuilderTextField(
                                name: "message",
                                controller: _textController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                                  hoverColor: Theme.of(context).colorScheme.surfaceContainer,
                                  hint: Text("Type a message...", style: Theme.of(context).textTheme.bodyMedium),
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                                minLines: 1,
                                maxLines: 4,
                                textInputAction: TextInputAction.newline,
                                autocorrect: true,
                                autofocus: true,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                enableInteractiveSelection: false,
                              ),
                            ),
                            state.messageText.isNotEmpty || state.selectedFile != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        context.read<ChatBloc>().add(SendText(text: state.messageText, recipientId: state.recipient.id));
                                      },
                                      icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        fixedSize: const Size(40, 40),
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        context.read<ChatBloc>().add(ShowRecordAudio());
                                      },
                                      icon: Icon(Icons.mic, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        fixedSize: const Size(40, 40),
                                        shape: const CircleBorder(),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    if (state.showEmojiPicker)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: EmojiPicker(
                          onEmojiSelected: (category, emoji) {
                            context.read<ChatBloc>().add(ChangeFormValue(formData: {'emoji': emoji.emoji}));
                          },
                        ),
                      ),
                    if (state.showAttachmentMenu)
                      AttachmentMenu(
                        onFileSelected: (file) {
                          context.read<ChatBloc>().add(SendFile(file: file, recipientId: state.recipient.id));
                        },
                        onImageSelected: (file) {
                          context.read<ChatBloc>().add(SendImage(file: file, recipientId: state.recipient.id));
                        },
                        onCameraCapture: (file) {
                          context.read<ChatBloc>().add(SendCameraCapture(file: file, recipientId: state.recipient.id));
                        },
                        onLocationSelected: (location) {
                          context.read<ChatBloc>().add(SendLocation(location: location, recipientId: state.recipient.id));
                        },
                        onContactSelected: (contact) {
                          context.read<ChatBloc>().add(SendContact(contact: contact, recipientId: state.recipient.id));
                        },
                      ),
                    if (state.isRecording)
                      AudioRecording(
                        onRecordingComplete: (String path) {
                          context.read<ChatBloc>().add(SendAudio(file: File(path), recipientId: state.recipient.id));
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
