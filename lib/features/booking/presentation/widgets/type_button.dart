import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TypeButton extends ConsumerWidget {
  const TypeButton({super.key, required this.isActive, required this.label, required this.onPressed});
  final bool isActive;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50), // สีเงาและความโปร่งใส
            blurRadius: 10, // ความฟุ้ง (ยิ่งเยอะยิ่งนุ่ม)
            offset: const Offset(0, 0), // <--- ตรงนี้คือ Offset (เลื่อนลงล่าง 5 หน่วย)
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: isActive ? Color(0xFFcd2a2f) : Colors.white,
          shadowColor: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // สำคัญ: ให้ Column กินพื้นที่เท่าที่จำเป็น
          children: [
            Icon(Icons.table_restaurant, size: 28, color: isActive ? Colors.white : Color(0xFFcd2a2f)),
            const SizedBox(height: 5), // ระยะห่างระหว่างไอคอนกับตัวหนังสือ
            Text(label, style: TextStyle(fontSize: 14, color: isActive ? Colors.white : Color(0xFFcd2a2f))),
          ],
        ),
      ),
    );
  }
}
