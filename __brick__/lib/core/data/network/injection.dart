import 'package:get_it/get_it.dart';
import 'package:{{project_name}}/core/config/app_config.dart';
import 'package:{{project_name}}/core/data/network/http_client.dart';
import 'package:{{project_name}}/core/data/network/network_info.dart';
import 'package:{{project_name}}/core/data/storage/secure_storage_service.dart';
import 'package:{{project_name}}/core/presentation/bloc/connectivity/connectivity_bloc.dart';
import 'package:{{project_name}}/core/presentation/navigation/app_router.dart';
import 'package:{{project_name}}/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:{{project_name}}/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:{{project_name}}/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:{{project_name}}/features/auth/domain/repositories/auth_repository.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/get_current_user.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/refresh_user_profile.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/sign_in_with_password.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/sign_in_with_phone_number.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/sign_out.dart';
import 'package:{{project_name}}/features/auth/domain/usecases/verify_otp.dart';
import 'package:{{project_name}}/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:{{project_name}}/features/shipping/data/datasources/shipping_remote_data_source.dart';
import 'package:{{project_name}}/features/shipping/data/datasources/shopify_remote_data_source.dart';
import 'package:{{project_name}}/features/shipping/data/repositories/shipping_repository_impl.dart';
import 'package:{{project_name}}/features/shipping/domain/repositories/shipping_repository.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/create_booking.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/create_intl_bulk_temp_booking.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/create_intl_temp_booking.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/create_temp_booking.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_countries.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_domestic_booking_details.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_domestic_history.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_international_history.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_international_rate.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_orders.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/get_serviceability_rates.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/init_booking_payment.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/init_intl_booking_payment.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/init_intl_bulk_booking_payment.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/search_pincodes.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/update_line_items_fulfilled.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/update_order_fulfilled.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/verify_international_razorpay_payment.dart';
import 'package:{{project_name}}/features/shipping/domain/usecases/verify_razorpay_payment.dart';
import 'package:{{project_name}}/features/shipping/presentation/bloc/booking/booking_bloc.dart';
import 'package:{{project_name}}/features/shipping/presentation/bloc/history/history_bloc.dart';
import 'package:{{project_name}}/features/shipping/presentation/bloc/shipping_bloc.dart';

/// Service locator for dependency injection.
final getIt = GetIt.instance;

