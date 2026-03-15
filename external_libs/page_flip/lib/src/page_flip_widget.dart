import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'effects/flip_effect.dart';

class PageFlipController {
  _PageFlipWidgetState? _state;
  void nextPage() => _state?.nextPage();
  void previousPage() => _state?.previousPage();
  void goToPage(int index) => _state?.goToPage(index);
}

class PageFlipWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Duration duration;
  final Color backgroundColor;
  final int initialIndex;
  final Widget? lastPage;
  final double cutoffForward;
  final double cutoffPrevious;
  final bool isRightSwipe;
  final PageFlipController? controller;
  final ValueChanged<int>? onPageFlipped;
  final VoidCallback? onFlipStart;

  const PageFlipWidget({
    super.key,
    required this.imageUrls,
    this.duration = const Duration(milliseconds: 450),
    this.backgroundColor = Colors.white,
    this.initialIndex = 0,
    this.lastPage,
    this.cutoffForward = 0.8,
    this.cutoffPrevious = 0.1,
    this.isRightSwipe = false,
    this.controller,
    this.onPageFlipped,
    this.onFlipStart,
  }) : assert(initialIndex >= 0 && initialIndex < imageUrls.length);

  @override
  State<PageFlipWidget> createState() => _PageFlipWidgetState();
}

