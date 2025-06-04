import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'audio_recorder_state.dart';

class AudioRecorderCubit extends Cubit<AudioRecorderState> {
  AudioRecorderCubit() : super(AudioRecorderState.initial);

  void startRecording() {
    emit(state.copyWith(isRecording: () => true));
  }

  void sendRecording() {
    emit(state.copyWith(isRecording: () => false, isStopped: () => true, isSending: () => true));
  }

  void pauseRecording() {
    emit(state.copyWith(isRecording: () => false, isPaused: () => true));
  }

  void resumeRecording() {
    emit(state.copyWith(isRecording: () => true, isPaused: () => false));
  }

  void dispose() {
    emit(state.copyWith(isRecording: () => false, isPaused: () => false, isStopped: () => true));
  }

  void updateDuration() {
    emit(state.copyWith(duration: () => state.duration + const Duration(seconds: 1)));
  }

  void stopRecording() {
    emit(state.copyWith(isRecording: () => false, isStopped: () => true));
  }
}
