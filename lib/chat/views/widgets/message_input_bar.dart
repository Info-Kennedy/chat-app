import 'dart:io';

import 'package:chatapp/chat/bloc/chat_bloc.dart';
import 'package:chatapp/chat/cubit/attachment/attachment_cubit.dart';
import 'package:chatapp/chat/views/widgets/audio_recording.dart';
import 'package:chatapp/chat/views/widgets/reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/chat/views/widgets/attachment_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MessageInputBar extends StatelessWidget {
  const MessageInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormBuilderState>();
    final TextEditingController textController = TextEditingController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        textController.text = state.messageText;
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              if (state.replyingTo != null)
                ReplyPreview(message: state.replyingTo!, onCancel: () => context.read<ChatBloc>().add(ReplyMessage(message: null))),
              if (!state.isRecording)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Colors.black87),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => BlocProvider(
                              create: (context) => AttachmentCubit(),
                              child: AttachmentMenu(
                                onFileSelected: (file) {
                                  context.read<ChatBloc>().add(SendFile(file: file, recipientId: state.recipient.id));
                                  Navigator.of(context).pop();
                                },
                                onImageSelected: (file) {
                                  context.read<ChatBloc>().add(SendImage(file: file, recipientId: state.recipient.id));
                                  Navigator.of(context).pop();
                                },
                                onCameraCapture: (file) {
                                  context.read<ChatBloc>().add(SendCameraCapture(file: file, recipientId: state.recipient.id));
                                  Navigator.of(context).pop();
                                },
                                onLocationSelected: (location) {
                                  context.read<ChatBloc>().add(SendLocation(location: location, recipientId: state.recipient.id));
                                  Navigator.of(context).pop();
                                },
                                onContactSelected: (contact) {
                                  context.read<ChatBloc>().add(SendContact(contact: contact, recipientId: state.recipient.id));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          );
                        },
                        splashRadius: 22,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: const Color(0xFFF5F7F9), borderRadius: BorderRadius.circular(24)),
                          child: Row(
                            children: [
                              FormBuilder(
                                key: formKey,
                                onChanged: () {
                                  formKey.currentState?.save();
                                  context.read<ChatBloc>().add(ChangeFormValue(formData: formKey.currentState!.value));
                                },
                                child: Expanded(
                                  child: FormBuilderTextField(
                                    name: "message",
                                    controller: textController,
                                    decoration: const InputDecoration(
                                      hintText: 'Write your message',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    style: theme.textTheme.bodyMedium,
                                    minLines: 1,
                                    maxLines: 4,
                                    textInputAction: TextInputAction.newline,
                                    autocorrect: true,
                                    autofocus: true,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    enableInteractiveSelection: false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              IconButton(
                                icon: Icon(
                                  state.showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () => context.read<ChatBloc>().add(ShowEmojiPicker()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      state.messageText.isEmpty
                          ? IconButton(
                              icon: const Icon(Icons.mic_none_outlined, color: Colors.black87),
                              onPressed: () {
                                // context.read<ChatBloc>().add(ShowRecordAudio());
                              },
                              splashRadius: 22,
                            )
                          : const SizedBox.shrink(),
                      state.messageText.isNotEmpty
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
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              if (state.showEmojiPicker)
                Container(
                  padding: const EdgeInsets.only(top: 10.0),
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      context.read<ChatBloc>().add(ChangeFormValue(formData: {'emoji': emoji.emoji}));
                    },
                  ),
                ),
              if (state.isRecording)
                AudioRecording(
                  onRecordingComplete: (String path) {
                    context.read<ChatBloc>().add(SendAudio(file: File(path), recipientId: state.recipient.id));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
