import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/images/header.png', height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -30),
              child: CarouselSlider(
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
            ),
          ),
          SliverList.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text("รายการที่ ${index + 1}"),
                subtitle: const Text("รายละเอียดเนื้อหาด้านล่าง Header"),
                trailing: const Icon(Icons.chevron_right),
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
