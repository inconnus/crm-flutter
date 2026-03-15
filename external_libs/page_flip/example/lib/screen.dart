import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageFlipController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageFlipWidget(
        controller: _controller,
        backgroundColor: Colors.yellow,
        initialIndex: 0,
        // isRightSwipe: true,
        lastPage: Container(
            color: Colors.white,
            child: const Center(child: Text('Last Page!'))),
        imageUrls: <String>[
          for (var i = 0; i < 10; i++) 'https://dummyimage.com/600x400/000/fff&text=Page+$i',
        ],
        onPageFlipped: (pageNumber) {
          debugPrint('onPageFlipped: (pageNumber) $pageNumber');
        },
        onFlipStart: () {
          debugPrint('onFlipStart');
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.looks_5_outlined),
        onPressed: () {
          _controller.goToPage(5);
        },
      ),
    );
  }
}
