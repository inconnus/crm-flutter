import 'package:flutter/material.dart';

Future<void> showCustomModalBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder, String? title}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
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
                    child: Text(title ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).pop()),
                  ),
                ],
              ),
            ),

          // 2. วิธีแก้: ถ้า content เป็น FractionallySizedBox ให้ครอบด้วย Flexible
          // เพื่อให้มันคำนวณความสูงจากพื้นที่หน้าจอที่เหลือได้
          Flexible(child: content),
        ],
      );
    },
  );
}
