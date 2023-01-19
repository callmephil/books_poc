// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:go_router_books/src/data/data.dart';

/// The book list view.
class BookList extends StatelessWidget {
  /// Creates an [BookList].
  const BookList({
    required this.books,
    this.onTap,
    super.key,
  });

  /// The list of books to be displayed.
  final List<Book> books;

  /// Called when the user taps a book.
  final ValueChanged<Book>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text(
        books[index].title,
      ),
      subtitle: Text(
        books[index].author.name,
      ),
      onTap: onTap != null ? () => onTap!(books[index]) : null,
    );
  }
}
