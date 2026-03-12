import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScaffoldContainer extends ConsumerWidget {
  const ScaffoldContainer({super.key, required this.child, this.bottomNavigationBar});
  final Widget child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: Scaffold(extendBody: true, body: child, bottomNavigationBar: bottomNavigationBar),
    );
  }
}
