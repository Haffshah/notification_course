abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();

  Future<Map<String, String>> fetchAnotherSong();
}

List<String> ablumArt = [
  'https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
  'https://images.unsplash.com/photo-1501472312651-726afe119ff1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
  'https://images.unsplash.com/photo-1570038932128-8f3cc12c064a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
  'https://images.unsplash.com/photo-1645680827507-9f392edae51c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',
];

class DemoPlaylist extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length = 3}) async {
    return List.generate(length, (index) => _nextSong());
  }

  @override
  Future<Map<String, String>> fetchAnotherSong() async {
    return _nextSong();
  }

  var _songIndex = 0;
  static const _maxSongNumber = 16;

  Map<String, String> _nextSong() {
    _songIndex = (_songIndex % _maxSongNumber) + 1;
    return {
      'id': _songIndex.toString().padLeft(3, '0'),
      'title': 'Song $_songIndex',
      'album': 'SoundHelix',
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
      'artUri': ablumArt[_songIndex - 1],
    };
  }
}
