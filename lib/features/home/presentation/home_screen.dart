import 'package:carousel_slider/carousel_slider.dart';
import 'package:crm/core/utils/ui_helpers.dart';
import 'package:crm/features/booking/presentation/booking_screen.dart';
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
                            height: 5,
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
                              backgroundImage: NetworkImage('https://kkndpqqmsswhgnupsznq.supabase.co/storage/v1/object/public/Public/256.webp'),
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
                                showCustomModalBottomSheetFull(
                                  context: context,
                                  title: 'จองคิว',
                                  builder: (BuildContext builderContext, ScrollController scrollController) =>
                                      BookingScreen(scrollController: scrollController),
                                );
                              },
                            ),
                            Menu(
                              text: 'สั่งอาหาร',
                              icon: Icons.food_bank_outlined,
                              onTap: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  title: 'เมนูอาหาร',
                                  builder: (BuildContext builderContext) {
                                    return PageFlipWidget(
                                      backgroundColor: Colors.white,
                                      imageUrls: [
                                        'https://kkndpqqmsswhgnupsznq.supabase.co/storage/v1/object/public/Public/n1.webp',
                                        'http://www.normalsteak.in/i/n2.png',
                                        'http://www.normalsteak.in/i/n3.png',
                                        'http://www.normalsteak.in/i/n4.png',
                                        'http://www.normalsteak.in/i/n5.png',
                                        'http://www.normalsteak.in/i/n6.png',
                                        'http://www.normalsteak.in/i/n7.png',
                                        'http://www.normalsteak.in/i/n8.png',
                                        'http://www.normalsteak.in/i/n9.png',
                                        'http://www.normalsteak.in/i/n10.png',
                                        'http://www.normalsteak.in/i/n11.png',
                                        'http://www.normalsteak.in/i/n12.png',
                                        'http://www.normalsteak.in/i/n13.png',
                                        'http://www.normalsteak.in/i/n14.png',
                                        'http://www.normalsteak.in/i/n15.png',
                                        'http://www.normalsteak.in/i/n16.png',
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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
                                return GestureDetector(
                                  onTap: () {
                                    showCustomModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return FractionallySizedBox(
                                          heightFactor: 0.95,
                                          child: Scaffold(
                                            body: Column(
                                              children: [
                                                Hero(
                                                  tag: 'image$index',
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(0),
                                                    child: Image.asset('assets/images/s1.jpg', fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 140,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      children: [
                                        Hero(
                                          tag: 'image$index',
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Image.asset('assets/images/s1.jpg', height: 140, fit: BoxFit.cover),
                                          ),
                                        ),
                                      ],
                                    ),
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
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(50), // สีเงาและความโปร่งใส
              blurRadius: 10, // ความฟุ้ง (ยิ่งเยอะยิ่งนุ่ม)
              offset: const Offset(0, 0), // <--- ตรงนี้คือ Offset (เลื่อนลงล่าง 5 หน่วย)
            ),
          ],
        ),
        child: TextButton.icon(
          onPressed: () {
            onTap?.call();
          },
          icon: Icon(icon, color: textColor, size: 22),
          label: Text(text),
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
            minimumSize: const Size(0, 50),
          ),
        ),
      ),
    );
  }
}
