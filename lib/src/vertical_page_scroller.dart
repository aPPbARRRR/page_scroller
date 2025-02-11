import 'package:flutter/material.dart';

class VerticalPageScroller extends StatefulWidget {
  const VerticalPageScroller(
      {super.key,
      required this.width,
      required this.widgetHeight,
      this.defaultBarColor = const Color.fromARGB(255, 163, 163, 163),
      this.selectedBarColor = const Color.fromARGB(255, 239, 239, 239),
      this.backgroundRailColor = const Color.fromARGB(255, 122, 122, 122),
      this.backgroundRailBorderRadius = 5,
      this.barBorderRadius = 5,
      required this.numOfItems,
      this.initialSelectedItemIndex = 0,
      this.barChild,
      this.minBarHeight = 30,
      this.barChildPadding = const EdgeInsets.all(0),
      this.onTap,
      this.onParentPageChanged,
      this.pageController,
      this.scrollerMoveDuration = const Duration(milliseconds: 100)})
      : assert(initialSelectedItemIndex <= numOfItems - 1,
            'initialSelectedItemIndex must be less than numOfItems'),
        assert(numOfItems > 1, 'numOfItems must be greater than 1');

  final double width;
  final double widgetHeight;
  final Color defaultBarColor;
  final Color selectedBarColor;
  final Color backgroundRailColor;
  final double backgroundRailBorderRadius;
  final double barBorderRadius;
  final int numOfItems;
  final int initialSelectedItemIndex;
  final Widget? barChild;
  final double minBarHeight;
  final EdgeInsets barChildPadding;
  final Function(int)? onTap;
  final Function()? onParentPageChanged;
  final PageController? pageController;
  final Duration scrollerMoveDuration;

  @override
  State<VerticalPageScroller> createState() => _VerticalPageScrollerState();
}

class _VerticalPageScrollerState extends State<VerticalPageScroller> {
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

  int _findIndex(double dy) =>
      ((dy / widget.widgetHeight) * (widget.numOfItems - 1)).round();

  double _findFractionOfIndex(int index) => index / (widget.numOfItems - 1);

  late double _scrollBarPositionFraction =
      widget.initialSelectedItemIndex / (widget.numOfItems - 1);

  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.widgetHeight,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) {
              if (!_isDragging) _isDragging = true;

              _scrollBarPositionFraction =
                  details.localPosition.dy / widget.widgetHeight;

              if (_scrollBarPositionFraction < 0) {
                _scrollBarPositionFraction = 0;
              } else if (_scrollBarPositionFraction > 1) {
                _scrollBarPositionFraction = 1;
              }
              widgetRebuild(_findIndex(details.localPosition.dy));
            },
            onVerticalDragEnd: (details) {
              _isDragging = false;
              _scrollBarPositionFraction =
                  _findFractionOfIndex(_findIndex(details.localPosition.dy));
              widgetRebuild(_findIndex(details.localPosition.dy));
            },
            onTapDown: (details) {
              _scrollBarPositionFraction =
                  _findFractionOfIndex(_findIndex(details.localPosition.dy));
              widgetRebuild(_findIndex(details.localPosition.dy));
            },
            child: Container(
              width: widget.width,
              height: widget.widgetHeight < widget.minBarHeight
                  ? widget.minBarHeight
                  : widget.widgetHeight,
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
              alignment: Alignment(0, -1 + 2 * _scrollBarPositionFraction),
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
                        height: (widget.widgetHeight / widget.numOfItems) <
                                widget.minBarHeight
                            ? widget.minBarHeight
                            : widget.widgetHeight / widget.numOfItems),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
