import 'package:crm/features/booking/presentation/widgets/quantity_button.dart';
import 'package:crm/features/booking/presentation/widgets/type_button.dart';
import 'package:crm/widgets/title_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

final Map<DateTime, List<dynamic>> _events = {
  DateTime(2026, 3, 20): ['available'],
  DateTime(2026, 3, 21): ['full'],
};

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<DateTime> _generateTimeSlots() {
    List<DateTime> slots = [];
    DateTime start = DateTime(2026, 1, 1, 10, 0); // เริ่ม 08:00
    DateTime end = DateTime(2026, 1, 1, 20, 45); // จบ 20:00

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      slots.add(start);
      start = start.add(const Duration(minutes: 15)); // เพิ่มทีละ 15 นาที
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
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
              // Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: SafeArea(child: Text('สำรองที่นั่ง', style: TextStyle(fontSize: 16))),
        ),
        body: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
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
                  title: 'เลือกวันที่',
                  content: FormBuilderField<DateTime?>(
                    name: 'date',
                    // initialValue: DateTime.now(),
                    valueTransformer: (value) {
                      return value?.microsecondsSinceEpoch;
                    },
                    builder: (field) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                        ),
                        child: TableCalendar(
                          locale: 'th_TH',
                          availableGestures: AvailableGestures.none,
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(color: Color(0xFFcd2a2f).withValues(alpha: 0.3), shape: BoxShape.circle),
                            selectedDecoration: BoxDecoration(color: Color(0xFFcd2a2f), shape: BoxShape.circle),
                            weekendTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                            markerDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          ),
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                final status = events.first;
                                return Center(
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 25),
                                    width: 7,
                                    height: 7,
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: status == 'full' ? Colors.red : Colors.green),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                          headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                          eventLoader: (day) {
                            // ล้างค่า time ให้เหลือแค่ วัน/เดือน/ปี ก่อนไปหาใน Map
                            final normalizedDay = DateTime(day.year, day.month, day.day);
                            return _events[normalizedDay] ?? []; // คืนค่าเป็น List ว่างถ้าไม่เจอ
                          },
                          onDaySelected: (day, _) {
                            field.didChange(day);
                          },
                          selectedDayPredicate: (day) => isSameDay(field.value, day),
                          firstDay: DateTime.now(),
                          lastDay: DateTime(2027, 1, 31),
                          focusedDay: DateTime.now(),
                        ),
                      );
                    },
                  ),
                ),
                TitleContent(
                  title: 'ช่วงเวลา',
                  content: FormBuilderField(
                    name: 'time',
                    builder: (field) {
                      return _formKey.currentState?.fields['date']?.value == null
                          ? const Center(
                              child: Text('กรุณาเลือกวันที่', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            )
                          : FormBuilderField<DateTime>(
                              name: 'selected_time',
                              builder: (FormFieldState<DateTime?> field) {
                                final slots = _generateTimeSlots();

                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
                                  ),
                                  child: GridView.builder(
                                    shrinkWrap: true, // สำคัญ: เพื่อให้อยู่ใน Column ได้
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // 4 ปุ่มต่อแถว
                                      childAspectRatio: 2.3, // ปรับความแบนของปุ่ม
                                      crossAxisSpacing: 8, // ระยะห่างแนวนอน
                                      mainAxisSpacing: 8, // ระยะห่างแนวตั้ง
                                    ),
                                    itemCount: slots.length,
                                    itemBuilder: (context, index) {
                                      final time = slots[index];
                                      final isSelected = field.value == time; // เช็คว่าเลือกปุ่มนี้อยู่ไหม

                                      return ChoiceChip(
                                        // --- จุดสำคัญอยู่ตรงนี้ ---
                                        showCheckmark: false, // 1. เอาเครื่องหมายถูกออก
                                        label: Center(
                                          // 2. ใช้ Center ครอบเพื่อให้ข้อความอยู่กลางปุ่ม
                                          child: Text(
                                            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black,
                                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        selected: isSelected,
                                        selectedColor: Color(0xFFcd2a2f), // สีตอนเลือก
                                        backgroundColor: Colors.white, // สีตอนปกติ
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        side: BorderSide(color: Colors.grey[300]!),
                                        padding: EdgeInsets.zero, // ลดพื้นที่ว่างภายใน
                                        labelPadding: EdgeInsets.zero, // ลดพื้นที่ว่างรอบข้อความ
                                        onSelected: (bool selected) {
                                          field.didChange(selected ? time : null);
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                    },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
