import 'package:get_it/get_it.dart';

import '../chat/data/datasources/chat_remote_datasource.dart';
import '../chat/data/repositories/chat_repository_impl.dart';
import '../chat/domain/repositories/chat_repository.dart';
import '../chat/domain/usecases/get_messages.dart';
import '../chat/domain/usecases/get_new_messages.dart';
import '../chat/domain/usecases/mark_peer_messages_as_read.dart';
import '../chat/domain/usecases/send_message.dart';
import '../chat/domain/usecases/set_chatting_Id_for_users.dart';
import '../chat/domain/usecases/uplaod_Image_to_server.dart';
import '../chat/presentation/provider/chat_provider.dart';

void initChat(GetIt sl) {
  //! External
  sl.registerFactory(() => ChatProvider(
        getNewMessagesCount: sl(),
        markPeerMessagesAsRead: sl(),
        uplaodImageToServer: sl(),
        getAllMessages: sl(),
        sendMessage: sl(),
        setChattingIdForUsers: sl(),
      ));
  sl.registerLazySingleton(() => SetChattingIdForUsers(repository: sl()));
  sl.registerLazySingleton(() => SendMessage(repository: sl()));
  sl.registerLazySingleton(() => GetAllMessages(repository: sl()));
  sl.registerLazySingleton(() => UplaodImageToServer(repository: sl()));
  sl.registerLazySingleton(() => MarkPeerMessagesAsRead(repository: sl()));
  sl.registerLazySingleton(() => GetNewMessagesCount(repository: sl()));

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remote: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(
      firebaseMessaging: sl(),
      firestore: sl(),
      storage: sl(),
    ),
  );
  //! Core
  // sl.registerLazySingleton(() => InputConverter());
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}
