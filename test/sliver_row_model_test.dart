import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_row/render_sliver_row.dart';
import 'package:sliver_row/sliver_row.dart';

void main() {
  testWidgets('Sliver Row Model', (tester) async {
    expect(
      () => const SliverRowModel(child: SliverToBoxAdapter(), percent: 1 / 3),
      isNot(throwsAssertionError),
    );

    expect(
      () => SliverRowModel(child: const SliverToBoxAdapter(), percent: 10),
      throwsAssertionError,
    );

    expect(
      () => const SliverRowModel(
        child: SliverToBoxAdapter(),
        size: 200,
      ),
      isNot(throwsAssertionError),
    );

    expect(
      () => SliverRowModel(
        child: const SliverToBoxAdapter(),
        percent: 1 / 3,
        size: 200,
      ),
      throwsAssertionError,
    );
  });

  testWidgets('Sliver Row Size', (tester) async {
    expect(
      () => const SliverRowSize(percent: 1 / 3),
      isNot(throwsAssertionError),
    );

    expect(
      () => SliverRowSize(percent: 10),
      throwsAssertionError,
    );

    expect(
      () => const SliverRowSize(
        size: 200,
      ),
      isNot(throwsAssertionError),
    );

    expect(
      () => SliverRowSize(
        percent: 1 / 3,
        size: 200,
      ),
      throwsAssertionError,
    );
  });
}
