import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomNavBar extends StatefulWidget {
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final Curve curve;

  BottomNavBar({
    Key? key,
    this.showElevation = true,
    this.iconSize = 28,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.containerHeight = 74,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  }) {
    assert(items.length >= 2 && items.length <= 5);
  }

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final bgColor = (widget.backgroundColor == null) ? Theme.of(context).bottomAppBarColor : widget.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          if (widget.showElevation)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
            ),
        ],
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: widget.containerHeight,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            children: widget.items.map((item) {
              var index = widget.items.indexOf(item);
              return GestureDetector(
                onTap: () {
                  widget.onItemSelected(index);
                  _currentTab = index;
                  setState(() {});
                },
                child: _ItemWidget(
                  item: item,
                  iconSize: widget.iconSize,
                  isSelected: index == _currentTab,
                  backgroundColor: bgColor!,
                  itemCornerRadius: widget.itemCornerRadius,
                  animationDuration: widget.animationDuration,
                  curve: widget.curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.itemCornerRadius,
    required this.iconSize,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isSelected ? 166 : 76,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      decoration: BoxDecoration(
        color: isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
        borderRadius: BorderRadius.circular(itemCornerRadius),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          width: isSelected ? 166 : 76,
          padding: EdgeInsets.symmetric(horizontal: 20),
          // alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: isSelected
                      ? item.activeColor.withOpacity(1)
                      : item.inactiveColor == null
                          ? item.activeColor
                          : item.inactiveColor,
                ),
                child: item.icon,
              ),
              if (isSelected)
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        color: item.activeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      textAlign: item.textAlign,
                      child: item.title,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavBarItem {
  final Icon icon;
  final Text title;
  final Color activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;

  BottomNavBarItem({
    required this.icon,
    required this.title,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
  });
}
