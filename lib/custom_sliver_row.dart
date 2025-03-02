import 'package:flutter/widgets.dart';
import 'package:custom_sliver_row/render_sliver_row.dart';

/// A model that describes a row in a Sliver layout.
///
/// You can specify the size of the [child] in one of two ways:
/// 1. [percent] — a fraction of the available width (must be > 0 and < 1).
/// 2. [size] — a fixed width in pixels.
///
/// **Note:** You may provide either a [percent] value or a [size] value,
/// but not both at the same time.
class SliverRowModel {
  /// Creates a model with the given [child] and its size configuration.
  const SliverRowModel({
    required this.child,
    this.percent,
    this.size,
  })  : assert(
          // If 'percent' is provided, it must be greater than 0 and
          //  less than 1.
          percent == null || (percent > 0 && percent < 1),
          'percent must be greater than 0 and less than 1 if it is provided.',
        ),
        assert(
          // Ensure that both 'percent' and 'size' are not provided at the same
          // time.
          !(percent != null && size != null),
          'You cannot provide both percent and size at the same time.',
        );

  /// The widget to be displayed in this row.
  final Widget child;

  /// The fraction of the available width occupied by [child] if used.
  final double? percent;

  /// The fixed width of [child] in pixels if used.
  final double? size;
}

/// A custom sliver widget that arranges its children in a row.
///
/// It uses a list of [SliverRowModel]s to extract the children
/// and their associated size configuration. It then passes the
/// size information to the custom render object [RenderSliverRow].
class SliverRow extends MultiChildRenderObjectWidget {
  /// Creates a [SliverRow] widget.
  ///
  /// The [children] parameter is a list of [SliverRowModel] objects.
  /// Each model contains the child widget and its size configuration.
  ///
  /// The constructor generates a list of child widgets for the superclass
  /// by mapping over the provided [children] list.
  SliverRow({
    required List<SliverRowModel> children,
    Key? key,
  })  : _children = children,
        super(
          key: key,
          children: List.generate(
            children.length,
            (index) => children.elementAt(index).child,
          ),
        );

  /// The list of SliverRowModels, each describing a child widget and its size.
  final List<SliverRowModel> _children;

  /// Creates the custom render object for this sliver.
  ///
  /// It converts the list of [SliverRowModel] objects into a list of
  /// [SliverRowSize] objects, which encapsulate the size configuration,
  /// and passes them to the render object.
  @override
  RenderSliverRow createRenderObject(BuildContext context) {
    return RenderSliverRow(
      sizes: List.generate(
        _children.length,
        (index) {
          final item = _children.elementAt(index);
          return SliverRowSize(percent: item.percent, size: item.size);
        },
      ),
    );
  }

  /// Updates the render object when the widget is rebuilt.
  ///
  /// This method regenerates the list of sizes and marks the render object
  /// as needing layout.
  @override
  void updateRenderObject(BuildContext context, RenderSliverRow renderObject) {
    renderObject
      ..sizesValue = List.generate(
        _children.length,
        (index) {
          final item = _children.elementAt(index);
          return SliverRowSize(percent: item.percent, size: item.size);
        },
      )
      ..markNeedsLayout();
  }
}
