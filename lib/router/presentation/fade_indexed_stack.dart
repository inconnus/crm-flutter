import 'package:flutter/material.dart';

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({super.key, required this.index, required this.children, this.duration = const Duration(milliseconds: 200)});

  @override
  State<FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> {
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.index;
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _previousIndex = oldWidget.index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: List.generate(widget.children.length, (index) {
        final bool isCurrent = index == widget.index;
        final bool isPrevious = index == _previousIndex;
        final bool isActive = isCurrent || isPrevious;

        return Offstage(
          offstage: !isActive,
          child: TickerMode(
            enabled: isActive,
            child: IgnorePointer(
              ignoring: !isCurrent,
              child: AnimatedOpacity(
                opacity: isCurrent ? 1.0 : 0.0,
                duration: widget.duration,
                curve: Curves.easeInOut,
                onEnd: () {
                  if (!isCurrent && mounted && _previousIndex == index) {
                    setState(() {
                      _previousIndex = widget.index;
                    });
                  }
                },
                child: widget.children[index],
              ),
            ),
          ),
        );
      }),
    );
  }
}
