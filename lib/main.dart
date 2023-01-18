// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_books/src/auth.dart';
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
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(Bookstore());
}

/// The book store view.
class Bookstore extends StatelessWidget {
  /// Creates a [Bookstore].
  Bookstore({super.key});

  final ValueKey<String> _scaffoldKey = const ValueKey<String>('App scaffold');

  @override
  Widget build(BuildContext context) => BookstoreAuthScope(
        notifier: _auth,
        child: MaterialApp.router(
          routerConfig: _router,
        ),
      );

  final BookstoreAuth _auth = BookstoreAuth();

  late final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        redirect: (_, __) => '/books',
      ),
      GoRoute(
        path: '/signin',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: state.pageKey,
          child: SignInScreen(
            onSignIn: (Credentials credentials) {
              BookstoreAuthScope.of(context)
                  .signIn(credentials.username, credentials.password);
            },
          ),
        ),
      ),
      GoRoute(
        path: '/books',
        redirect: (_, __) => '/books/popular',
      ),
      GoRoute(
        path: '/book/:bookId',
        redirect: (BuildContext context, GoRouterState state) =>
            '/books/all/${state.params['bookId']}',
      ),
      GoRoute(
        path: '/books/:kind(new|all|popular)',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: BookstoreScaffold(
            selectedTab: ScaffoldTab.books,
            child: BooksScreen(state.params['kind']!),
          ),
        ),
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
        redirect: (BuildContext context, GoRouterState state) =>
            '/authors/${state.params['authorId']}',
      ),
      GoRoute(
        path: '/authors',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.authors,
            child: AuthorsScreen(),
          ),
        ),
        routes: <GoRoute>[
          GoRoute(
            path: ':authorId',
            builder: (BuildContext context, GoRouterState state) {
              final authorId = int.parse(state.params['authorId']!);
              final selectedAuthor = libraryInstance.allAuthors
                  .firstWhereOrNull((Author a) => a.id == authorId);

              return AuthorDetailsScreen(author: selectedAuthor);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            FadeTransitionPage(
          key: _scaffoldKey,
          child: const BookstoreScaffold(
            selectedTab: ScaffoldTab.settings,
            child: SettingsScreen(),
          ),
        ),
      ),
    ],
    redirect: _guard,
    refreshListenable: _auth,
    debugLogDiagnostics: true,
  );

  String? _guard(BuildContext context, GoRouterState state) {
    final signedIn = _auth.signedIn;
    final signingIn = state.subloc == '/signin';

    // Go to /signin if the user is not signed in
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

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation.drive(_curveTween),
            child: child,
          ),
        );

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
