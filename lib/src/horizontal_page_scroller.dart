import 'package:flutter/material.dart';

class HorizontalPageScroller extends StatefulWidget {
  const HorizontalPageScroller(
      {super.key,
      required this.height,
      required this.widgetWidth,
      this.defaultBarColor = const Color.fromARGB(255, 163, 163, 163),
      this.selectedBarColor = const Color.fromARGB(255, 239, 239, 239),
      this.backgroundRailColor = const Color.fromARGB(255, 122, 122, 122),
      this.backgroundRailBorderRadius = 5,
      this.barBorderRadius = 5,
      required this.numOfItems,
      this.initialSelectedItemIndex = 0,
      this.barChild,
      this.minBarWidth = 30,
      this.barChildPadding = const EdgeInsets.all(0),
      this.onTap,
      this.onParentPageChanged,
      this.pageController,
      this.scrollerMoveDuration = const Duration(milliseconds: 100)})
      : assert(initialSelectedItemIndex <= numOfItems - 1,
            'initialSelectedItemIndex must be less than numOfItems'),
        assert(numOfItems > 1, 'numOfItems must be greater than 1');

  /// define widget height
  final double height;

  /// define widget width. basically, this widget's scroll bar follows
  /// the touch point within this width range
  final double widgetWidth;

  /// define scroll bar color
  final Color defaultBarColor;

  /// define scroll bar color when it's selected
  final Color selectedBarColor;

  /// define background rail color
  final Color backgroundRailColor;

  /// define background rail border radius
  final double backgroundRailBorderRadius;

  /// define bar border radius
  final double barBorderRadius;

  /// define number of items
  final int numOfItems;

  /// define initial selected item index
  final int initialSelectedItemIndex;

  /// define bar child. if this is not null, this widget will be shown instead of the default bar
  final Widget? barChild;

  /// define minimum bar width. bar width will not be less than this value.
  final double minBarWidth;

  /// define bar child padding. this padding is applied whether barChild is null or not
  final EdgeInsets barChildPadding;

  /// a function should be called when the scroll bar is tapped.
  final Function(int)? onTap;

  /// a function should be called when parent page is changed
  final Function()? onParentPageChanged;

  /// define page controller from parent widget
  final PageController? pageController;

  /// duration of scroll bar movemnet animation.
  /// this may act as a latency when manipulating the scrollbar directly.
  final Duration scrollerMoveDuration;

  @override
  State<HorizontalPageScroller> createState() => _HorizontalPageScrollerState();
}

class _HorizontalPageScrollerState extends State<HorizontalPageScroller> {
  @override
  void initState() {
    super.initState();
    widget.pageController?.addListener(_parentPageChangeHandler);
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_parentPageChangeHandler);
    super.dispose();
  }

  void _parentPageChangeHandler() {
    if (widget.pageController != null && widget.pageController?.page != null) {
      widget.onParentPageChanged?.call();
      setState(() {
        _scrollBarPositionFraction =
            _findFractionOfIndex(widget.pageController!.page!.round());
      });
    }
  }

  void widgetRebuild(int index) {
    widget.onTap != null
        ? widget.onTap!(index)
        : widget.pageController?.jumpToPage(index);
    setState(() {});
  }

  int _findIndex(double dx) =>
      ((dx / widget.widgetWidth) * (widget.numOfItems - 1)).round();

  double _findFractionOfIndex(int index) => index / (widget.numOfItems - 1);

  late double _scrollBarPositionFraction =
      widget.initialSelectedItemIndex / (widget.numOfItems - 1);

  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.widgetWidth,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              if (!_isDragging) _isDragging = true;

              _scrollBarPositionFraction =
                  details.localPosition.dx / widget.widgetWidth;

              if (_scrollBarPositionFraction < 0) {
                _scrollBarPositionFraction = 0;
              } else if (_scrollBarPositionFraction > 1) {
                _scrollBarPositionFraction = 1;
              }
              widgetRebuild(_findIndex(details.localPosition.dx));
            },
            onHorizontalDragEnd: (details) {
              _isDragging = false;
              _scrollBarPositionFraction =
                  _findFractionOfIndex(_findIndex(details.localPosition.dx));
              widgetRebuild(_findIndex(details.localPosition.dx));
            },
            onTapDown: (details) {
              _scrollBarPositionFraction =
                  _findFractionOfIndex(_findIndex(details.localPosition.dx));
              widgetRebuild(_findIndex(details.localPosition.dx));
            },
            child: Container(
              height: widget.height,
              width: widget.widgetWidth < widget.minBarWidth
                  ? widget.minBarWidth
                  : widget.widgetWidth,
              decoration: BoxDecoration(
                color: widget.backgroundRailColor,
                borderRadius:
                    BorderRadius.circular(widget.backgroundRailBorderRadius),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: AnimatedAlign(
              duration: widget.scrollerMoveDuration,
              // _isDragging ? Duration.zero : widget.scrollerMoveDuration,
              alignment: Alignment(-1 + 2 * _scrollBarPositionFraction, 0),
              child: Padding(
                padding: widget.barChildPadding,
                child: widget.barChild ??
                    Container(
                        decoration: BoxDecoration(
                          color: _isDragging
                              ? widget.selectedBarColor
                              : widget.defaultBarColor,
                          borderRadius:
                              BorderRadius.circular(widget.barBorderRadius),
                        ),
                        width: (widget.widgetWidth / widget.numOfItems) <
                                widget.minBarWidth
                            ? widget.minBarWidth
                            : widget.widgetWidth / widget.numOfItems),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
