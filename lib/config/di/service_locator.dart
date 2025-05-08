import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/data/repositories_impl/auth_repository_impl.dart';
import 'package:meet_up/data/repositories_impl/buddy_repository_impl.dart';
import 'package:meet_up/data/repositories_impl/chat_repository_impl.dart';
import 'package:meet_up/data/sources/auth_data_souce.dart';
import 'package:meet_up/data/sources/buddy_data_source.dart';
import 'package:meet_up/data/sources/chat_data_source.dart';
import 'package:meet_up/domain/repositories/auth_repository.dart';
import 'package:meet_up/domain/repositories/buddy_repository.dart';
import 'package:meet_up/domain/repositories/chat_repository.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/login_use_case.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/sign_up_use_case.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/addd_buddy_use_case.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/get_all_buddies_use_cases.dart';
import 'package:meet_up/domain/use_cases/buddy_use_cases/get_my_buddies_use_cases.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/get_recent_chats_use_case.dart';
import 'package:meet_up/domain/use_cases/chat_use_cases/send_message_to_user_use_case.dart';
import 'package:meet_up/presentation/bloc/auth/auth_bloc.dart';
import 'package:meet_up/presentation/bloc/buddy/buddy_bloc.dart';
import 'package:meet_up/presentation/bloc/chat/chat_bloc.dart';

/// Global instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;

final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

Future<void> setupDependencies() async {
  ///
  /// Initialize Storage
  ///
  getIt.registerSingleton<LocalStorageManager>(LocalStorageManager());

  ///
  /// Initialize DataSources
  ///
  getIt.registerFactory<AuthDataSource>(
    () => AuthDataSource(fireStore: firebaseFireStore),
  );

  getIt.registerFactory<BuddyDataSource>(
    () => BuddyDataSource(
      fireStore: firebaseFireStore,
      storageManager: getIt<LocalStorageManager>(),
    ),
  );

  getIt.registerFactory<ChatDataSource>(
    () => ChatDataSource(
      fireStore: firebaseFireStore,
      storageManager: getIt<LocalStorageManager>(),
    ),
  );

  ///
  /// Initialize Repositories
  ///
  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: getIt<AuthDataSource>()),
  );

  getIt.registerFactory<BuddyRepository>(
    () => BuddyRepositoryImpl(buddyDataSource: getIt<BuddyDataSource>()),
  );

  getIt.registerFactory<ChatRepository>(
    () => ChatRepositoryImpl(chatDataSource: getIt<ChatDataSource>()),
  );

  ///
  /// Initialize Use Cases
  ///
  getIt.registerFactory(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<GetAllBuddiesUseCases>(
    () => GetAllBuddiesUseCases(repository: getIt<BuddyRepository>()),
  );

  getIt.registerFactory<AddBuddyUseCase>(
    () => AddBuddyUseCase(repository: getIt<BuddyRepository>()),
  );

  getIt.registerFactory<GetMyBuddiesUseCases>(
    () => GetMyBuddiesUseCases(repository: getIt<BuddyRepository>()),
  );

  getIt.registerFactory<GetRecentChatsUseCase>(
    () => GetRecentChatsUseCase(repository: getIt<ChatRepository>()),
  );

  getIt.registerFactory<SendMessageToUserUseCase>(
    () => SendMessageToUserUseCase(repository: getIt<ChatRepository>()),
  );

  ///
  /// Initialize Blocs
  ///
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      storageManager: getIt<LocalStorageManager>(),
    ),
  );

  getIt.registerFactory<BuddyBloc>(
    () => BuddyBloc(
      getAllBuddiesUseCases: getIt<GetAllBuddiesUseCases>(),
      addBuddyUseCase: getIt<AddBuddyUseCase>(),
      getMyBuddiesUseCases: getIt<GetMyBuddiesUseCases>(),
    ),
  );

  getIt.registerFactory<ChatBloc>(
    () => ChatBloc(
      getRecentChatsUseCase: getIt<GetRecentChatsUseCase>(),
      sendMessageToUserUseCase: getIt<SendMessageToUserUseCase>(),
    ),
  );
}
