import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

class MyDraggableWidget extends StatelessWidget {
  MyDraggableWidget({
    super.key,
    required this.child,
    required this.data,
    required this.onDragStart,
  });

  final Widget child;
  final String data;
  final Function() onDragStart;

  @override
  Widget build(BuildContext context) {
    return DragItemWidget(
      dragItemProvider: (DragItemRequest request) {
        // first way (suitable for in app)
        onDragStart();
        final item = DragItem(localData: data);

        // second way (readers)
        // for serializing and deserilizing
        // onDragStart does the work for us

        // item.add(Formats.plainText(data));

        return item;
      },
      dragBuilder: (context, child) => Opacity(opacity: 0.8, child: child),
      allowedOperations: () => [DropOperation.copy],
      child: DraggableWidget(child: child),
    );
  }
}
