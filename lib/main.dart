// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router_books/src/auth.dart';
import 'package:go_router_books/src/config/router/routes.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const Bookstore());
}

/// The book store view.
class Bookstore extends StatelessWidget {
  /// Creates a [Bookstore].
  const Bookstore({super.key});

  @override
  Widget build(BuildContext context) {
    return BookstoreAuthScope(
      notifier: Routes.authListenable,
      child: MaterialApp.router(
        routerConfig: Routes.router,
      ),
    );
  }
}
