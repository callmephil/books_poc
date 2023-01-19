// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:go_router_books/src/data/data.dart';
import 'package:go_router_books/src/widgets/author_list.dart';

/// A screen that displays a list of authors.
class AuthorsScreen extends StatelessWidget {
  /// Creates an [AuthorsScreen].
  const AuthorsScreen({super.key});

  /// The title of the screen.
  static const String title = 'Authors';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
      ),
      body: AuthorList(
        authors: libraryInstance.allAuthors,
        onTap: (Author author) {
          context.go('/author/${author.id}');
        },
      ),
    );
  }
}
