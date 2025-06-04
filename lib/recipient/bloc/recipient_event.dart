part of 'recipient_bloc.dart';

sealed class RecipientEvent extends Equatable {
  const RecipientEvent();

  @override
  List<Object> get props => [];
}

class InitializeRecipient extends RecipientEvent {
  const InitializeRecipient();
}

class ChangeFormValue extends RecipientEvent {
  final Map<String, dynamic> formData;
  const ChangeFormValue({required this.formData});

  @override
  List<Object> get props => [formData];
}
