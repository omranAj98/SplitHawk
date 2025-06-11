import 'package:flutter/material.dart';
import 'package:splithawk/src/core/constants/app_size.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback addExpenseCallback;
  final VoidCallback editCallback;
  final ColorScheme colorScheme;

  const SwipeableCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.addExpenseCallback,
    required this.editCallback,
    required this.colorScheme,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0.0;
  final double _actionThreshold = 60.0;
  bool _showLeftAction = false;
  bool _showRightAction = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _showLeftAction = false;
    _showRightAction = false;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;

      // Show action buttons when threshold is reached
      if (_dragExtent > _actionThreshold) {
        _showLeftAction = true;
      } else if (_dragExtent < -_actionThreshold) {
        _showRightAction = true;
      } else {
        _showRightAction = false;
        _showLeftAction = false;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // Handle action if swipe was far enough
    if (_showLeftAction) {
      widget.addExpenseCallback();
    } else if (_showRightAction) {
      widget.editCallback();
    }

    // Reset position
    setState(() {
      _dragExtent = 0.0;
      _showLeftAction = false;
      _showRightAction = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onTap: _dragExtent == 0.0 ? widget.onTap : null,
      child: Stack(
        children: [
          // Action buttons layer
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Add expense action - shown on left swipe
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: EdgeInsets.all(AppSize.cardMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSize.borderRadiusCard,
                    ),
                    color: widget.colorScheme.primary,
                  ),
                  alignment: Alignment.centerRight,
                  child: Opacity(
                    opacity: _showLeftAction ? 1.0 : 0.0,
                    child: Icon(
                      Icons.add_circle_outline,
                      color: widget.colorScheme.onPrimary,
                    ),
                  ),
                ),
                // settle up action - shown on right swipe
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.all(AppSize.cardMargin),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppSize.borderRadiusCard,
                    ),
                    color: widget.colorScheme.secondary,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Opacity(
                    opacity: _showRightAction ? 1.0 : 0.0,
                    child: Icon(
                      Icons.priority_high_sharp,
                      color: widget.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card layer - moves with swipe
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: Card(
              child: InkWell(onTap: widget.onTap, child: widget.child),
            ),
          ),
        ],
      ),
    );
  }
}
