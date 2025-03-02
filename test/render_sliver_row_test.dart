import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_row/render_sliver_row.dart';

void main() {
  test('Assert is triggered when children size exceeds available width', () {
    final sizes = [
      const SliverRowSize(size: 100.0),
      const SliverRowSize(size: 200.0),
    ];
    final renderSliverRow = RenderSliverRow(sizes: sizes);
    final child1 = RenderSliverFillRemaining();
    final child2 = RenderSliverFillRemaining();

    renderSliverRow.addAll([child1, child2]);

    const constraints = SliverConstraints(
      axisDirection: AxisDirection.down,
      growthDirection: GrowthDirection.forward,
      userScrollDirection: ScrollDirection.idle,
      scrollOffset: 0.0,
      remainingPaintExtent: 1000.0,
      crossAxisExtent: 200.0,
      crossAxisDirection: AxisDirection.right,
      viewportMainAxisExtent: 500.0,
      remainingCacheExtent: 0.0,
      overlap: 0.0,
      precedingScrollExtent: 1000,
      cacheOrigin: 0.0,
    );

    dynamic capturedError;
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      capturedError = details.exception;
      FlutterError.onError = originalOnError;
    };

    renderSliverRow.layout(constraints, parentUsesSize: false);

    expect(capturedError, isAssertionError);
    expect(
      capturedError?.message,
      contains(
        'Total size of SliverRow children (300.0) exceeds the available width (200.0).',
      ),
    );
  });
}
