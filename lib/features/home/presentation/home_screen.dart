import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final double initialSheetSize = 0.8;
  late final ValueNotifier<double> _parallaxOffset = ValueNotifier(0.0);
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  double _currentInitialFraction = 0.5;
  String qrData = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_checkRefreshThreshold);
  }

  void _checkRefreshThreshold() {
    double currentSize = _sheetController.size;
    if (currentSize <= _currentInitialFraction - 0.18) {
      setState(() {
        qrData = DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double topSpacePixels = 335;
    final double initialFraction = (screenHeight - topSpacePixels) / screenHeight;
    _currentInitialFraction = initialFraction;
    print('rebuild');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- ชั้นหลัง (Parallax Header) ---
          AnimatedBuilder(
            animation: _sheetController,
            builder: (context, child) {
              double currentExtent = 0.0;
              if (_sheetController.isAttached) {
                currentExtent = _sheetController.size;
              }
              double delta = currentExtent - initialFraction;
              double parallaxOffset = delta * -200;
              double pos = parallaxOffset.clamp(double.negativeInfinity, 0);
              return Transform.translate(
                offset: Offset(0, pos), // ขยับตามค่าที่คำนวณ
                child: RepaintBoundary(
                  child: Stack(
                    children: [
                      Transform.translate(offset: Offset(0, pos * 0.2), child: Image.asset('assets/images/header.png')),
                      child!,
                    ],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                SizedBox(height: 100),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    height: 210,
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    enlargeFactor: 0.35,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  ),
                  items: [1, 3, 2].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: ShapeDecoration(
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(95),
                                // side: BorderSide(color: Color.fromARGB(133, 237, 237, 237), width: 1),
                              ),
                              shadows: [BoxShadow(color: Colors.grey.withAlpha(100), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 0))],
                              image: DecorationImage(image: AssetImage('assets/images/s$i.jpg'), fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Text('ดึงลงเพื่อสแกน', style: TextStyle(color: Colors.grey)),
                QrImageView(data: qrData, version: QrVersions.auto, size: 160),
              ],
            ),
          ),

          // --- ชั้นหน้า (Draggable Sheet) ---
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: initialFraction,
            minChildSize: initialFraction - 0.18,
            maxChildSize: 1,
            snap: true,
            snapAnimationDuration: const Duration(milliseconds: 100),
            snapSizes: [initialFraction],
            builder: (context, scrollController) {
              return Container(
                decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100))),
                  color: Colors.white,
                  shadows: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 5),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(color: const Color.fromARGB(255, 218, 218, 218), borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                'https://scontent.fbkk12-3.fna.fbcdn.net/v/t39.30808-6/460039832_1939010103263800_8042369095264618016_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=1d70fc&_nc_ohc=C-Pf_By57TEQ7kNvwHBZL9K&_nc_oc=AdnR4rzZyAT9mTWJPqOLcurg1eATka4FiQbuQlW7l6p-ipMvyVzlXeaHeTq2sXeq7uo&_nc_zt=23&_nc_ht=scontent.fbkk12-3.fna&_nc_gid=S9Zxa-uJLtOe5txuZDfO5w&_nc_ss=8&oh=00_AfwNvpOHz4n_ClyCn82U8EoNY1vCWZKN7yI6BqCTMRy-xw&oe=69B6D33A',
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Chindanai Mala-eiam"),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon(Icons.star_rounded, size: 20, color: Color(0xFFFFB200)),
                                      Text(
                                        '123 คะแนน',
                                        style: TextStyle(color: Color(0xFFFFB200), fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                              decoration: BoxDecoration(color: Color(0xFFFFB200), borderRadius: BorderRadius.circular(35)),
                              child: Text('แลกคะแนน', style: TextStyle(color: Colors.white)),
                            ),
                            // Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text("สวัสดี"), Text("คุณ")]),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          spacing: 10,
                          children: [
                            Menu(text: 'จองคิว', icon: Icons.calendar_month_outlined, backgroundColor: Color(0xFFcd2a2f), textColor: Colors.white),
                            Menu(text: 'ประวัติ', icon: Icons.history_rounded),
                            Menu(text: 'รางวัล', icon: Icons.wallet_giftcard_rounded),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ListTile(title: Text("Item $index"), leading: const Icon(Icons.circle, size: 10)),
                        childCount: 50,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Menu extends ConsumerWidget {
  const Menu({super.key, required this.text, required this.icon, this.backgroundColor = Colors.white, this.textColor = const Color(0xFFcd2a2f)});
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        height: 50,
        decoration: ShapeDecoration(
          // gradient: LinearGradient(colors: [Color(0xFFb81d22), color], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          color: backgroundColor,

          shadows: [BoxShadow(color: Colors.grey.withAlpha(50), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, 0))],
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: Colors.white),
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              SizedBox(width: 4),
              Text(text, style: TextStyle(color: textColor)),
              // Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
