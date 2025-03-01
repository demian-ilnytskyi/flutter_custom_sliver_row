import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sliver_row/sliver_row.dart';

void main() {
  const widget1Key = Key('widget_1_key');
  const widget2Key = Key('widget_2_key');
  const widget3Key = Key('widget_3_key');
  const widget4Key = Key('widget_4_key');
  const screenSize = Size(1840, 1024);
  // Helper function to initialize the test environment
  Future<void> initTest({
    required WidgetTester tester,
    required Widget sliver,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [sliver],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.binding.setSurfaceSize(screenSize);

    await tester.pumpAndSettle();
  }

  testWidgets('Sliver Row Init Test', (tester) async {
    await initTest(
      tester: tester,
      sliver: SliverRow(
        chilrden: const [
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_1',
                  key: widget1Key,
                ),
              ),
            ),
          ),
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_2',
                  key: widget2Key,
                ),
              ),
            ),
          ),
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_3',
                  key: widget3Key,
                ),
              ),
            ),
          ),
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_4',
                  key: widget4Key,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    expect(find.byKey(widget1Key), findsOneWidget);

    expect(find.byKey(widget2Key), findsOneWidget);

    expect(find.byKey(widget3Key), findsOneWidget);

    expect(find.byKey(widget4Key), findsOneWidget);

    final center1 = tester.getCenter(find.byKey(widget1Key));

    final center2 = tester.getCenter(find.byKey(widget2Key));

    final center3 = tester.getCenter(find.byKey(widget3Key));

    final center4 = tester.getCenter(find.byKey(widget4Key));

    final screenPlace = screenSize.width / 4;
    final center = screenPlace / 2;

    // Verify that the Text widget is centered
    expect(center1.dx, center);

    expect(center2.dx, (screenPlace * 2) - center);

    expect(center3.dx, (screenPlace * 3) - center);

    expect(center4.dx, (screenPlace * 4) - center);
  });

  testWidgets('Sliver Row When Set Size And Percent', (tester) async {
    await initTest(
      tester: tester,
      sliver: SliverRow(
        chilrden: const [
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_1',
                  key: widget1Key,
                ),
              ),
            ),
            size: 200,
          ),
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  'test_2',
                  key: widget2Key,
                ),
              ),
            ),
            percent: 1 / 3,
          ),
        ],
      ),
    );

    expect(find.byKey(widget1Key), findsOneWidget);

    expect(find.byKey(widget2Key), findsOneWidget);

    final center1 = tester.getCenter(find.byKey(widget1Key));
    final center2 = tester.getCenter(find.byKey(widget2Key));

    // Verify that the Text widget is centered
    expect(center1.dx, 100);

    expect(
      center2.dx.toStringAsFixed(2),
      ((screenSize.width / 6) + 200).toStringAsFixed(2),
    );
  });

  testWidgets('Sliver Row Tap Pressed', (tester) async {
    var value1 = false;
    var value2 = false;
    await initTest(
      tester: tester,
      sliver: SliverRow(
        chilrden: [
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => value1 = true,
                  child: const Text(
                    'test_1',
                    key: widget1Key,
                  ),
                ),
              ),
            ),
            size: 200,
          ),
          SliverRowModel(
            child: SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => value2 = true,
                  child: const Text(
                    'test_2',
                    key: widget2Key,
                  ),
                ),
              ),
            ),
            percent: 1 / 3,
          ),
        ],
      ),
    );

    expect(value1, isFalse);

    expect(value2, isFalse);

    expect(find.byKey(widget1Key), findsOneWidget);

    expect(find.byKey(widget2Key), findsOneWidget);

    await tester.tap(find.byKey(widget1Key));

    await tester.pumpAndSettle();

    expect(value1, isTrue);

    expect(value2, isFalse);

    await tester.tap(find.byKey(widget2Key));

    await tester.pumpAndSettle();

    expect(value1, isTrue);

    expect(value2, isTrue);

    value1 = false;
    value2 = false;

    expect(value1, isFalse);

    expect(value2, isFalse);

    final center1 = tester.getCenter(find.byKey(widget1Key));
    final center2 = tester.getCenter(find.byKey(widget2Key));

    await tester.tapAt(center1);

    await tester.pumpAndSettle();

    expect(value1, isTrue);

    expect(value2, isFalse);

    await tester.tapAt(center2);

    await tester.pumpAndSettle();

    expect(value1, isTrue);

    expect(value2, isTrue);
  });

  testWidgets('Sliver Row Update Item Size', (tester) async {
    final value = ValueNotifier<double>(200);
    await initTest(
      tester: tester,
      sliver: ValueListenableBuilder<double>(
        valueListenable: value,
        builder: (BuildContext context, double value, child) {
          return SliverRow(
            chilrden: [
              SliverRowModel(
                child: const SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'test_1',
                      key: widget1Key,
                    ),
                  ),
                ),
                size: value,
              ),
              const SliverRowModel(
                child: SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'test_2',
                      key: widget2Key,
                    ),
                  ),
                ),
                percent: 1 / 3,
              ),
            ],
          );
        },
      ),
    );

    expect(find.byKey(widget1Key), findsOneWidget);

    expect(find.byKey(widget2Key), findsOneWidget);

    final center1 = tester.getCenter(find.byKey(widget1Key));
    final center2 = tester.getCenter(find.byKey(widget2Key));

    // Verify that the Text widget is centered
    expect(center1.dx, 100);

    expect(
      center2.dx.toStringAsFixed(2),
      ((screenSize.width / 6) + 200).toStringAsFixed(2),
    );

    value.value = 400;

    await tester.pumpAndSettle();

    expect(find.byKey(widget1Key), findsOneWidget);

    expect(find.byKey(widget2Key), findsOneWidget);

    final center1Again = tester.getCenter(find.byKey(widget1Key));
    final center2Again = tester.getCenter(find.byKey(widget2Key));

    // Verify that the Text widget is centered
    expect(center1Again.dx, 200);

    expect(
      center2Again.dx.toStringAsFixed(2),
      ((screenSize.width / 6) + 400).toStringAsFixed(2),
    );
  });

  testWidgets('Sliver Row empty children', (tester) async {
    await initTest(
      tester: tester,
      sliver: SliverRow(
        chilrden: const [],
      ),
    );

    expect(find.byKey(widget1Key), findsNothing);

    expect(find.byKey(widget2Key), findsNothing);

    expect(find.byKey(widget3Key), findsNothing);

    expect(find.byKey(widget4Key), findsNothing);
  });
}
