part of 'audio_recorder_cubit.dart';

class AudioRecorderState extends Equatable {
  final bool isRecording;
  final String filePath;
  final Duration duration;
  final List<double> waveformData;
  final bool isPlaying;
  final bool isPaused;
  final bool isResumed;
  final bool isStopped;
  final bool isSending;
  final bool isError;
  final String errorMessage;

  const AudioRecorderState({
    required this.isRecording,
    required this.filePath,
    required this.duration,
    required this.waveformData,
    required this.isPlaying,
    required this.isPaused,
    required this.isResumed,
    required this.isStopped,
    required this.isSending,
    required this.isError,
    required this.errorMessage,
  });

  static AudioRecorderState initial = AudioRecorderState(
    isRecording: false,
    filePath: "",
    duration: Duration.zero,
    waveformData: [],
    isPlaying: false,
    isPaused: false,
    isResumed: false,
    isStopped: false,
    isSending: false,
    isError: false,
    errorMessage: "",
  );

  AudioRecorderState copyWith({
    bool Function()? isRecording,
    String Function()? filePath,
    Duration Function()? duration,
    List<double> Function()? waveformData,
    bool Function()? isPlaying,
    bool Function()? isPaused,
    bool Function()? isResumed,
    bool Function()? isStopped,
    bool Function()? isSending,
    bool Function()? isError,
    String Function()? errorMessage,
  }) {
    return AudioRecorderState(
      isRecording: isRecording != null ? isRecording() : this.isRecording,
      filePath: filePath != null ? filePath() : this.filePath,
      duration: duration != null ? duration() : this.duration,
      waveformData: waveformData != null ? waveformData() : this.waveformData,
      isPlaying: isPlaying != null ? isPlaying() : this.isPlaying,
      isPaused: isPaused != null ? isPaused() : this.isPaused,
      isResumed: isResumed != null ? isResumed() : this.isResumed,
      isStopped: isStopped != null ? isStopped() : this.isStopped,
      isSending: isSending != null ? isSending() : this.isSending,
      isError: isError != null ? isError() : this.isError,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isRecording,
    filePath,
    duration,
    waveformData,
    isPlaying,
    isPaused,
    isResumed,
    isStopped,
    isSending,
    isError,
    errorMessage,
  ];
}
