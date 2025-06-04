import 'package:chatapp/chat/cubit/attachment/attachment_cubit.dart';
import 'package:chatapp/chat/cubit/audio/audio_recorder_cubit.dart';
import 'package:chatapp/common/common.dart';
import 'package:chatapp/chat/bloc/chat_bloc.dart';
import 'package:chatapp/chat/repository/chat_repository.dart';
import 'package:chatapp/chat/repository/message_repository.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_mobile.dart';

class ChatPage extends StatelessWidget {
  final Recipient recipient;
  const ChatPage({super.key, required this.recipient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(
            repository: ChatRepository(prefRepo: getIt<PreferencesRepository>(), messageRepo: getIt<MessageRepository>()),
          )..add(InitializeChat()),
        ),
        BlocProvider(create: (context) => AudioRecorderCubit()),
        BlocProvider(create: (context) => AttachmentCubit()),
      ],
      child: ChatMobile(recipient: recipient),
    );
  }
}
