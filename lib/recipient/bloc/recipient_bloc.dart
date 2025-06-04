import 'package:bloc/bloc.dart';
import 'package:chatapp/recipient/models/recipient.dart';
import 'package:chatapp/recipient/repository/recipient_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'recipient_event.dart';
part 'recipient_state.dart';

class RecipientBloc extends Bloc<RecipientEvent, RecipientState> {
  final log = Logger();
  final RecipientRepository _repository;

  RecipientBloc({required RecipientRepository repository}) : _repository = repository, super(RecipientState.initial) {
    on<InitializeRecipient>(_onInitializeRecipientToState);
    on<ChangeFormValue>(_onChangeFormValueToState);
  }

  Future<void> _onInitializeRecipientToState(InitializeRecipient event, Emitter<RecipientState> emit) async {
    log.d("RecipientBloc:::_onInitializeRecipientToState:Event:: $event");
    try {
      emit(state.copyWith(status: () => RecipientStatus.initial));
      List<Recipient>? response = await _repository.getRecipientList();
      emit(state.copyWith(status: () => RecipientStatus.loaded, chatList: () => response, filteredChatList: () => response));
    } catch (error) {
      log.e("RecipientBloc::Error in _onInitializeRecipientToState: $error");
      emit(state.copyWith(status: () => RecipientStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }

  Future<void> _onChangeFormValueToState(ChangeFormValue event, Emitter<RecipientState> emit) async {
    log.d("RecipientBloc:::_onChangeFormValueToState:Event:: $event");
    try {
      emit(state.copyWith(status: () => RecipientStatus.loading));
      final filteredChatList = state.chatList.where((chat) => chat.name.toLowerCase().contains(event.formData['search'].toLowerCase())).toList();
      emit(state.copyWith(status: () => RecipientStatus.loaded, filteredChatList: () => filteredChatList));
    } catch (error) {
      log.e("RecipientBloc::Error in _onInitializeRecipientToState: $error");
      emit(state.copyWith(status: () => RecipientStatus.error, message: () => error.toString().replaceAll("Exception:", "")));
    }
  }
}
