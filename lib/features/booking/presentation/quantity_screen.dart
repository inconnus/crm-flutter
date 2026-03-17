import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityScreen extends ConsumerStatefulWidget {
  const QuantityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuantityScreenState();
}

class _QuantityScreenState extends ConsumerState<QuantityScreen> {
  String type = 'A';
  int quantity = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          backgroundColor: Color(0xFFcd2a2f),
          foregroundColor: Colors.white,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: SafeArea(child: Text('จองคิว', style: TextStyle(fontSize: 16))),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ประเภทการจอง', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  spacing: 10,
                  children: [
                    TypeButton(
                      isActive: type == 'A',
                      label: '1-2 ท่าน',
                      onPressed: () {
                        setState(() {
                          type = 'A';
                          quantity = 2;
                        });
                      },
                    ),
                    TypeButton(
                      isActive: type == 'B',
                      label: '3-4 ท่าน',
                      onPressed: () {
                        setState(() {
                          type = 'B';
                          quantity = 4;
                        });
                      },
                    ),
                    TypeButton(
                      isActive: type == 'C',
                      label: '5-6 ท่าน',
                      onPressed: () {
                        setState(() {
                          type = 'C';
                          quantity = 5;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('จำนวนผู้ใช้บริการ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Center(
                  child: QuantityButton(
                    quantity: quantity,
                    onSubtract: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                    onAdd: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ),
                Text('หมายเหตุ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFFcd2a2f)),
                    ),
                    hintText: 'ระบุหมายเหตุ (ถ้ามี)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'การจัดโต๊ะ: ทางร้านขอสงวนสิทธิ์ในการจัดตำแหน่งโต๊ะตามความเหมาะสมของจำนวนแขกและคิวการจอง\n\nคำขอพิเศษ: สำหรับการจัดวันเกิด หรือแพ้อาหาร (Allergy) กรุณาระบุในช่อง "หมายเหตุ" ขณะทำการจอง',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

class QuantityButton extends ConsumerStatefulWidget {
  const QuantityButton({super.key, required this.quantity, required this.onSubtract, required this.onAdd});
  final int quantity;
  final Function() onSubtract;
  final Function() onAdd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends ConsumerState<QuantityButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.all(10),
            style: IconButton.styleFrom(backgroundColor: Color(0xFFcd2a2f)),

            onPressed: () {
              widget.onSubtract();
            },
            icon: Icon(Icons.remove, color: Colors.white),
          ),
          SizedBox(
            width: 55,
            child: Center(
              child: Text(widget.quantity.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(10),
            style: IconButton.styleFrom(backgroundColor: Color(0xFFcd2a2f)),
            onPressed: () {
              widget.onAdd();
            },
            icon: Icon(Icons.add_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
