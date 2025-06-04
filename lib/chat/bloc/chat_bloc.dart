import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chatapp/chat/models/message.dart';
import 'package:chatapp/chat/repository/chat_repository.dart';
import 'package:chatapp/common/common.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final log = Logger();
  final ChatRepository _repository;
  final CommonHelper _commonHelper = CommonHelper();

  ChatBloc({required ChatRepository repository}) : _repository = repository, super(ChatState.initial) {
    on<InitializeChat>(_onInitializeChatToState);
    on<ChangeFormValue>(_onChangeFormValueToState);
    on<ShowEmojiPicker>(_onShowEmojiPickerToState);
    on<ShowRecordAudio>(_onShowRecordAudioToState);
    on<ShowAttachmentMenu>(_onShowAttachmentMenuToState);
    on<SendText>(_onSendTextToState);
    on<SendContact>(_onSendContactToState);
    on<SendLocation>(_onSendLocationToState);
    on<SendCameraCapture>(_onSendCameraCaptureToState);
    on<SendAudio>(_onSendAudioToState);
    on<SendFile>(_onSendFileToState);
    on<SendImage>(_onSendImageToState);
    on<DeleteMessage>(_onDeleteMessageToState);
    on<ReplyMessage>(_onReplyMessageToState);
    on<ForwardMessage>(_onForwardMessageToState);
    on<StarMessage>(_onStarMessageToState);
  }

  Future<void> _onInitializeChatToState(InitializeChat event, Emitter<ChatState> emit) async {
    log.d("ChatBloc:::_onInitializeChatToState:Event:: $event");
    try {
      emit(state.copyWith(status: () => ChatStatus.initial));
      List<Message>? response = await _repository.getChatList();
      emit(state.copyWith(status: () => ChatStatus.loaded, messageList: () => response));
    } catch (error) {
      log.e("ChatBloc::Error in _onInitializeChatToState: $error");
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onChangeFormValueToState(ChangeFormValue event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    log.d("ChatBloc:::_onChangeFormValueToState:Event:: $event");
    try {
      String messageText = event.formData.containsKey('message') ? "${event.formData['message']}" : state.messageText;
      messageText += event.formData.containsKey('emoji') ? event.formData['emoji'] : '';
      emit(state.copyWith(status: () => ChatStatus.changed, messageText: () => messageText));
    } catch (error) {
      log.e("ChatBloc::Error in _onChangeFormValueToState: $error");
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onShowEmojiPickerToState(ShowEmojiPicker event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    emit(
      state.copyWith(
        status: () => ChatStatus.changed,
        showEmojiPicker: () => !state.showEmojiPicker,
        showAttachmentMenu: () => false,
        isRecording: () => false,
      ),
    );
  }

  Future<void> _onShowAttachmentMenuToState(ShowAttachmentMenu event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    emit(
      state.copyWith(
        status: () => ChatStatus.changed,
        showEmojiPicker: () => false,
        showAttachmentMenu: () => !state.showAttachmentMenu,
        isRecording: () => false,
      ),
    );
  }

  Future<void> _onShowRecordAudioToState(ShowRecordAudio event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    emit(state.copyWith(status: () => ChatStatus.changed, showEmojiPicker: () => false, showAttachmentMenu: () => false, isRecording: () => true));
  }

  Future<void> _onSendTextToState(SendText event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: event.text,
        replyToId: event.replyToId,
        timestamp: DateTime.now(),
        type: MessageType.text,
        status: MessageStatus.sent,
        isStarred: false,
      );
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          messageList: () => messageList,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          message: () => "Message sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendContactToState(SendContact event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: event.contact,
        timestamp: DateTime.now(),
        type: MessageType.contact,
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Contact sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendLocationToState(SendLocation event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: event.location,
        timestamp: DateTime.now(),
        type: MessageType.location,
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Location sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendCameraCaptureToState(SendCameraCapture event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: {'file': event.file},
        timestamp: DateTime.now(),
        type: MessageType.image,
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Image sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendAudioToState(SendAudio event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: {'file': event.file},
        timestamp: DateTime.now(),
        type: MessageType.voice,
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Voice sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendFileToState(SendFile event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: {'file': event.file},
        timestamp: DateTime.now(),
        type: _commonHelper.getFileType(event.file.path),
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "File sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onSendImageToState(SendImage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.sending));
    try {
      Message message = Message(
        id: Uuid().v4(),
        senderId: Constants.PREF_KEY_SENDER_ID,
        receiverId: event.recipientId,
        content: '',
        metadata: {'file': event.file},
        timestamp: DateTime.now(),
        type: MessageType.image,
        status: MessageStatus.sent,
        isStarred: false,
      );
      // await _repository.sendMessage(message);
      List<Message> messageList = [...state.messageList, message];
      emit(
        state.copyWith(
          status: () => ChatStatus.sent,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Image sent successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onDeleteMessageToState(DeleteMessage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.deleting));
    try {
      List<Message> messageList = state.messageList;
      messageList.removeWhere((message) => message.id == event.messageId);
      emit(
        state.copyWith(
          status: () => ChatStatus.deleted,
          showAttachmentMenu: () => false,
          showEmojiPicker: () => false,
          isRecording: () => false,
          messageText: () => '',
          messageList: () => messageList,
          message: () => "Message deleted successfully",
        ),
      );
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onReplyMessageToState(ReplyMessage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    emit(state.copyWith(status: () => ChatStatus.changed, replyingTo: () => event.message));
  }

  Future<void> _onForwardMessageToState(ForwardMessage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.forwarding));
    try {
      // Message message = Message(
      //   id: Uuid().v4(),
      //   senderId: Constants.PREF_KEY_SENDER_ID,
      //   receiverId: event.recipientId,
      //   content: event.message.content,
      //   timestamp: DateTime.now(),
      //   type: event.message.type,
      //   status: MessageStatus.sent,
      //   metadata: event.message.metadata,
      //   isStarred: event.message.isStarred,
      // );
      // await _repository.forwardMessage(event.message, event.recipientId);
      // List<Message> messageList = [...state.messageList, message];
      emit(state.copyWith(status: () => ChatStatus.forwarded, message: () => "Message forwarded successfully"));
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onStarMessageToState(StarMessage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: () => ChatStatus.changing));
    try {
      List<Message> messageList = state.messageList;
      Message? message = messageList.where((message) => message.id == event.messageId).firstOrNull;
      if (message != null) {
        message = message.copyWith(isStarred: !message.isStarred);
        messageList.removeWhere((message) => message.id == event.messageId);
        messageList.insert(0, message);
        emit(
          state.copyWith(
            status: () => ChatStatus.starred,
            messageList: () => messageList,
            message: () => "Message ${message?.isStarred == true ? 'starred' : 'unstarred'} successfully",
          ),
        );
      }
    } catch (error) {
      emit(state.copyWith(status: () => ChatStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }
}
