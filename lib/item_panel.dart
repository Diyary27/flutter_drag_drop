import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drag_drop/my_draggable_widget.dart';
import 'package:flutter_drag_drop/types.dart';

class ItemPanel extends StatelessWidget {
  ItemPanel({
    super.key,
    required this.onDragStart,
    required this.dragStart,
    required this.dropPreview,
    required this.hoveringData,
    required this.panel,
    required this.crossAxisCount,
    required this.spacing,
    required this.items,
  });

  final Function(PanelLocation) onDragStart;
  PanelLocation? dragStart;
  PanelLocation? dropPreview;
  final String? hoveringData;
  final Panel panel;
  final int crossAxisCount;
  final double spacing;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    PanelLocation? dragStartCopy;
    final itemsCopy = List<String>.from(items);
    PanelLocation? dropPreviewCopy;

    if (dragStart != null) {
      dragStartCopy = dragStart!.copyWith();
    }

    // prevent hover over in the far corner of a drop region
    if (dropPreview != null && hoveringData != null) {
      dropPreviewCopy = dropPreview!.copyWith(
        index: min(items.length, dropPreview!.$1),
      );

      if (dragStartCopy?.$2 == dropPreviewCopy.$2) {
        itemsCopy.removeAt(dragStartCopy!.$1);
        dragStartCopy = null;
      }

      itemsCopy.insert(
        min(dropPreview!.$1, itemsCopy.length),
        hoveringData!,
      );
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      padding: EdgeInsets.all(4),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children:
          // use itemscopy instead of items
          itemsCopy.asMap().entries.map<Widget>((MapEntry<int, String> entry) {
        Color textColor =
            entry.key == dragStartCopy?.$1 || entry.key == dropPreviewCopy?.$1
                ? Colors.grey
                : Colors.white;
        Widget child = Center(
          child: Text(
            entry.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 36, color: textColor),
          ),
        );

        if (entry.key == dragStartCopy?.$1) {
          child = Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: child,
          );
        } else if (entry.key == dropPreviewCopy?.$1) {
          child = DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(20),
            dashPattern: [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: child,
          );
        } else {
          child = Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: child,
          );
        }

        return Draggable(
          feedback: child,
          child: MyDraggableWidget(
            data: entry.value,
            onDragStart: () => onDragStart((entry.key, panel)),
            child: child,
          ),
        );
      }).toList(),
    );
  }
}
