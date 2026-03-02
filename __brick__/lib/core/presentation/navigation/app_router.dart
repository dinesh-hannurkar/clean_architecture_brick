import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name}}/core/data/network/injection.dart';
import 'package:{{project_name}}/core/presentation/navigation/go_router_refresh_stream.dart';
import 'package:{{project_name}}/core/presentation/navigation/navigation_service.dart';
import 'package:{{project_name}}/core/presentation/screens/splash_screen.dart';
import 'package:{{project_name}}/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:{{project_name}}/features/auth/presentation/screens/login_screen.dart';
import 'package:{{project_name}}/features/home/presentation/screens/home_screen.dart';
import 'package:{{project_name}}/features/profile/presentation/screens/profile_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/bloc/history/history_bloc.dart';
import 'package:{{project_name}}/features/shipping/domain/entities/booking_request.dart';
import 'package:{{project_name}}/features/shipping/domain/entities/temp_booking_response.dart';
import 'package:{{project_name}}/features/shipping/domain/entities/order.dart';
import 'package:{{project_name}}/features/shipping/domain/entities/serviceability_rate.dart';
import 'package:{{project_name}}/features/shipping/presentation/bloc/booking/booking_bloc.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/booking_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/booking_status_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/booking_summary_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/bulk_booking_summary_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/bulk_booking_payment_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/international_booking_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/order_details_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/domestic_booking_details_screen.dart';
import 'package:{{project_name}}/features/shipping/presentation/screens/international_booking_details_screen.dart';
import 'package:{{project_name}}/features/shipping/domain/entities/international_booking_history.dart';

class AppRouter {
  AppRouter(this._authBloc);

  final AuthBloc _authBloc;

