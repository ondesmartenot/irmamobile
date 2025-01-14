// This code is not null safe yet.
// @dart=2.11

import 'package:flutter/material.dart';
import 'package:irmamobile/src/theme/theme.dart';
import 'package:irmamobile/src/widgets/irma_markdown.dart';

class ProgressingListItem {
  final String header;
  final String subheader;
  final String text;
  final bool completed;

  ProgressingListItem({
    @required this.header,
    this.subheader,
    @required this.text,
    this.completed = false,
  });
}

class ProgressingList extends StatelessWidget {
  final List<ProgressingListItem> data;
  final bool completed;

  const ProgressingList({Key key, this.data, this.completed = false}) : super(key: key);

  Color _color(BuildContext context, {bool active, bool completed}) {
    if (active) return IrmaTheme.of(context).primaryBlue;
    if (completed) return IrmaTheme.of(context).interactionCompleted;
    return IrmaTheme.of(context).grayscale60;
  }

  List<Widget> _buildItem(
    BuildContext context,
    ProgressingListItem item, {
    bool last,
    bool active,
    bool completed,
  }) {
    return <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: active ? 0 : 10),
            child: Container(
              width: active ? 50 : 30,
              height: active ? 50 : 30,
              child: CircleAvatar(
                backgroundColor: _color(context, active: active, completed: completed),
                child: completed ? const Icon(Icons.check, size: 20, color: Colors.white) : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.header,
                    style: active ? Theme.of(context).textTheme.headline3 : Theme.of(context).textTheme.bodyText2),
                if (item.subheader != null) Text(item.subheader, style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 23,
          vertical: 4,
        ),
        child: Container(
          decoration: last
              ? null
              : BoxDecoration(
                  border: Border(left: BorderSide(width: 4.0, color: IrmaTheme.of(context).grayscale85)),
                ),
          child: Padding(
            padding: EdgeInsets.only(left: last ? 52 : 48, bottom: IrmaTheme.of(context).defaultSpacing),
            child: active ? IrmaMarkdown(item.text) : Container(height: 5),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activeItem = data.indexWhere((item) => !item.completed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data
          .asMap()
          .entries
          .map((item) => _buildItem(
                context,
                item.value,
                last: item.key == data.length - 1,
                active: !completed && item.key == activeItem,
                completed: completed || item.value.completed,
              ))
          .expand((i) => i)
          .toList(),
    );
  }
}
