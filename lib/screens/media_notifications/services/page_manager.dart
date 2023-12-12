import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:notification_course/get_it.dart';
import 'package:notification_course/notifiers/play_button_notifier.dart';
import 'package:notification_course/notifiers/progress_notifier.dart';
import 'package:notification_course/screens/media_notifications/services/playlist_repository.dart';

class PageManager {
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final _audioHandler = getIt<AudioHandler>();

  // Events: Calls coming from the UI
  void init() async {
    await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
  }

  Future<void> _loadPlaylist() async {
    final songRepository = getIt<PlaylistRepository>();
    final playlist = await songRepository.fetchInitialPlaylist();

    final mediaItems = playlist
        .map((song) => MediaItem(
              id: song['id'] ?? '',
              title: song['title'] ?? '',
              album: song['album'] ?? '',
              extras: {'url': song['url'] ?? ''},
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        return;
      } else {
        final newList = playlist.map((e) => e.title).toList();
        playlistNotifier.value = newList;
      }
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;

      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      }else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      }else{
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) {}

  void previous() {}

  void next() {}

  void repeat() {}

  void shuffle() {}

  void add() {}

  void remove() {}

  void dispose() {}
}
