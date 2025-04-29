import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:meet_up/data/repositories_impl/auth_repository_impl.dart';
import 'package:meet_up/data/sources/auth_data_souce.dart';
import 'package:meet_up/domain/repositories/auth_repository.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/login_use_case.dart';
import 'package:meet_up/domain/use_cases/auth_use_cases/sign_up_use_case.dart';
import 'package:meet_up/presentation/bloc/auth/auth_bloc.dart';

/// Global instance of GetIt for dependency injection
final GetIt getIt = GetIt.instance;

final FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

Future<void> setupDependencies() async {
  getIt.registerFactory<AuthDataSource>(
    () => AuthDataSource(fireStore: firebaseFireStore),
  );

  getIt.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: getIt<AuthDataSource>()),
  );

  getIt.registerFactory(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
    ),
  );
}
