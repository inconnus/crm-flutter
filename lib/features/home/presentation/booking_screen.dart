import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const BookingScreen({super.key, required this.scrollController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            SizedBox(height: 5),
            Text(
              'สาขาไกล้เคียง',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                return const BranchCard();
              },
            ),
            SizedBox(height: 5),
            Text(
              'สาขาอื่นๆ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return const BranchCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BranchCard extends ConsumerWidget {
  const BranchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                'https://lh3.googleusercontent.com/gps-cs-s/AHVAweorHJUKkSDCC07rgz7XE1pSHgFfBgVOibNlt0Jxk7InjT8HpUJygtff8oKeWaWuVCJGTnyaQIVoCblHKMNtQ0Xfql-A-m7Yos4I9sBOHwqqiF7zYkwz1cyz11Q2nq5gUq_bpLD7=s1360-w1360-h1020-rw',
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFcd2a2f),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  child: Text('10.00 - 20.00 น.', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  'https://play-lh.googleusercontent.com/at4uqM-VXW08x4x2yit_KEo-I06_jcirhP1E1UZdkk9YPsqPrGhKXsXFKuGqn6sKV0g=w240-h480-rw',
                  width: 100,
                  fit: BoxFit.cover,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Icon(Icons.location_on, color: Color(0xFFcd2a2f), size: 18),
                            Text('สาขา เซ็นทรัลพระราม 9', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Text('123 ถนนพระราม 9'),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '124',
                                style: TextStyle(color: Color(0xFFcd2a2f)),
                              ),
                              TextSpan(
                                text: ' คิว',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(text: 'ประมาณ '),
                              TextSpan(
                                text: '10',
                                style: TextStyle(color: Color(0xFFcd2a2f), fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' นาที'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 42,
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: Icon(Icons.directions, color: Color(0xFF4285f4)),
                      ),
                      Text('0.9 กม.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0, color: Colors.grey[200]),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFcd2a2f),
                    foregroundColor: Colors.white,
                    side: BorderSide.none,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Container(color: Colors.white)));
                  },
                  icon: Icon(Icons.location_on),
                  label: Text('ไปตอนนี้'),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFFcd2a2f),
                    side: BorderSide.none,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month_rounded),
                  label: Text('จองล่วงหน้า'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
