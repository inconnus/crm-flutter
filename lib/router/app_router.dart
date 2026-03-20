import 'package:crm/features/home/presentation/home_screen.dart';
import 'package:crm/features/map/presentation/map_screen.dart';
import 'package:crm/features/profile/profile_screen.dart';
import 'package:crm/features/store/presentation/store_screen.dart';
import 'package:crm/router/presentation/fade_indexed_stack.dart';
import 'package:crm/router/presentation/navigation_bar.dart';
import 'package:crm/router/presentation/scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> _dashboardNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: '/home',
  debugLogDiagnostics: true, // Helpful for debugging deep links
  routes: <RouteBase>[
    StatefulShellRoute(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return ScaffoldContainer(
          bottomNavigationBar: NavigationBarContainer(navigationShell: navigationShell),
          child: navigationShell,
        );
      },
      navigatorContainerBuilder: (context, navigationShell, children) {
        return FadeIndexedStack(index: navigationShell.currentIndex, children: children);
      },
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/store', builder: (context, state) => const StoreScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())],
        ),
      ],
    ),
  ],
);
