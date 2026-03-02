import 'package:get_it/get_it.dart';
import 'package:{{project_name}}/core/config/app_config.dart';
import 'package:{{project_name}}/core/data/network/http_client.dart';
import 'package:{{project_name}}/core/data/network/network_info.dart';
import 'package:{{project_name}}/core/data/storage/secure_storage_service.dart';
import 'package:{{project_name}}/core/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:{{project_name}}/core/presentation/navigation/app_router.dart';

/// Global service locator instance.
final getIt = GetIt.instance;

/// Initializes all application dependencies.
/// Call this once in main() before runApp().
Future<void> initializeDependencies() async {
  // ── Core Services ──────────────────────────────────────────────────────────
  getIt
    ..registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new)
    ..registerLazySingleton<HttpClient>(
      () => HttpClient(baseUrl: AppConfig.apiBaseUrl),
    )
    ..registerLazySingleton<SecureStorageService>(SecureStorageServiceImpl.new)
    // ── Connectivity ───────────────────────────────────────────────────────
    ..registerLazySingleton(
      () => ConnectivityBloc(networkInfo: getIt<NetworkInfo>()),
    )
    // ── Navigation ─────────────────────────────────────────────────────────
    ..registerLazySingleton(() => AppRouter());

  // TODO: Register your feature-specific dependencies below.
  //
  // Example pattern for a feature:
  //
  // Data Sources
  // getIt..registerLazySingleton<FeatureRemoteDataSource>(
  //   () => FeatureRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
  // )
  //
  // Repositories
  // ..registerLazySingleton<FeatureRepository>(
  //   () => FeatureRepositoryImpl(
  //     remoteDataSource: getIt<FeatureRemoteDataSource>(),
  //   ),
  // )
  //
  // Use Cases
  // ..registerLazySingleton(() => GetFeatureData(getIt<FeatureRepository>()))
  //
  // BLoCs
  // ..registerFactory(
  //   () => FeatureBloc(getFeatureData: getIt<GetFeatureData>()),
  // );
}

/// Resets all dependencies (useful for testing).
Future<void> resetDependencies() async {
  await getIt.reset();
}
