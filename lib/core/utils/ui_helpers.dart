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
      return DraggableScrollableSheet(
        initialChildSize: 0.95, // เปิดมาครั้งแรกสูง 50% ของจอ
        minChildSize: 0, // ลากลงต่ำสุดได้ 30%
        maxChildSize: 0.95, // ลากขึ้นสูงสุดได้เกือบเต็มจอ (95%)
        expand: false,
        snap: true,
        snapSizes: [0],
        snapAnimationDuration: const Duration(milliseconds: 150),
        builder: (context, scrollController) {
          return Container(
            decoration: const ShapeDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(60))),
            ),
            child: Column(
              children: [
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
                Expanded(child: builder(context, scrollController)),
                // 1. ส่วนแถบสำหรับลาก (Grabber)
                // _buildHandle(),

                // 2. ส่วนเนื้อหาที่ Scroll ได้
                // Expanded(
                //   child: ListView.separated(
                //     // *** สำคัญที่สุด: ต้องใส่ controller นี้ ***
                //     controller: scrollController,
                //     itemCount: 50,
                //     separatorBuilder: (context, index) => const Divider(),
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         leading: CircleAvatar(child: Text('${index + 1}')),
                //         title: Text('ข้อมูลแถวที่ ${index + 1}'),
                //         subtitle: const Text('ลองไถขึ้นลงเพื่อดูการทำงาน'),
                //         onTap: () => print('Tabbed on $index'),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          );
        },
      );
    },
  );
}
