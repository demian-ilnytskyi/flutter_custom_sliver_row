# SliverRow
<p align="center">
  <a href="https://pub.dev/packages/custom_sliver_row"><img src="https://img.shields.io/pub/v/custom_sliver_row" alt="pub"></a>
  <a href="https://app.codecov.io/github/DemienIlnutskiy/flutter_custom_sliver_row"><img src="https://img.shields.io/codecov/c/github/DemienIlnutskiy/flutter_custom_sliver_row" alt="pub"></a>
  <a href="https://github.com/DemienIlnutskiy/flutter_custom_sliver_row/actions/workflows/generate_code_coverate.yaml"><img src="https://img.shields.io/github/actions/workflow/status/DemienIlnutskiy/flutter_custom_sliver_row/generate_code_coverate.yaml?event=push&branch=main&label=tests&logo=github" alt="tests"></a>
  <a href="https://github.com/DemienIlnutskiy/flutter_custom_sliver_row/actions/workflows/ci.yaml">
    <img src="https://img.shields.io/github/actions/workflow/status/DemienIlnutskiy/flutter_custom_sliver_row/ci.yaml?event=pull_request&label=Code%20Analysis%20%26%20Formatting&logo=github" 
        alt="Code Analysis & Formatting">
  </a>
</p>

## Important Compatibility & Performance Notice

This package replaces Flutter's official SliverCrossAxisGroup widget.

**Compatibility:**

*   SliverCrossAxisGroup (Flutter 3.10+) is unavailable in earlier Flutter versions.
*   SliverRow offers a viable alternative for older versions.

**Performance:**

*   SliverRow provides similar layout capabilities but is less performant than SliverCrossAxisGroup.

**Recommendation:**

*   For Flutter 3.10+, use the optimized and secure official SliverCrossAxisGroup widget.

## Preview

<a href="https://github.com/DemienIlnutskiy/flutter_custom_sliver_row/blob/main/assets/read_me/preview.gif">
  <img src="https://raw.githubusercontent.com/DemienIlnutskiy/flutter_custom_sliver_row/main/assets/read_me/preview.gif" alt="preview">
</a>

## Overview

`SliverRow` is a custom Flutter widget that arranges its children in a horizontal row within a `CustomScrollView`. It allows you to specify the size of each child either as a fixed width or as a fraction of the available width.

## Features

- Arrange children in a horizontal row within a `CustomScrollView`.
- Specify child sizes using fixed widths or percentages.
- Supports dynamic updates to child sizes.


## Test Coverage and Flutter Version Support

This package has 100% test coverage, ensuring reliability and robustness. The tests have been executed on Flutter versions 2.0.0 and 3.29.0, confirming full support for these versions and all versions in between.

## Example For SliverCrossAxisGroup

```dart
SliverCrossAxisGroup(
  children: [
    SliverCrossAxisExpanded(
      flex: 1
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
    ),
    SliverCrossAxisExpanded(
      flex: 2
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
  ]
),
```

## Code

```dart
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
```