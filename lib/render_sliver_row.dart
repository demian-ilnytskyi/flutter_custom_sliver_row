import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:custom_sliver_row/custom_sliver_row.dart';

/// Internal model used by [RenderSliverRow] to store the size configuration.
///
/// This is similar to [CustomSliverRowModel] but without the child widget.
class SliverRowSize {
  /// Creates an instance of [SliverRowSize] with the given size parameters.
  const SliverRowSize({
    this.percent,
    this.size,
  })  : assert(
          // If 'percent' is provided, it must be between 0 and 1.
          percent == null || (percent > 0 && percent < 1),
          'percent must be greater than 0 and less than 1 if it is provided.',
        ),
        assert(
          // Ensure that both 'percent' and 'size' are not provided
          // simultaneously.
          !(percent != null && size != null),
          'You cannot provide both percent and size at the same time.',
        );

  /// The fractional width if used.
  final double? percent;

  /// The fixed width if used.
  final double? size;
}

/// A simple class to hold the state for each child sliver,
/// pairing a [RenderSliver] with its calculated size.
class _ChildSliverState {
  const _ChildSliverState({
    required this.sliver,
    required this.size,
  });

  /// The render object for the child sliver.
  final RenderSliver sliver;

  /// The calculated size (width) for this child.
  final double? size;
}

/// Extension on RenderSliver to conveniently access the custom parent data.
extension _RowSliderParentDataExt on RenderSliver {
  _SliverRowParentData get sliverRow => parentData! as _SliverRowParentData;
}

/// Custom parent data class for [RenderSliverRow] children.
/// Extends [SliverPhysicalParentData] and mixes in [ContainerParentDataMixin]
/// to store additional layout data (such as the paint offset).
class _SliverRowParentData extends SliverPhysicalParentData
    with ContainerParentDataMixin<RenderSliver> {}

