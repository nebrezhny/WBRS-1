import 'package:go_router/go_router.dart';
import 'package:wbrs/app/pages/admin/meets.dart';
import 'package:wbrs/presentations/screens/profile/profile_page.dart';
import 'package:wbrs/presentations/screens/list_of_users/profiles_list.dart';

import '../screens/home/home_page.dart';
import '../screens/root/root_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RootScreen(navigationShell: navigationShell,),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfilePage(email: state.pathParameters['email']!, userName: state.pathParameters['userName']!, about: state.pathParameters['about']!, age: state.pathParameters['age']!, rost: state.pathParameters['rost']!, group: state.pathParameters['group']!, deti: bool.parse(state.pathParameters['deti']!), hobbi: state.pathParameters['hobbi']!, city: state.pathParameters['city']!, pol: state.pathParameters['pol']!,),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/users',
              builder: (context, state) => ProfilesList(group: state.pathParameters['group']!, startPosition: int.parse(state.pathParameters['startPosition']!),),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meets',
              builder: (context, state) => const Meets(),
            ),
          ]),
    ])
  ],
);