/// Initializes all dependencies for the data layer.
Future<void> initializeDependencies() async {
  // Core services
  getIt
    ..registerLazySingleton<NetworkInfo>(NetworkInfoImpl.new)
    ..registerLazySingleton<HttpClient>(
      () => HttpClient(baseUrl: AppConfig.apiBaseUrl),
    )
    ..registerLazySingleton<SecureStorageService>(SecureStorageServiceImpl.new)
    // Data sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<SecureStorageService>()),
    )
    ..registerLazySingleton<ShippingRemoteDataSource>(
      () => ShippingRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
    )
    // Repositories
    // Real AuthRepository with remote and local data sources
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        localDataSource: getIt<AuthLocalDataSource>(),
      ),
    )
    // Use Cases
    ..registerLazySingleton(() => SignInWithGoogle(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SignInWithPassword(getIt<AuthRepository>()))
    ..registerLazySingleton(
      () => SignInWithPhoneNumber(getIt<AuthRepository>()),
    )
    ..registerLazySingleton(() => VerifyOtp(getIt<AuthRepository>()))
    ..registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()))
    ..registerLazySingleton(() => RefreshUserProfile(getIt<AuthRepository>()))
    ..registerLazySingleton(() => SignOut(getIt<AuthRepository>()))
    // BLoCs
    ..registerLazySingleton(
      () => AuthBloc(
        signInWithGoogle: getIt<SignInWithGoogle>(),
        signInWithPassword: getIt<SignInWithPassword>(),
        signInWithPhoneNumber: getIt<SignInWithPhoneNumber>(),
        verifyOtp: getIt<VerifyOtp>(),
        getCurrentUser: getIt<GetCurrentUser>(),
        refreshUserProfile: getIt<RefreshUserProfile>(),
        signOut: getIt<SignOut>(),
      ),
    )
    // Navigation
    ..registerLazySingleton(() => AppRouter(getIt<AuthBloc>()))
    // Shopify / Shipping
    ..registerLazySingleton<ShopifyRemoteDataSource>(
      () => ShopifyRemoteDataSourceImpl(httpClient: getIt<HttpClient>()),
    )
    ..registerLazySingleton<ShippingRepository>(
      () => ShippingRepositoryImpl(
        shopifyRemoteDataSource: getIt<ShopifyRemoteDataSource>(),
        shippingRemoteDataSource: getIt<ShippingRemoteDataSource>(),
        authLocalDataSource: getIt<AuthLocalDataSource>(),
      ),
    )
    ..registerLazySingleton(() => GetOrders(getIt<ShippingRepository>()))
    ..registerLazySingleton(() => CreateBooking(getIt<ShippingRepository>()))
    ..registerLazySingleton(
      () => GetDomesticHistory(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => GetDomesticBookingDetails(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => GetInternationalHistory(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(() => SearchPincodes(getIt<ShippingRepository>()))
    ..registerLazySingleton(
      () => GetServiceabilityRates(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(() => GetCountries(getIt<ShippingRepository>()))
    ..registerLazySingleton(
      () => CreateTempBooking(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => CreateIntlTempBooking(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => CreateIntlBulkTempBooking(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => InitBookingPayment(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => InitIntlBookingPayment(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => VerifyRazorpayPayment(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => InitIntlBulkBookingPayment(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => VerifyInternationalRazorpayPayment(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => GetInternationalRate(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => UpdateOrderFulfilled(getIt<ShippingRepository>()),
    )
    ..registerLazySingleton(
      () => UpdateLineItemsFulfilled(getIt<ShippingRepository>()),
    )
    ..registerFactory(() => ShippingBloc(getOrders: getIt<GetOrders>()))
    ..registerFactory(
      () => BookingBloc(
        createBooking: getIt<CreateBooking>(),
        searchPincodes: getIt<SearchPincodes>(),
        getServiceabilityRates: getIt<GetServiceabilityRates>(),
        getCountries: getIt<GetCountries>(),
        createTempBooking: getIt<CreateTempBooking>(),
        initBookingPayment: getIt<InitBookingPayment>(),
        verifyRazorpayPayment: getIt<VerifyRazorpayPayment>(),
        getInternationalRate: getIt<GetInternationalRate>(),
        createIntlTempBooking: getIt<CreateIntlTempBooking>(),
        createIntlBulkTempBooking: getIt<CreateIntlBulkTempBooking>(),
        initIntlBookingPayment: getIt<InitIntlBookingPayment>(),
        initIntlBulkBookingPayment: getIt<InitIntlBulkBookingPayment>(),
        verifyInternationalRazorpayPayment:
            getIt<VerifyInternationalRazorpayPayment>(),
        authRepository: getIt<AuthRepository>(),
        updateOrderFulfilled: getIt<UpdateOrderFulfilled>(),
        updateLineItemsFulfilled: getIt<UpdateLineItemsFulfilled>(),
      ),
    )
    ..registerFactory(
      () => HistoryBloc(
        getDomesticHistory: getIt<GetDomesticHistory>(),
        getInternationalHistory: getIt<GetInternationalHistory>(),
        getDomesticBookingDetails: getIt<GetDomesticBookingDetails>(),
      ),
    )
    ..registerLazySingleton(
      () => ConnectivityBloc(networkInfo: getIt<NetworkInfo>()),
    );
}

/// Resets all dependencies (useful for testing).
Future<void> resetDependencies() async {
  await getIt.reset();
}
