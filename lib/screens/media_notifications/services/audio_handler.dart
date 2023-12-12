import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
      builder: () => MyAudioHandler(),
      config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.media.notification.demo',
          androidNotificationChannelName: 'Media Notification Demo',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true));
}

class MyAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();
  final _playerList = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlayList();
    _notifyAudioHandlerAboutPlaybackEvents();
  }

  Future<void> _loadEmptyPlayList() async {
    try {
      await _player.setAudioSource(_playerList);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    /// Manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);
    _playerList.addAll(audioSource.toList());

    ///  Notify System
    final newQueue = queue.value..addAll(mediaItems);

    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(Uri.parse(mediaItem.extras!['url']), tag: mediaItem);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((event) {
      final playing = _player.playing;

      playbackState.add(playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.play else MediaControl.pause,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
          },
          androidCompactActionIndices: const [
            0,
            1,
            3
          ],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          updatePosition: _player.position,
          playing: playing,
          bufferedPosition: _player.bufferedPosition,
          queueIndex: event.currentIndex,
          speed: _player.speed));
    });
  }
}
