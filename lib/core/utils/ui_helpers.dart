import 'package:flutter/material.dart';

Future<void> showCustomModalBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder, String? title}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
    clipBehavior: Clip.antiAlias,
    sheetAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 150)),
    builder: (context) {
      // 1. ดึง Widget จาก builder มาเช็คก่อน
      final content = builder(context);

      return Column(
        mainAxisSize: MainAxisSize.min, // ให้หดเท่าที่จำเป็นถ้าไม่มี FractionallySizedBox
        children: [
          // ส่วน Header
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                  ),
                ],
              ),
            ),
          Divider(height: 0, color: Colors.grey[200]),
          Flexible(child: content),
        ],
      );
    },
  );
}

Future<void> showCustomModalBottomSheetFull({
  required BuildContext context,
  required Widget Function(BuildContext, ScrollController) builder,
  String? title,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, // ยอมให้ขยายหน้าจอได้เกิน 50%
    backgroundColor: Colors.transparent, // เพื่อให้เห็นขอบโค้งของ Container ด้านใน
    useRootNavigator: true,
    clipBehavior: Clip.antiAlias,
    useSafeArea: true,
    builder: (context) {
      return _NestedNavigatorContent(builder: builder, title: title);
    },
  );
}

class _NestedNavigatorContent extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) builder;
  final String? title;

  const _NestedNavigatorContent({required this.builder, this.title});

  @override
  State<_NestedNavigatorContent> createState() => _NestedNavigatorContentState();
}

class _NestedNavigatorContentState extends State<_NestedNavigatorContent> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _canPopOuter = true;
  bool _forceClose = false;
  String? _currentTitle;
  bool _isPop = false;

  @override
  void initState() {
    super.initState();
    _currentTitle = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _forceClose || _canPopOuter,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        final nav = _navigatorKey.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0],
        snapAnimationDuration: const Duration(milliseconds: 150),
        builder: (context, scrollController) {
          return Container(
            decoration: const ShapeDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
            ),
            child: Column(
              children: [
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!_canPopOuter)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                              onPressed: () {
                                final nav = _navigatorKey.currentState;
                                if (nav != null && nav.canPop()) {
                                  nav.pop();
                                }
                              },
                            ),
                          ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            final isIncoming = child.key == ValueKey<String?>(_currentTitle);
                            Offset beginOffset;

                            if (!_isPop) {
                              // Push direction
                              beginOffset = isIncoming ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
                            } else {
                              // Pop direction
                              beginOffset = isIncoming ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
                            }

                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(begin: beginOffset, end: Offset.zero).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            _currentTitle ?? '',
                            key: ValueKey<String?>(_currentTitle),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              setState(() => _forceClose = true);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(height: 0, color: Colors.grey[200]),
                Expanded(
                  child: Navigator(
                    key: _navigatorKey,
                    observers: [
                      _PopObserver(
                        onRouteChanged: (canPopInner, routeTitle, isPop) {
                          final shouldPopOuter = !canPopInner;
                          final nextTitle = routeTitle ?? widget.title;
                          if (_canPopOuter != shouldPopOuter || _currentTitle != nextTitle) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                // Update state with pop flag to drive the proper direction
                                setState(() {
                                  _canPopOuter = shouldPopOuter;
                                  _isPop = isPop;
                                  _currentTitle = nextTitle;
                                });
                              }
                            });
                          }
                        },
                      ),
                    ],
                    onGenerateRoute: (settings) => MaterialPageRoute(builder: (navContext) => widget.builder(navContext, scrollController)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PopObserver extends NavigatorObserver {
  final void Function(bool canPop, String? currentTitle, bool isPop) onRouteChanged;
  _PopObserver({required this.onRouteChanged});

  void _update(Route<dynamic>? topRoute, bool isPop) {
    bool canPop = navigator?.canPop() ?? false;
    String? title;
    if (topRoute?.settings.arguments is String) {
      title = topRoute!.settings.arguments as String;
    } else if (topRoute?.settings.arguments is Map && (topRoute?.settings.arguments as Map).containsKey('title')) {
      title = (topRoute?.settings.arguments as Map)['title'] as String?;
    }
    Future.microtask(() => onRouteChanged(canPop, title, isPop));
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _update(route, false);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _update(previousRoute, true);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _update(previousRoute, true);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _update(newRoute, false);
  }
}
