import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double safeAreaTop = MediaQuery.paddingOf(context).top;
    final double maxSheetSize = (1.0 - ((safeAreaTop + kToolbarHeight) / screenHeight)).clamp(0.8, 1.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset('assets/images/header.png'),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.8,
            minChildSize: 0.8,
            maxChildSize: maxSheetSize,
            builder: (context, scrollController) {
              return AnimatedBuilder(
                animation: _sheetController,
                builder: (context, child) {
                  double radius = 40.0;
                  if (_sheetController.isAttached) {
                    final double range = maxSheetSize - 0.8;
                    if (range > 0.01) {
                      final double ratio = ((_sheetController.size - 0.8) / range).clamp(0.0, 1.0);
                      radius = 40.0 * (1.0 - ratio);
                    } else {
                      radius = 0.0;
                    }
                  }
                  return Container(
                    decoration: ShapeDecoration(
                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radius))),
                      color: Colors.white,
                      shadows: const [BoxShadow(blurRadius: 10, color: Colors.black12)],
                    ),
                    child: child,
                  );
                },
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Color(0xFFcd2a2f),
                        labelColor: Color(0xFFcd2a2f),
                        tabs: [
                          Tab(text: 'ร้านค้า'),
                          Tab(text: 'สินค้าทั้งหมด'),
                          Tab(text: 'หมวดหมู่'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              itemCount: 50,
                              itemBuilder: (context, index) {
                                return ListTile(title: Text('Item $index'));
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              itemCount: 50,
                              itemBuilder: (context, index) {
                                return ListTile(title: Text('Item $index'));
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              itemCount: 50,
                              itemBuilder: (context, index) {
                                return ListTile(title: Text('Item $index'));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _sheetController,
              builder: (context, child) {
                double opacity = 0.0;
                if (_sheetController.isAttached) {
                  // Fade immediately as the sheet moves from 0.8 upwards
                  final double range = maxSheetSize - 0.8;
                  if (range > 0.01) {
                    opacity = ((_sheetController.size - 0.8) / range).clamp(0.0, 1.0);
                  } else {
                    opacity = 1.0;
                  }
                }
                return Container(
                  height: MediaQuery.paddingOf(context).top + kToolbarHeight,
                  padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top, left: 16, right: 16, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(opacity),
                    boxShadow: opacity > 0
                        ? [BoxShadow(color: Colors.black.withOpacity(opacity * 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 234, 234, 234).withAlpha((255 * opacity).toInt()),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(hintText: 'ค้นหา...', border: InputBorder.none, isDense: true),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