  late final router = GoRouter(
    initialLocation: '/splash',
    navigatorKey: NavigationService.navigatorKey,
    refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    redirect: (context, state) {
      final authState = _authBloc.state;
      final isUnauthenticated = authState is AuthUnauthenticated;
      final isAuthenticated = authState is AuthAuthenticated;

      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      // 1. If Initial state, stay on splash (or go there)
      if (authState is AuthInitial) {
        return '/splash';
      }

      // 2. If Unauthenticated and not on login, go to login
      if (isUnauthenticated) {
        return isLogin ? null : '/login';
      }

      // 3. If Authenticated
      if (isAuthenticated) {
        // If on splash or login, go to home
        if (isSplash || isLogin) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/order-details',
        builder: (context, state) {
          final extra = state.extra;
          ShopifyOrder? order;
          bool showFulfilledOnly = false;

          if (extra is ShopifyOrder) {
            order = extra;
          } else if (extra is Map) {
            order = extra['order'] as ShopifyOrder?;
            showFulfilledOnly = extra['showFulfilledOnly'] as bool? ?? false;
          }

          if (order == null) {
            return const Scaffold(body: Center(child: Text('Order not found')));
          }

          return OrderDetailsScreen(
            order: order,
            showFulfilledOnly: showFulfilledOnly,
          );
        },
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final extra = state.extra;
          final ShopifyOrder order;
          var isBulkEdit = false;
          BookingRequest? initialRequest;
          ServiceabilityResult? initialServiceability;

          if (extra is ShopifyOrder) {
            order = extra;
          } else if (extra is Map<String, dynamic>) {
            final map = extra;
            order = map['order'] as ShopifyOrder;
            isBulkEdit = map['isBulkEdit'] as bool? ?? false;
            initialRequest = map['initialRequest'] as BookingRequest?;
            initialServiceability =
                map['initialServiceability'] as ServiceabilityResult?;
          } else {
            return const Scaffold(
              body: Center(child: Text('Invalid booking data')),
            );
          }

          return BlocProvider(
            create: (context) => getIt<BookingBloc>(),
            child: BookingScreen(
              order: order,
              isBulkEdit: isBulkEdit,
              initialRequest: initialRequest,
              initialServiceability: initialServiceability,
              isPostpaid: extra is Map
                  ? (extra['isPostpaid'] as bool?) ?? false
                  : false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/international-booking',
        builder: (context, state) {
          final extra = state.extra;
          final ShopifyOrder order;
          var isBulkEdit = false;
          BookingRequest? initialRequest;
          ServiceabilityResult? initialServiceability;

          if (extra is ShopifyOrder) {
            order = extra;
          } else if (extra is Map<String, dynamic>) {
            final map = extra;
            order = map['order'] as ShopifyOrder;
            isBulkEdit = map['isBulkEdit'] as bool? ?? false;
            initialRequest = map['initialRequest'] as BookingRequest?;
            initialServiceability =
                map['initialServiceability'] as ServiceabilityResult?;
          } else {
            return const Scaffold(
              body: Center(child: Text('Invalid international booking data')),
            );
          }

          return BlocProvider(
            create: (context) => getIt<BookingBloc>(),
            child: InternationalBookingScreen(
              order: order,
              isBulkEdit: isBulkEdit,
              initialRequest: initialRequest,
              initialServiceability: initialServiceability,
              isPostpaid: extra is Map
                  ? (extra['isPostpaid'] as bool?) ?? false
                  : false,
            ),
          );
        },
      ),
      GoRoute(
        path: '/booking-summary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return const Scaffold(
              body: Center(child: Text('Booking summary data missing')),
            );
          }
          return BlocProvider(
            create: (context) => getIt<BookingBloc>(),
            child: BookingSummaryScreen(
              request: extra['request'] as BookingRequest,
              bookingId: extra['bookingId'] as String,
              serviceabilityResult: extra['rates'] as ServiceabilityResult?,
              tempBookingResponse:
                  extra['tempBookingResponse'] as TempBookingResponse?,
              intlTempIds: extra['intlTempIds'] != null
                  ? List<int>.from(extra['intlTempIds'] as Iterable)
                  : null,
            ),
          );
        },
      ),
      GoRoute(
        path: '/booking-status',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return const Scaffold(
              body: Center(child: Text('Booking status details missing')),
            );
          }
          return BookingStatusScreen(
            isSuccess: extra['isSuccess'] as bool? ?? false,
            bookingId: extra['bookingId'] as String?,
            transactionId: extra['transactionId'] as String?,
            errorMessage: extra['errorMessage'] as String?,
            amount: extra['amount'] as double? ?? 0.0,
            awbList: (extra['awbList'] as List?)?.cast<String>(),
            paymentMethod: extra['paymentMethod'] as String?,
            walletAmount: extra['walletAmount'] as double?,
            onlineAmount: extra['onlineAmount'] as double?,
          );
        },
      ),
      GoRoute(
        path: '/bulk-booking-summary',
        builder: (context, state) {
          final extra = state.extra;
          final List<ShopifyOrder> orders = extra is List
              ? extra.cast<ShopifyOrder>()
              : <ShopifyOrder>[];

          if (orders.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Bulk booking orders missing')),
            );
          }
          return BlocProvider(
            create: (context) => getIt<BookingBloc>(),
            child: BulkBookingSummaryScreen(orders: orders),
          );
        },
      ),
      GoRoute(
        path: '/bulk-booking-payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            return const Scaffold(
              body: Center(child: Text('Bulk payment data missing')),
            );
          }
          return BlocProvider(
            create: (context) => getIt<BookingBloc>(),
            child: BulkBookingPaymentScreen(
              requests: (extra['requests'] as List? ?? [])
                  .cast<BookingRequest>(),
              totalAmount: extra['totalAmount'] as double? ?? 0.0,
              totalWeight: extra['totalWeight'] as double? ?? 0.0,
              tempBookingResponse:
                  extra['tempBookingResponse'] as TempBookingResponse,
            ),
          );
        },
      ),
      GoRoute(
        path: '/domestic-booking-details/:awbNo',
        builder: (context, state) {
          final awbNo = state.pathParameters['awbNo'];
          if (awbNo == null) {
            return const Scaffold(
              body: Center(child: Text('AWB Number missing')),
            );
          }
          return BlocProvider(
            create: (context) => getIt<HistoryBloc>(),
            child: DomesticBookingDetailsScreen(awbNo: awbNo),
          );
        },
      ),
      GoRoute(
        path: '/international-booking-details',
        builder: (context, state) {
          final booking = state.extra as InternationalBookingHistory?;
          if (booking == null) {
            return const Scaffold(
              body: Center(child: Text('Booking details missing')),
            );
          }
          return InternationalBookingDetailsScreen(booking: booking);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
