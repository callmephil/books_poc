import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart' show BuildContext, Text, ValueKey;
import 'package:go_router/go_router.dart';
import 'package:go_router_books/src/auth.dart';
import 'package:go_router_books/src/config/router/transitions/fade_transition_page.dart';
import 'package:go_router_books/src/data/author.dart';
import 'package:go_router_books/src/data/book.dart';
import 'package:go_router_books/src/data/library.dart';
import 'package:go_router_books/src/screens/author_details.dart';
import 'package:go_router_books/src/screens/authors.dart';
import 'package:go_router_books/src/screens/book_details.dart';
import 'package:go_router_books/src/screens/books.dart';
import 'package:go_router_books/src/screens/scaffold.dart';
import 'package:go_router_books/src/screens/settings.dart';
import 'package:go_router_books/src/screens/sign_in.dart';

/// Router
class Routes {
  Routes._();

  /// Keys
  static const ValueKey<String> _scaffoldKey = ValueKey<String>('App scaffold');

  /// Router instance
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: authListenable,
    routes: [..._directNavigations, ..._nestedNavigations],
    errorBuilder: (_, __) => const Text('404'),
    redirect: _authGuard,
  );

  /// defines which routes are supposed to be accessible without sign-in tokens.
  // static final _publicRoutes = <String>[];

  /// defines'root' route. routes that are un-related such as login to home.
  static final _directNavigations = <GoRoute>[
    GoRoute(
      path: '/',
      redirect: (_, __) => '/books',
    ),
    GoRoute(
      path: '/signin',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: SignInScreen(
            onSignIn: (Credentials credentials) {
              BookstoreAuthScope.of(context)
                  .signIn(credentials.username, credentials.password);
            },
          ),
        );
      },
    ),
    GoRoute(
      path: '/books',
      redirect: (_, __) => '/books/popular',
    ),
    GoRoute(
      path: '/book/:bookId',
      redirect: (BuildContext context, GoRouterState state) {
        return '/books/all/${state.params['bookId']}';
      },
    ),
    GoRoute(
      path: '/books/:kind(new|all|popular)',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          key: _scaffoldKey,
          child: BookstoreScaffold(
            selectedTab: ScaffoldTab.books,
            child: BooksScreen(state.params['kind']!),
          ),
        );
      },
      routes: <GoRoute>[
        GoRoute(
          path: ':bookId',
          builder: (BuildContext context, GoRouterState state) {
            final bookId = state.params['bookId']!;
            final selectedBook = libraryInstance.allBooks
                .firstWhereOrNull((Book b) => b.id.toString() == bookId);

            return BookDetailsScreen(book: selectedBook);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/author/:authorId',
      redirect: (BuildContext context, GoRouterState state) {
        return '/authors/${state.params['authorId']}';
      },
    ),
    GoRoute(
      path: '/authors',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.authors,
            child: AuthorsScreen(),
          ),
        );
      },
      routes: <GoRoute>[
        GoRoute(
          path: ':authorId',
          builder: (BuildContext context, GoRouterState state) {
            final authorId = int.parse(state.params['authorId']!);
            final selectedAuthor = libraryInstance.allAuthors.firstWhereOrNull(
              (Author a) => a.id == authorId,
            );

            return AuthorDetailsScreen(author: selectedAuthor);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.settings,
            child: SettingsScreen(),
          ),
        );
      },
    ),
  ];

  /// defines sub-routes, usefull for when we need to render a dialog, tab etc
  static final _nestedNavigations = <ShellRoute>[];

  static final BookstoreAuth _auth = BookstoreAuth();

  /// Use this when you need to access auth state
  static BookstoreAuth get authListenable => _auth;

  static String? _authGuard(BuildContext context, GoRouterState state) {
    final signedIn = _auth.signedIn;
    final signingIn = state.subloc == '/signin';

    // // Go to /signin if the user is not signed in
    if (!signedIn && !signingIn) {
      return '/signin';
    }
    // Go to /books if the user is signed in and tries to go to /signin.
    else if (signedIn && signingIn) {
      return '/books';
    }

    // no redirect
    return null;
  }
}
