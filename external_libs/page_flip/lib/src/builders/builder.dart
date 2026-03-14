import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../page_flip.dart';

Map<int, ui.Image?> imageData = {};
ValueNotifier<int> currentPage = ValueNotifier(-1);
ValueNotifier<Widget> currentWidget = ValueNotifier(Container());
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

class PageFlipBuilder extends StatefulWidget {
  const PageFlipBuilder({
    Key? key,
    required this.amount,
    this.backgroundColor,
    required this.child,
    required this.pageIndex,
    required this.isRightSwipe,
    this.imageUrl,
  }) : super(key: key);

  final Animation<double> amount;
  final int pageIndex;
  final Color? backgroundColor;
  final Widget child;
  final bool isRightSwipe;
  final String? imageUrl;

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder> {
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    currentPageIndex.addListener(_checkLoadImage);
    _checkLoadImage();
  }

  @override
  void dispose() {
    currentPageIndex.removeListener(_checkLoadImage);
    super.dispose();
  }

  void _checkLoadImage() {
    if (widget.imageUrl != null) {
      final diff = (currentPageIndex.value - widget.pageIndex).abs();
      if (diff <= 2) {
        _loadImageFromUrl();
      }
    }
  }

  void _loadImageFromUrl() async {
    if (widget.imageUrl == null || _isLoadingImage || imageData[widget.pageIndex] != null) return;
    _isLoadingImage = true;
    try {
      final ImageStream stream = NetworkImage(widget.imageUrl!).resolve(ImageConfiguration.empty);
      final Completer<ui.Image> completer = Completer<ui.Image>();
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo frame, bool synchronousCall) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete(frame.image);
      }, onError: (dynamic error, StackTrace? stackTrace) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.completeError(error);
      });
      stream.addListener(listener);
      final image = await completer.future;
      if (mounted) {
        setState(() {
          imageData[widget.pageIndex] = image.clone();
        });
      }
    } catch (e) {
      // ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPage,
      builder: (context, value, child) {
        if (imageData[widget.pageIndex] != null && value >= 0) {
          return CustomPaint(
            painter: PageFlipEffect(
              amount: widget.amount,
              image: imageData[widget.pageIndex]!,
              backgroundColor: widget.backgroundColor,
              isRightSwipe: widget.isRightSwipe,
            ),
            size: Size.infinite,
          );
        } else {
          if (widget.pageIndex == currentPageIndex.value || (widget.pageIndex == (currentPageIndex.value + 1))) {
            Widget content = widget.child;
            if (widget.imageUrl != null && imageData[widget.pageIndex] != null) {
              content = RawImage(
                image: imageData[widget.pageIndex]!,
                fit: BoxFit.fill,
              );
            }
            return ColoredBox(
              color: widget.backgroundColor ?? Colors.black12,
              child: content,
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}
