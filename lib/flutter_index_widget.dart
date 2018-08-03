library flutter_index_widget;

import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';

var defaultEntries = List<IndexEntry>.generate(26, (i) {
  String text = String.fromCharCode(65 + i);
  return new IndexEntry(text: text, desc: text);
});

typedef IndexTouchChange(int index);
typedef IndexTouchStateChange(bool down);

class IndexEntry {
  final String text;
  final String desc;

  IndexEntry({this.text, this.desc});

  @override
  bool operator ==(other) {
    return this.text == other.text;
  }

  @override
  int get hashCode {
    return text.hashCode;
  }

  @override
  String toString() {
    return 'IndexEntry{text: $text, desc: $desc}';
  }
}

class IndexWidget extends StatefulWidget {
  final double width;

  final List<IndexEntry> entries;

  final IndexTouchChange indexTouchChange;

  final IndexTouchStateChange indexTouchStateChange;

  const IndexWidget({Key key, this.width, this.entries, @required this.indexTouchChange, @required this.indexTouchStateChange}) : super(key: key);

  @override
  _IndexWidgetState createState() => new _IndexWidgetState();
}

const _kItemHeight = 22.0;

class _IndexWidgetState extends State<IndexWidget> {
  GlobalKey key;

  @override
  void initState() {
    super.initState();
    key = RectGetter.createGlobalKey();
  }

  _getPosition(double y) {
//    print("down");

    var offset = Offset(0.0, y);
    offset = (context.findRenderObject() as RenderBox).globalToLocal(offset);

    var rect = RectGetter.getRectFromKey(key);
    var realY = offset.dy;
    if (realY < 0) {
      realY = 0.0;
    }
    if (realY > rect.height) {
      realY = rect.height;
    }

//    var perHeight = rect.height / entries.length;
    var perHeight = _kItemHeight;

    var maxRealHeight = entries.length * perHeight;

    var startY = (rect.height - maxRealHeight) / 2;

//    print("realY = $realY");
//    print("startY = $startY");

    int position = ((realY - startY) / perHeight).round();

    if (position < 0) {
      position = 0;
    }
    if (position >= entries.length) {
      position = entries.length - 1;
    }

//    print(position);

    notifyTouchPosition(position);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (down) {
        _getPosition(down.position.dy);
//        print("pointerdown");
        widget.indexTouchStateChange(true);
      },
      onPointerUp: (ip) {
        widget.indexTouchStateChange(false);
      },
      onPointerMove: (update) {
//        print("onPointerMove");
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (detail) {
          _getPosition(detail.globalPosition.dy);
        },
        child: new Container(
          key: key,
          width: widget.width,
          child: new Column(
            children: _buildItems(),
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }

  notifyTouchPosition(int position) {
    if (widget.indexTouchChange != null) {
      widget.indexTouchChange(position);
    }
  }

  List<Widget> _buildItems() {
    List<Widget> children = [];

    for (int i = 0; i < 1; i++) {
      entries.forEach((e) {
        children.add(
          new Container(
            height: _kItemHeight,
            child: Center(
              child: new Text(
                e.text,
                style: new TextStyle(fontSize: 13.0, color: Colors.black),
              ),
            ),
          ),
        );
      });
    }

    return children;
  }

  List<IndexEntry> get entries => widget.entries ?? defaultEntries;
}
