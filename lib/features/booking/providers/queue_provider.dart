import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'queue_provider.g.dart';

@riverpod
class Queue extends _$Queue {
  @override
  Stream<List<Map<String, dynamic>>> build() {
    final supabase = Supabase.instance.client;
    return supabase.from('que').stream(primaryKey: ['id']).order('created_at'); // (Optional) เรียงลำดับข้อมูล
  }

  Future<void> add(Map<String, dynamic> data) async {
    final supabase = Supabase.instance.client;
    await supabase.from('que').insert({'status': 'ACTIVE', 'tenant': 'sushiya'});
    state = AsyncData(await supabase.from('que').select());
  }
}
