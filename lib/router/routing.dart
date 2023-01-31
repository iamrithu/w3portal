import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:w3portal/provider/provider.dart';
import 'package:w3portal/router/route-const.dart';

import '../screen/attendence/attendence.dart';
import '../screen/home-screen/home-screen.dart';
import '../screen/login-screen/login-screen.dart';
import '../screen/notification/notification.dart';
import '../screen/task/task.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
GoRouter? _previousRouter;

final goRouterProvider = Provider<GoRouter>(
  ((ref) {
    final loggedIn = ref.watch(loggedInProvider);

    final router = RouterNotifier(ref);
    return GoRouter(
      initialLocation: _previousRouter?.location,
      navigatorKey: _navigatorKey,
      routes: router._router,
      redirect: (context, state) async {
        final loggingIn = state.location == '/login';
        if (!loggedIn) {
          if (!loggingIn) return '/login';
          return null;
        }

        if (loggingIn) return '/';
        return null;
      },
    );
  }),
);

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref);

  // String? _redirectLogic(BuildContext context, GoRouterState state) {
  //   print("rithi1234");
  //   final loginState = _ref.read(loginControllerProvider);

  //   final areWeLoggingIn = state.location == '/login';
  //   if (_ref.watch(loggedInProvider) && state.subloc == "/") {
  //     return '/login';
  //   }
  //   return null;

  //   // if (loginState is LoginStateInitial) {
  //   //   return areWeLoggingIn ? null : '/login';
  //   // }

  //   // if (areWeLoggingIn) return '/';

  //   return null;
  // }

  List<GoRoute> get _router => [
        GoRoute(
          name: RouterConstants.home,
          path: '/',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: const HomeScreen(),
            );
          },
        ),
        GoRoute(
          name: RouterConstants.notification,
          path: '/notification',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: NotificationScreen(token: state.queryParams),
            );
          },
        ),
        GoRoute(
          name: RouterConstants.attendence,
          path: '/attendence',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: AttendenceScreen(token: state.queryParams),
            );
          },
        ),
        GoRoute(
          name: RouterConstants.task,
          path: '/task',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: TaskScreen(token: state.queryParams),
            );
          },
        ),
        GoRoute(
          name: RouterConstants.login,
          path: '/login',
          pageBuilder: (context, state) {
            return MaterialPage(
              child: LoginScreen(),
            );
          },
        ),
      ];
}
