import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A model that describes a row in a Sliver layout.
///
/// You can specify the size of the [child] in two ways:
/// 1. [percent] — a fraction of the available width (must be > 0 and < 1).
/// 2. [size] — a fixed width in pixels.
///
/// You must provide exactly one of these parameters (either [percent] or [size]) but not both.
class SliverRowModel {
  /// Creates a model with the given [child] and its size.
  ///
  /// - [child] is required.
  /// - [percent] — if provided, it must be greater than 0 and less than 1.
  /// - [size] — if provided, it is a fixed width in pixels.
  ///
  /// **Note:** You must not provide both [percent] and [size].
  const SliverRowModel({
    required this.child,
    this.percent,
    this.size,
  }) : assert(
          // If 'percent' is not null, it must be > 0 and < 1.
          percent == null || (percent > 0 && percent < 1),
          'percent must be greater than 0 and less than 1 if it is provided.',
        );

  /// The widget to be displayed in this row.
  final Widget child;

  /// The fraction of the available width occupied by [child].
  /// Must be > 0 and < 1 if used.
  final double? percent;

  /// The fixed width of [child], in pixels.
  final double? size;
}

class SliverRow extends MultiChildRenderObjectWidget {
  // Constructor for the SliverRow widget
  SliverRow({
    required this.chilrden,
    Key? key,
  }) : super(
            key: key,
            children: List.generate(
              chilrden.length,
              (index) => chilrden.elementAt(index).child,
            ));

  final List<SliverRowModel> chilrden; // Left widget to display

  // Creates the render object for this widget
  @override
  RenderSliverRow createRenderObject(BuildContext context) {
    return RenderSliverRow(
        sizes: List.generate(
      chilrden.length,
      (index) {
        final item = chilrden.elementAt(index);
        return _SliverRowSize(percent: item.percent, size: item.size);
      },
    ));
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverRow renderObject) {}
}

class _SliverRowSize {
  /// Creates a model with the given [child] and its size.
  ///
  /// - [child] is required.
  /// - [percent] — if provided, it must be greater than 0 and less than 1.
  /// - [size] — if provided, it is a fixed width in pixels.
  ///
  /// **Note:** You must not provide both [percent] and [size].
  const _SliverRowSize({
    this.percent,
    this.size,
  }) : assert(
          // If 'percent' is not null, it must be > 0 and < 1.
          percent == null || (percent > 0 && percent < 1),
          'percent must be greater than 0 and less than 1 if it is provided.',
        );

  /// The fraction of the available width occupied by [child].
  /// Must be > 0 and < 1 if used.
  final double? percent;

  /// The fixed width of [child], in pixels.
  final double? size;
}

class _ChildSliverState {
  const _ChildSliverState({
    required this.sliver,
    required this.size,
  });

  final RenderSliver sliver;

  final double? size;
}

// Extension to get custom parent data for SliverRow
extension _RowSliderParentDataExt on RenderSliver {
  _SliverRowParentData get sliverRow => parentData! as _SliverRowParentData;
}

// Custom parent data class to hold additional data for each sliver child
class _SliverRowParentData extends SliverPhysicalParentData
    with ContainerParentDataMixin<RenderSliver> {}

