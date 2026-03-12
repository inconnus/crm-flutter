import 'package:crm/features/home/presentation/home_screen.dart';
import 'package:crm/router/presentation/navigation_bar.dart';
import 'package:crm/router/presentation/scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> _dashboardNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true, // Helpful for debugging deep links
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return ScaffoldContainer(
          bottomNavigationBar: NavigationBarContainer(navigationShell: navigationShell),
          child: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home2', builder: (context, state) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/home3', builder: (context, state) => const HomeScreen())],
        ),
      ],
    ),
  ],
);
