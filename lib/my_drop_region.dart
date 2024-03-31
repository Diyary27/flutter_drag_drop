import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_drag_drop/types.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyDropRegion extends StatefulWidget {
  MyDropRegion({
    super.key,
    required this.childSize,
    required this.columns,
    required this.panel,
    required this.onDrop,
    required this.setExternalData,
    required this.updateDropPreview,
    required this.child,
  });

  final Size childSize;
  final int columns;
  final Panel panel;
  final VoidCallback onDrop;
  final void Function(String) setExternalData;
  final void Function(PanelLocation) updateDropPreview;
  final Widget child;

  @override
  State<MyDropRegion> createState() => _MyDropRegionState();
}

class _MyDropRegionState extends State<MyDropRegion> {
  int? dropIndex;

  void _updatePreview(Offset hoverPosition) {
    final int row = hoverPosition.dy ~/ widget.childSize.height;
    final int column = (hoverPosition.dx - (widget.childSize.width / 2)) ~/
        widget.childSize.width;
    final int newDropIndex = (row * widget.columns) + column;

    if (newDropIndex != dropIndex) {
      dropIndex = newDropIndex;
      widget.updateDropPreview((dropIndex!, widget.panel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: Formats.standardFormats,
      onDropOver: (DropOverEvent event) {
        _updatePreview(event.position.local);
        return DropOperation.copy;
      },
      onPerformDrop: (PerformDropEvent event) async {
        widget.onDrop();
      },
      onDropEnter: (DropEvent event) {
        if (event.session.items.first.dataReader != null) {
          final dataReader = event.session.items.first.dataReader!;
          if (!dataReader.canProvide(Formats.plainTextFile)) {
            return;
          }
          dataReader.getFile(
            Formats.plainTextFile,
            (value) async =>
                widget.setExternalData(utf8.decode(await value.readAll())),
          );
        }
      },
      child: widget.child,
    );
  }
}
