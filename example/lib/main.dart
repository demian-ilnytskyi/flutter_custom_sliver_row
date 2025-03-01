import 'package:flutter/material.dart';
import 'package:sliver_row/sliver_row.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sliver Row Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverRow(
            chilrden: [
              const SliverRowModel(
                child: SliverFillRemaining(
                  child: Center(
                    child: Text('test 1'),
                  ),
                ),
                size: 200,
              ),
              const SliverRowModel(
                child: SliverFillRemaining(
                  child: Center(
                    child: Text('test 2'),
                  ),
                ),
              ),
              SliverRowModel(
                child: SliverFillRemaining(
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'test 3',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
