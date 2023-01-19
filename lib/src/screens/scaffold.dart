// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:adaptive_navigation/adaptive_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

/// The enum for scaffold tab.
enum ScaffoldTab {
  /// The books tab.
  books,

  /// The authors tab.
  authors,

  /// The settings tab.
  settings
}

/// The scaffold for the book store.
class BookstoreScaffold extends StatelessWidget {
  /// Creates a [BookstoreScaffold].
  const BookstoreScaffold({
    required this.selectedTab,
    required this.child,
    super.key,
  });

  /// Which tab of the scaffold to display.
  final ScaffoldTab selectedTab;

  /// The scaffold body.
  final Widget child;

  static final _destinations = [
    const NavigationDestination(label: 'Books', icon: Icon(Icons.book)),
    const NavigationDestination(label: 'Authors', icon: Icon(Icons.person)),
    const NavigationDestination(label: 'Settings', icon: Icon(Icons.settings)),
  ];

  static void _onDestinationSelected(BuildContext context, int idx) {
    switch (ScaffoldTab.values[idx]) {
      case ScaffoldTab.books:
        context.go('/books');
        break;
      case ScaffoldTab.authors:
        context.go('/authors');
        break;
      case ScaffoldTab.settings:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilt scaffold');
    return Scaffold(
      body: AdaptiveLayout(
        body: SlotLayout(
          key: const Key('SlotLayout1'),
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.smallAndUp: SlotLayout.from(
              key: const Key('some key'),
              builder: (_) => child,
            ),
          },
        ),
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.medium: SlotLayout.from(
              key: const Key('Primary Navigation Medium'),
              builder: (_) => AdaptiveScaffold.standardNavigationRail(
                selectedIndex: selectedTab.index,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                destinations: _destinations
                    .map(AdaptiveScaffold.toRailDestination)
                    .toList(),
                onDestinationSelected: (index) {
                  _onDestinationSelected(context, index);
                },
              ),
            ),
            Breakpoints.large: SlotLayout.from(
              key: const Key('Primary Navigation Large'),
              builder: (_) => AdaptiveScaffold.standardNavigationRail(
                selectedIndex: selectedTab.index,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                extended: true,
                destinations: _destinations
                    .map(AdaptiveScaffold.toRailDestination)
                    .toList(),
                onDestinationSelected: (index) {
                  _onDestinationSelected(context, index);
                },
              ),
            ),
          },
        ),
        bottomNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('bottomNavigation'),
              builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
                currentIndex: selectedTab.index,
                destinations: _destinations,
                onDestinationSelected: (index) {
                  _onDestinationSelected(context, index);
                },
              ),
            )
          },
        ),
      ),
    );
  }
}

//  body: AdaptiveNavigationScaffold(
//         selectedIndex: selectedTab.index,
//         body: child,
//         onDestinationSelected: (int idx) {
//           switch (ScaffoldTab.values[idx]) {
//             case ScaffoldTab.books:
//               context.go('/books');
//               break;
//             case ScaffoldTab.authors:
//               context.go('/authors');
//               break;
//             case ScaffoldTab.settings:
//               context.go('/settings');
//               break;
//           }
//         },
//         destinations: const <AdaptiveScaffoldDestination>[
//           AdaptiveScaffoldDestination(
//             title: 'Books',
//             icon: Icons.book,
//           ),
//           AdaptiveScaffoldDestination(
//             title: 'Authors',
//             icon: Icons.person,
//           ),
//           AdaptiveScaffoldDestination(
//             title: 'Settings',
//             icon: Icons.settings,
//           ),
//         ],
//       ),