class RenderSliverRow extends RenderSliver
    with ContainerRenderObjectMixin<RenderSliver, _SliverRowParentData> {
  // Constructor to initialize the width percentage for the left widget
  RenderSliverRow({required List<_SliverRowSize> sizes}) : _sizes = sizes;

  final List<_SliverRowSize> _sizes;

  List<_ChildSliverState> childrenState = const [];

  // Sets up the parent data for the sliver children
  @override
  void setupParentData(RenderSliver child) {
    if (child.parentData is! _SliverRowParentData) {
      child.parentData = _SliverRowParentData();
    }
  }

  // Perform layout calculations for the sliver children
  @override
  void performLayout() {
    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    // Calculate the size for the left child based on the width percentage
    // final leftSize = constraints.crossAxisExtent * _leftWidthPercent;
    // final remainingWidth = constraints.crossAxisExtent - leftSize;

    if (firstChild != null) {
      final childsState = _childsState;
      double currentSliverGetScreenWidth = 0;

      for (var childState in childsState) {
        childState.sliver.layout(
          constraints.copyWith(crossAxisExtent: childState.size),
          parentUsesSize: true,
        );

        final parentData = childState.sliver.parentData;

        if (parentData is _SliverRowParentData) {
          parentData.paintOffset = Offset(
            currentSliverGetScreenWidth,
            0,
          );
        }

        currentSliverGetScreenWidth += childState.size ?? 0;
      }
      final paintExtent =
          min(constraints.remainingPaintExtent, currentSliverGetScreenWidth);

      geometry = SliverGeometry(
        scrollExtent: currentSliverGetScreenWidth,
        paintExtent: paintExtent,
        layoutExtent: paintExtent,
        maxPaintExtent: currentSliverGetScreenWidth,
        cacheExtent: currentSliverGetScreenWidth,
      );
      childrenState = childsState;
    }
  }

  // Paint the children to the canvas
  @override
  void paint(PaintingContext context, Offset offset) {
    if (!(geometry?.visible ?? false)) return;

    // Paint the left child first, then the right child with a horizontal offset
    // final leftParentData = left.parentData! as _SliverRowParentData;
    // final rightParentData = right.parentData! as _SliverRowParentData;

    if (firstChild != null) {
      RenderSliver? currentSliver = firstChild!;

      for (var i = 0; i < childCount; i++) {
        if (currentSliver == null) break;
        final parentData = currentSliver.parentData;
        if (parentData is _SliverRowParentData) {
          context.paintChild(currentSliver, offset + parentData.paintOffset);
        }

        currentSliver = childAfter(currentSliver);
      }

      // context
      //   ..paintChild(left, offset + leftParentData.paintOffset)
      //   ..paintChild(right, offset + rightParentData.paintOffset);
    }
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    double currentSliverGetScreenWidth = 0;
    for (final child in childrenState) {
      if (child.sliver.geometry?.visible ?? false) {
        final adjustedCrossAxisPosition =
            crossAxisPosition - currentSliverGetScreenWidth;

        // Now check if the touch is inside the child
        if (child.sliver.hitTest(
          result,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: adjustedCrossAxisPosition,
        )) {
          return true;
        }
        currentSliverGetScreenWidth += child.size ?? 0;
      }
    }
    return false;
  }

  // Apply the paint transform for the child slivers
  @override
  void applyPaintTransform(RenderSliver child, Matrix4 transform) =>
      child.sliverRow.applyPaintTransform(transform);

  List<_ChildSliverState> get _childsState {
    final childsState = <_ChildSliverState>[];
    RenderSliver? currentSliver = firstChild;
    final fullAvailableWidth = constraints.crossAxisExtent;

    for (var i = 0; i < childCount; i++) {
      if (currentSliver == null) break;
      final double? size;
      final sizeState = _sizes.elementAt(i);
      if (sizeState.percent != null) {
        size = fullAvailableWidth * sizeState.percent!;
      } else if (sizeState.size != null) {
        size = sizeState.size!;
      } else {
        size = null;
      }
      childsState.add(_ChildSliverState(sliver: currentSliver, size: size));
      currentSliver = childAfter(currentSliver);
    }
    double itemsSize = 0;
    final sizeZeroList = [];
    for (var childState in childsState) {
      if (childState.size != null) {
        itemsSize += childState.size!;
      } else {
        sizeZeroList.add(childState);
      }
    }
    if (sizeZeroList.isNotEmpty) {
      final availableSize = fullAvailableWidth - itemsSize;
      final elemntLength = sizeZeroList.length;
      for (var i = 0; i < elemntLength; i++) {
        final item = sizeZeroList.elementAt(i);
        final index = childsState.indexOf(item);
        childsState.removeAt(index);
        final newChildState = _ChildSliverState(
          sliver: item.sliver,
          size: availableSize / elemntLength,
        );
        childsState.insert(index, newChildState);
      }
    }
    return childsState;
  }
}
