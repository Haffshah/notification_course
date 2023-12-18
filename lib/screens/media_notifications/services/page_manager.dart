import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
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
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToSongChanges();
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
            artUri: Uri.parse(song['artUri']!)))
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
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;

      progressNotifier.value = ProgressBarState(
          current: position,
          buffered: oldState.buffered,
          total: oldState.total);
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;

      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: playbackState.bufferedPosition,
          total: oldState.total);
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
          current: oldState.current,
          buffered: oldState.buffered,
          total: mediaItem?.duration ?? Duration.zero);
    });
  }

  void _listenToSongChanges() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playList = _audioHandler.queue.value;

    if (playList.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playList.first == mediaItem;
      isLastSongNotifier.value = playList.last == mediaItem;
    }
  }

  void previous() => _audioHandler.skipToPrevious();

  void next() => _audioHandler.skipToNext();

  // void repeat() {}
  //
  // void shuffle() {}
  //
  // void add() {}
  //
  // void remove() {}

  void dispose() {
    _audioHandler.stop();
  }
}