/// Custom render object for [SliverRow].
///
/// This render object performs custom layout by positioning its child
/// slivers in a horizontal row and calculating their sizes based on the
/// provided size configurations.
class RenderSliverRow extends RenderSliver
    with ContainerRenderObjectMixin<RenderSliver, _SliverRowParentData> {
  /// Constructs a [RenderSliverRow] with a list of size configurations.
  RenderSliverRow({required List<SliverRowSize> sizes}) : sizesValue = sizes;

  /// List of size configurations for each child.
  List<SliverRowSize> sizesValue;

  /// Cache for the calculated state of each child (its render object and size).
  List<_ChildSliverState>? _childrenState;

  /// Sets up the parent data for each child sliver.
  ///
  /// If the child's parent data is not an instance of [_SliverRowParentData],
  /// it assigns a new [_SliverRowParentData] instance.
  @override
  void setupParentData(RenderSliver child) {
    if (child.parentData is! _SliverRowParentData) {
      child.parentData = _SliverRowParentData();
    }
  }

  /// Performs the layout for this sliver.
  ///
  /// It computes the sizes for each child based on the provided
  /// [sizesValue] list,
  /// lays out each child with the calculated width, and then sets the overall
  /// geometry of the sliver.
  @override
  void performLayout() {
    // If there are no children, set geometry to zero and cache an empty state.
    if (firstChild == null) {
      geometry = SliverGeometry.zero;
      _childrenState = const [];
      return;
    }

    // Get the state of all children, including their calculated sizes.
    final childsState = _getChildsState();
    double currentXOffset = 0;
    double maxChildHeight = 0;

    // Layout each child sliver using the calculated size as the cross
    // axis extent.
    for (final childState in childsState) {
      childState.sliver.layout(
        // Modify constraints: set the cross axis extent to the calculated size.
        constraints.copyWith(crossAxisExtent: childState.size),
        parentUsesSize: true,
      );

      // Retrieve and update the parent's custom data with the
      // calculated offset.
      final parentData = childState.sliver.parentData;
      if (parentData is _SliverRowParentData) {
        parentData.paintOffset = Offset(currentXOffset, 0);
      }

      // Increase the offset by the child's size (or 0 if null).
      currentXOffset += childState.size ?? 0;
      maxChildHeight =
          max(maxChildHeight, childState.sliver.geometry?.paintExtent ?? 0);
    }

    // Determine the paint extent based on the available constraints.
    final paintExtent = min(constraints.remainingPaintExtent, maxChildHeight);

    // Set the geometry for this sliver so that scrolling and painting work
    // correctly.
    geometry = SliverGeometry(
      scrollExtent: maxChildHeight,
      paintExtent: paintExtent,
      layoutExtent: paintExtent,
      maxPaintExtent: maxChildHeight,
    );

    // Cache the calculated children state for use during painting
    // and hit testing.
    _childrenState = childsState;
  }

  /// Paints each child sliver onto the canvas.
  ///
  /// The method loops over the cached [_childrenState] and paints each child
  /// at the calculated offset.
  @override
  void paint(PaintingContext context, Offset offset) {
    if (!(geometry?.visible ?? false)) return;
    if (_childrenState == null) return; // No children to paint.

    double currentXOffset = 0;
    for (final childState in _childrenState!) {
      context.paintChild(childState.sliver, offset + Offset(currentXOffset, 0));
      currentXOffset += childState.size ?? 0;
    }
  }

  /// Performs hit testing for children.
  ///
  /// Iterates over the cached children state and checks whether the given
  /// main and cross axis positions hit any of the child slivers.
  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    if (_childrenState == null) return false;

    double currentXOffset = 0;
    for (final childState in _childrenState!) {
      // if (child.sliver.geometry?.visible ?? false) {
      // Adjust the cross axis position relative to the current child.
      final adjustedCrossAxisPosition = crossAxisPosition - currentXOffset;

      // Check if the hit falls within the child's area.
      if (childState.sliver.hitTest(
        result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: adjustedCrossAxisPosition,
      )) {
        return true; // Stop once a hit is detected.
      }
      currentXOffset += childState.size ?? 0;
      // }
    }
    return false;
  }

  /// Applies the paint transform from the custom parent data.
  @override
  void applyPaintTransform(RenderSliver child, Matrix4 transform) =>
      child.sliverRow.applyPaintTransform(transform);

  /// Computes the state for all child slivers.
  ///
  /// This method iterates over all children (using [firstChild]
  /// and [childAfter])
  /// and computes the size for each based on the provided [sizesValue] list.
  /// It also handles children that do not have an explicit size by evenly
  /// distributing the remaining width among them.
  List<_ChildSliverState> _getChildsState() {
    final childsState = <_ChildSliverState>[];
    var currentSliver = firstChild;
    // The full available width is given by the cross axis extent of the
    // constraints.
    final fullAvailableWidth = constraints.crossAxisExtent;

    // Sum up the sizes of children that have an explicit size.
    double itemsSize = 0;
    final sizeZeroList = <_ChildSliverState>[];

    // Iterate over all children and calculate their size.
    for (var i = 0; i < childCount; i++) {
      if (currentSliver == null) break;
      final sizeState = sizesValue.elementAt(i);
      double? size;
      if (sizeState.percent != null) {
        // Calculate size as a fraction of the full available width.
        size = fullAvailableWidth * sizeState.percent!;
      } else if (sizeState.size != null) {
        // Use the fixed size.
        size = sizeState.size;
      } else {
        // If neither is provided, leave size as null.
        size = null;
      }
      final childState = _ChildSliverState(sliver: currentSliver, size: size);
      childsState.add(childState);
      if (size == null) {
        sizeZeroList.add(childState);
      } else {
        itemsSize += size;
      }
      currentSliver = childAfter(currentSliver);
    }

    assert(
      itemsSize <= fullAvailableWidth,
      'Total size of SliverRow children ($itemsSize) exceeds the available width ($fullAvailableWidth).',
    );

    // If there are children without an explicit size, distribute the
    // remaining width evenly.
    if (sizeZeroList.isNotEmpty) {
      final availableSize = fullAvailableWidth - itemsSize;
      final elemntLength = sizeZeroList.length;
      for (var i = 0; i < elemntLength; i++) {
        final item = sizeZeroList.elementAt(i);
        // Find the index of the child in the original list.
        final index = childsState.indexOf(item);
        // Remove the existing state.
        childsState.removeAt(index);
        // Create a new state with the evenly distributed size.
        final newChildState = _ChildSliverState(
          sliver: item.sliver,
          size: availableSize / elemntLength,
        );
        // Insert the new state back at the same index.
        childsState.insert(index, newChildState);
      }
    }
    return childsState;
  }
}
