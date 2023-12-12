import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:notification_course/screens/media_notifications/services/audio_handler.dart';
import 'package:notification_course/screens/media_notifications/services/page_manager.dart';
import 'package:notification_course/screens/media_notifications/services/playlist_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<AudioHandler>(await initAudioService());

  getIt.registerLazySingleton<PlaylistRepository>(() => DemoPlaylist());
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
