import 'package:flutter/material.dart';
import 'package:page_scroller/page_scroller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Example(),
    );
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final PageController _pageController = PageController();

  Widget itemBuilder(BuildContext context, int index) {
    return Center(child: Text('page $index', style: TextStyle(fontSize: 20)));
  }

  final int _itemCount = 5;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          PageView.builder(
              itemCount: _itemCount,
              controller: _pageController,
              itemBuilder: itemBuilder),
          VerticalPageScroller(
            numOfItems: _itemCount,
            width: 20,
            widgetHeight: MediaQuery.of(context).size.height,
            pageController: _pageController,
          ),
          Positioned(
              bottom: 30,
              right: 0,
              child: HorizontalPageScroller(
                  height: 30,
                  widgetWidth: MediaQuery.of(context).size.width - 100,
                  numOfItems: _itemCount,
                  pageController: _pageController))
        ],
      )),
    );
  }
}