class _PageFlipWidgetState extends State<PageFlipWidget> with TickerProviderStateMixin {
  int _currentPage = 0;
  final Map<int, ui.Image> _imageCache = {};
  late final List<AnimationController> _controllers;
  bool? _isForward;
  int _activeDragPage = -1;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    widget.controller?._state = this;
    _setupControllers();
    _preloadImages();
  }

  void _setupControllers() {
    final int totalPages = widget.imageUrls.length + (widget.lastPage != null ? 1 : 0);
    _controllers = List.generate(
      totalPages,
      (_) => AnimationController(vsync: this, duration: widget.duration, value: 1.0),
    );
    if (_currentPage > 0) {
      for (int i = 0; i < _currentPage; i++) {
        _controllers[i].value = 0.0;
      }
    }
  }

  // Eagerly pre-cache images in background to avoid jank on swipe
  void _preloadImages() async {
    for (int i = 0; i < widget.imageUrls.length; i++) {
      _loadImage(i);
      // หยอดจังหวะให้ Main UI Thread หายใจเวลาโหลดรูปรัวๆ จะได้ไม่กระตุกตอนเปิด Bottomsheet
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  Future<void> _loadImage(int index) async {
    if (index >= widget.imageUrls.length) return;
    if (_imageCache.containsKey(index)) return;
    try {
      final ImageStream stream = NetworkImage(widget.imageUrls[index]).resolve(ImageConfiguration.empty);
      final Completer<ui.Image> completer = Completer<ui.Image>();
      late ImageStreamListener listener;
      listener = ImageStreamListener((ImageInfo info, bool _) {
        if (!completer.isCompleted) completer.complete(info.image);
        stream.removeListener(listener);
      }, onError: (dynamic error, StackTrace? stackTrace) {
        if (!completer.isCompleted) completer.completeError(error);
        stream.removeListener(listener);
      });
      stream.addListener(listener);
      final ui.Image img = await completer.future;
      if (mounted) setState(() => _imageCache[index] = img);
    } catch (_) {
      // Ignore network errors, it stays null in cache map
    }
  }

  @override
  void dispose() {
    for (final AnimationController c in _controllers) {
      c.dispose();
    }
    for (final ui.Image img in _imageCache.values) {
      img.dispose();
    }
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _controllers.length - 1;
  bool get _isFirstPage => _currentPage == 0;

  void _turnPage(DragUpdateDetails details, BoxConstraints dimens) {
    if (_controllers.isEmpty) return;
    final double ratio = details.delta.dx / dimens.maxWidth;

    if (_isForward == null) {
      if (widget.isRightSwipe ? details.delta.dx < 0.0 : details.delta.dx > 0.0) {
        _isForward = false;
      } else if (widget.isRightSwipe ? details.delta.dx > 0.2 : details.delta.dx < -0.2) {
        _isForward = true;
      } else {
        _isForward = null;
      }
    }

    if (_isForward == true || _currentPage == 0) {
      if (!_isLastPage) {
        _activeDragPage = _currentPage;
        if (widget.isRightSwipe) {
          _controllers[_currentPage].value -= ratio;
        } else {
          _controllers[_currentPage].value += ratio;
        }
      }
    }
  }

  Future<void> _onDragFinish() async {
    if (_isForward != null) {
      if (_isForward == true) {
        if (!_isLastPage && _controllers[_currentPage].value <= (widget.cutoffForward + 0.15)) {
          await nextPage();
        } else if (!_isLastPage) {
          await _controllers[_currentPage].forward();
        }
      } else {
        if (!_isFirstPage && _controllers[_currentPage - 1].value >= widget.cutoffPrevious) {
          await previousPage();
        } else if (_isFirstPage) {
          await _controllers[_currentPage].forward();
        } else {
          await _controllers[_currentPage - 1].reverse();
          if (!_isFirstPage) await previousPage();
        }
      }
    }
    if (mounted) {
      setState(() {
        _isForward = null;
        _activeDragPage = -1;
      });
    }
  }

  Future<void> nextPage() async {
    if (_isLastPage) return;
    widget.onFlipStart?.call();
    setState(() => _activeDragPage = _currentPage);
    await _controllers[_currentPage].reverse();
    if (mounted) {
      setState(() {
        _currentPage++;
        _activeDragPage = -1;
      });
      widget.onPageFlipped?.call(_currentPage);
    }
  }

  Future<void> previousPage() async {
    if (_isFirstPage) return;
    widget.onFlipStart?.call();
    setState(() => _activeDragPage = _currentPage - 1);
    await _controllers[_currentPage - 1].forward();
    if (mounted) {
      setState(() {
        _currentPage--;
        _activeDragPage = -1;
      });
      widget.onPageFlipped?.call(_currentPage);
    }
  }

  Future<void> goToPage(int index) async {
    if (index < 0 || index >= _controllers.length) return;
    if (mounted) setState(() => _currentPage = index);
    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].forward();
      } else if (i < index) {
        _controllers[i].reverse();
      } else if (_controllers[i].status == AnimationStatus.reverse) {
        _controllers[i].value = 1.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutQuart,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.0,
            child: Image.network(
              widget.imageUrls.first,
              width: double.infinity,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(height: 350, width: double.infinity);
              },
              errorBuilder: (context, error, stackTrace) => const SizedBox(height: 350, width: double.infinity),
            ),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, dimens) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragCancel: () => setState(() => _isForward = null),
                  onHorizontalDragUpdate: (details) => _turnPage(details, dimens),
                  onHorizontalDragEnd: (details) => _onDragFinish(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: List.generate(_controllers.length, (idx) {
                      final int invertedIdx = _controllers.length - 1 - idx;
                      return _buildPage(invertedIdx);
                    }),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final bool isLastPageItem = index == widget.imageUrls.length && widget.lastPage != null;
    final ui.Image? img = _imageCache[index];

    return AnimatedBuilder(
      animation: _controllers[index],
      builder: (context, child) {
        final double amount = _controllers[index].value;

        // Performance: Don't render pages completely flipped over
        if (amount <= 0.0) return const SizedBox.shrink();

        // Performance: Hide underneath pages that are far below the stack
        if (amount == 1.0 && index > _currentPage + 1) {
          return const SizedBox.shrink();
        }

        // Smoothly render page flip effect if animating/dragging
        if ((amount < 1.0 && amount > 0.0) || _activeDragPage == index) {
          if (img != null) {
            return CustomPaint(
              painter: PageFlipEffect(
                amount: _controllers[index],
                image: img,
                backgroundColor: widget.backgroundColor,
                isRightSwipe: widget.isRightSwipe,
              ),
              size: Size.infinite,
            );
          }
          return ColoredBox(color: widget.backgroundColor);
        }

        // Static display when page is fully rested on top
        return ColoredBox(
          color: widget.backgroundColor,
          child: (img != null
              ? RawImage(image: img, fit: BoxFit.fill)
              : const SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )),
        );
      },
    );
  }
}
