import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:provider/provider.dart';

class ChildTile extends StatefulWidget {
  final int idx;
  final Child childIndex;
  ChildTile({this.childIndex, this.idx});

  @override
  _ChildTileState createState() => _ChildTileState();
}

class _ChildTileState extends State<ChildTile> {
  int _currentIndex = 0;
  List<Color> colors = [
    primaryColor,
    Colors.black
  ];
  List<IconData> icons = [
    Icons.check_box,
    Icons.check_box_outline_blank,
  ];
  ChildProvider _childProvider;

  @override
  Widget build(BuildContext context) {
    _childProvider = Provider.of<ChildProvider>(context);
    Color color = _childProvider.selectedChild.uid == widget.childIndex.uid ? colors[0] : colors[1];
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(
        widget.childIndex.name,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      trailing: Icon(
        _childProvider.selectedChild.uid == widget.childIndex.uid ? icons[0] : icons[1],
        color: color,
      ),
      onTap: () {
        setState((){
          _childProvider.updateCurrentChild(child: widget.childIndex);
          _currentIndex = widget.idx;
        });
      },
    );
  }
}
