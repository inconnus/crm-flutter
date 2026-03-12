import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const double itemWidth = 90;
const Color color = Color(0xFFcd2a2f);

class NavigationBarContainer extends ConsumerWidget {
  const NavigationBarContainer({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = navigationShell.currentIndex;

    return Align(
      alignment: AlignmentGeometry.bottomCenter,
      child: Padding(
        padding: EdgeInsetsGeometry.all(33),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), spreadRadius: 0, blurRadius: 20, offset: const Offset(0, 0))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(200),
                  border: Border.all(
                    color: Colors.white.withAlpha(255), // เส้นขอบบางๆ แบบกระจก
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(3),
                  child: Stack(
                    children: [
                      // Positioned(
                      //   left: 0,
                      //   top: 0,
                      //   bottom: 0,
                      //   child: Container(
                      //     width: 102,
                      //     decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
                      //   ),
                      // ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.fastOutSlowIn,
                        left: currentIndex * itemWidth,
                        top: 0,
                        bottom: 0,
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(currentIndex),
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: itemWidth,
                                decoration: BoxDecoration(color: const Color.fromARGB(28, 70, 70, 70), borderRadius: BorderRadius.circular(40)),
                              ),
                            );
                          },
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: currentIndex.toDouble()),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                        builder: (context, smoothIndex, child) {
                          return ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (Rect bounds) {
                              // 2. นำค่า smoothIndex (ที่เป็นทศนิยม) มาคำนวณตำแหน่งหน้ากาก
                              double start = (smoothIndex * itemWidth) / bounds.width;
                              double end = ((smoothIndex + 1) * itemWidth) / bounds.width;

                              return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0xFF373737), Color(0xFF373737), color, color, Color(0xFF373737), Color(0xFF373737)],
                                stops: [0.0, start, start, end, end, 1.0],
                              ).createShader(bounds);
                            },
                            // 3. ใส่ Row ของปุ่มไว้ที่นี่
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTab(0, Icons.home_rounded, 'หน้าแรก'),
                                _buildTab(1, Icons.map_rounded, 'สาขา'),
                                _buildTab(2, Icons.person_rounded, 'โปรไฟล์'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => navigationShell.goBranch(index), // สั่งเปลี่ยนหน้า
      behavior: HitTestBehavior.opaque,
      child: TabButton(title: label, icon: icon),
    );
  }
}

class TabButton extends ConsumerWidget {
  const TabButton({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: itemWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Color(0xFF373737)),
            Text(title, style: TextStyle(fontSize: 13, color: Color(0xFF373737))),
          ],
        ),
      ),
    );
  }
}
