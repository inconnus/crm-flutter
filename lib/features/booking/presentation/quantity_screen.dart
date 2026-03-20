import 'package:crm/features/booking/presentation/widgets/quantity_button.dart';
import 'package:crm/features/booking/presentation/widgets/type_button.dart';
import 'package:crm/features/booking/providers/queue_provider.dart';
import 'package:crm/widgets/title_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityScreen extends ConsumerStatefulWidget {
  const QuantityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuantityScreenState();
}

class _QuantityScreenState extends ConsumerState<QuantityScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  String type = 'A';
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
          _formKey.currentState?.save();
          if (_formKey.currentState?.saveAndValidate() ?? false) {
            print(_formKey.currentState?.value);
            ref.read(queueProvider.notifier).add({});
            // Navigator.of(context, rootNavigator: true).pop();
          }
        },
        child: SafeArea(child: Text('จองคิว', style: TextStyle(fontSize: 16))),
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: {'type': type},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  TitleContent(
                    title: 'ประเภทการจอง',
                    content: FormBuilderField(
                      name: 'type',
                      initialValue: 'A',
                      builder: (field) {
                        return Row(
                          spacing: 10,
                          children: [
                            TypeButton(
                              isActive: field.value == 'A',
                              label: '1-2 ท่าน',
                              onPressed: () {
                                field.didChange('A');
                                _formKey.currentState?.fields['quantity']?.didChange(2);
                              },
                            ),
                            TypeButton(
                              isActive: field.value == 'B',
                              label: '3-4 ท่าน',
                              onPressed: () {
                                field.didChange('B');
                                _formKey.currentState?.fields['quantity']?.didChange(3);
                              },
                            ),
                            TypeButton(
                              isActive: field.value == 'C',
                              label: '5-6 ท่าน',
                              onPressed: () {
                                field.didChange('C');
                                _formKey.currentState?.fields['quantity']?.didChange(5);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  TitleContent(
                    title: 'จำนวนผู้ใช้บริการ',
                    content: Center(
                      child: FormBuilderField<int>(
                        name: 'quantity',
                        initialValue: 2,
                        builder: (field) {
                          return QuantityButton(
                            quantity: field.value!,
                            onSubtract: () {
                              _formKey.currentState?.fields['quantity']?.didChange(field.value! - 1);
                            },
                            onAdd: () {
                              _formKey.currentState?.fields['quantity']?.didChange(field.value! + 1);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  TitleContent(
                    title: 'หมายเหตุ',
                    content: FormBuilderTextField(
                      name: 'note',
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
                  ),
                  Text(
                    'การจัดโต๊ะ: ทางร้านขอสงวนสิทธิ์ในการจัดตำแหน่งโต๊ะตามความเหมาะสมของจำนวนแขกและคิวการจอง\n\nคำขอพิเศษ: สำหรับการจัดวันเกิด หรือแพ้อาหาร (Allergy) กรุณาระบุในช่อง "หมายเหตุ" ขณะทำการจอง',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
