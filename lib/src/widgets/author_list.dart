// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router_books/src/data/data.dart';

/// The author list view.
class AuthorList extends StatelessWidget {
  /// Creates an [AuthorList].
  const AuthorList({
    required this.authors,
    this.onTap,
    super.key,
  });

  /// The list of authors to be shown.
  final List<Author> authors;

  /// Called when the user taps an author.
  final ValueChanged<Author>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: authors.length,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(
        authors[index].name,
      ),
      subtitle: Text(
        '${authors[index].books.length} books',
      ),
      onTap: onTap != null ? () => onTap!(authors[index]) : null,
    );
  }
}
