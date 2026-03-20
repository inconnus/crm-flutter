import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
