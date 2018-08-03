# flutter_index_widget

## screenshot

![img](https://github.com/CaiJingLong/some_asset/blob/master/index_widget1.gif)

![custom index](https://github.com/CaiJingLong/some_asset/blob/master/index_widget2.gif)

## use

### add pubspec.yaml

```yaml
dependencies:
  flutter_index_widget: ^0.1.0
```

### import library

```dart
import 'package:flutter_index_widget/flutter_index_widget.dart';
```

### use widget

#### default

```dart
    Widget widget = IndexWidget(
        width: 25.0,
        indexTouchChange: (int index) {
            setState(() {
                _text = defaultEntries[index].text; //get the entry and text
            });
        },
        indexTouchStateChange: (bool down) {
            setState(() {
                if (down) {
                    _state = "touch down";
                } else {
                    _state = "touch up";
                }
            });
        },
    ),
```

#### custom index text

```dart
  List<IndexEntry> list = [];

  @override
  void initState() {
    super.initState();
    for (var i = 10; i >= 0; i--) {
      list.add(IndexEntry(text: "$i", desc: i.toString()));
    }
  }

   Container(
        child: IndexWidget(
        entries: list,
        width: 25.0,
        indexTouchChange: (int index) {
            setState(() {
                _index = index;
                _text = list[index].text;
            });
        },
        indexTouchStateChange: (bool down) {
                setState(() {
                    if (down) {
                        _state = "touch down";
                    } else {
                        _state = "touch up";
                    }
                });
            },
        ),
    ),  
```
