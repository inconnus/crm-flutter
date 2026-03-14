import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_flip/page_flip.dart';
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
                            Menu(
                              text: 'จองคิว',
                              icon: Icons.calendar_month_outlined,
                              backgroundColor: Color(0xFFcd2a2f),
                              textColor: Colors.white,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  backgroundColor: Colors.white,
                                  //
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(40))),
                                  sheetAnimationStyle: AnimationStyle(duration: const Duration(milliseconds: 150)),
                                  builder: (BuildContext builderContext) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: PageFlipWidget(
                                            backgroundColor: Colors.white,
                                            children: <Widget>[
                                              for (var i = 0; i < 10; i++)
                                                Center(
                                                  child: Image.network(
                                                    'https://instagram.fbkk28-1.fna.fbcdn.net/v/t39.30808-6/574349151_1509917023421438_7129930871877634104_n.jpg?stp=dst-jpg_e35_tt6&_nc_cat=102&ig_cache_key=Mzc1NDU0NjI0MzAyOTU0OTQzOA%3D%3D.3-ccb7-5&ccb=7-5&_nc_sid=58cdad&efg=eyJ2ZW5jb2RlX3RhZyI6InhwaWRzLjEwODB4MTM1MC5zZHIuQzMifQ%3D%3D&_nc_ohc=ekEIaJAQZ8kQ7kNvwFweoO3&_nc_oc=AdnutaOp2m9x8l27lyl_2nRU9VkkoUZNmsZEuO96ArCwwLcOoXt0STKyKr8_b9Ag7Rc&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=instagram.fbkk28-1.fna&_nc_gid=xkAaybHlz66x_yvipaQ7cw&_nc_ss=8&oh=00_AfxU6EuH8jAWgFhBY9aKKbx99u3IOm3W2TQIa6Ekyadhbg&oe=69BB1F89',
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            Menu(text: 'ประวัติ', icon: Icons.history_rounded),
                            Menu(text: 'รางวัล', icon: Icons.wallet_giftcard_rounded),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('โปรโมชัน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFFcd2a2f))),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 140,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 10,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: AssetImage('assets/images/s1.jpg'), fit: BoxFit.cover),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('สินค้าแนะนำ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFFcd2a2f))),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              physics: const NeverScrollableScrollPhysics(), // Add this
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20, // Recommended for a cleaner grid
                                mainAxisSpacing: 20,
                              ),
                              itemCount: 10, // Don't forget to set an item count!
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage('https://sushiro.co.th/wp-content/uploads/2025/10/new-gm-1920x1080-px.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
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
  const Menu({
    super.key,
    required this.text,
    required this.icon,
    this.backgroundColor = Colors.white,
    this.textColor = const Color(0xFFcd2a2f),
    this.onTap,
  });
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
