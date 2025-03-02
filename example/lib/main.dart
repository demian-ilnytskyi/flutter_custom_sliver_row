import 'package:flutter/material.dart';
import 'package:custom_sliver_row/custom_sliver_row.dart';

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
            children: [
              SliverRowModel(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text('example_$index'),
                      ),
                    ),
                  ),
                ),
                percent: 0.3,
              ),
              SliverRowModel(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text('example_$index'),
                      ),
                    ),
                  ),
                ),
              ),
              SliverRowModel(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Text('example_$index'),
                      ),
                    ),
                  ),
                ),
                percent: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
