<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# page_scroller

A Flutter widget package that provides customizable scrolling functionality designed specifically for page-based widgets like PageView.

- Horizontal and vertical scroll bars that can be optionally synced with PageViewController
- Customizable bar colors, sizes, border radius, etc.
- Support for custom bar widgets
- Smooth animation with adjustable duration
- Interactive scroll bar that responds to touch/drag
- Works with existing PageController instances

<p float="left">
  <img src="https://raw.githubusercontent.com/aPPbARRRR/page_scroller/main/example/demo.gif" width="45%" />
  <img src="https://raw.githubusercontent.com/aPPbARRRR/page_scroller/main/example/demo_2.gif" width="45%" />
</p>

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  page_scroller: ^0.0.1
```

## Usage

Here's a basic example using both horizontal and vertical scrollers:

```dart
Stack(
  children: [
    PageView.builder(
      itemCount: 5,
      controller: pageController,
      itemBuilder: (context, index) => Center(
        child: Text('Page $index'),
      ),
    ),
    VerticalPageScroller(
      numOfItems: 5,
      width: 20,
      widgetHeight: MediaQuery.of(context).size.height,
      pageController: pageController,
    ),
    Positioned(
      bottom: 30,
      right: 0,
      child: HorizontalPageScroller(
        height: 30,
        widgetWidth: MediaQuery.of(context).size.width - 100,
        numOfItems: 5,
        pageController: pageController,
      ),
    ),
  ],
)
```

### Customization

Both scrollers support various customization options:

```dart
HorizontalPageScroller(
  height: 30,
  widgetWidth: 300,
  numOfItems: 5,
  defaultBarColor: Colors.grey,
  selectedBarColor: Colors.white,
  backgroundRailColor: Colors.black54,
  backgroundRailBorderRadius: 5,
  barBorderRadius: 5,
  initialSelectedItemIndex: 0,
  barChild: YourCustomWidget(), // Optional custom bar widget
  minBarWidth: 30,
  barChildPadding: EdgeInsets.all(4),
  scrollerMoveDuration: Duration(milliseconds: 100),
  onTap: (index) => print('Tapped index: $index'),
  onParentPageChanged: () => print('Page changed'),
  pageController: pageController,
)
```

## Additional information

- Package homepage: https://github.com/aPPbARRRR/page_scroller
- Bug reports and feature requests are welcome in the [issue tracker](https://github.com/aPPbARRRR/page_scroller/issues)
- For detailed API documentation, visit the [API reference](https://pub.dev/documentation/page_scroller/latest/)
