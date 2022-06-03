import 'package:maxbonus_index/models/button.dart';
import 'package:flutter/material.dart';

class GroupButtonVertical extends StatefulWidget {
  final String type;
  final int activeButton;
  final Function updateState;

  const GroupButtonVertical(
      {Key? key,
      required this.type,
      required this.updateState,
      required this.activeButton})
      : super(key: key);

  @override
  State<GroupButtonVertical> createState() => _GroupButtonVerticalState();
}

class _GroupButtonVerticalState extends State<GroupButtonVertical> {
  late List _buttons = [];
  late int _selectedIndex = widget.activeButton;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'periodUnit') {
      _buttons = [
        {"index": 1, "name": "Дни", "disable": false, "position": "left"},
        {"index": 2, "name": "Недели", "disable": false},
        {"index": 3, "name": "Месяцы", "disable": false, "position": "right"}
      ];
    } else {
      _buttons = [
        {"index": 1, "name": "Динамика", "disable": false, "position": "left"},
        {"index": 2, "name": "Детали", "disable": true, "position": "right"},
      ];
    }
  }

  refresh(button) {
    setState(() {
      _selectedIndex = Button.fromJson(button).index;
    });
    widget.updateState(_selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Wrap(direction: Axis.horizontal, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var button in _buttons)
              SizedBox(
                  width: 300 / _buttons.length,
                  child: ElevatedButton(
                    child: Text(
                      Button.fromJson(button).name,
                      style: TextStyle(
                          color: _selectedIndex == Button.fromJson(button).index
                              ? Theme.of(context).primaryColor
                              : const Color.fromARGB(137, 7, 4, 4),
                          fontSize: (16),
                          fontWeight: FontWeight.w100),
                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: _selectedIndex == Button.fromJson(button).index
                            ? const Color.fromARGB(255, 255, 244, 232)
                            : Theme.of(context).dialogBackgroundColor,
                        shadowColor: Theme.of(context).dialogBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              Button.fromJson(button).position == 'left'
                                  ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      topLeft: Radius.circular(8))
                                  : Button.fromJson(button).position == 'right'
                                      ? const BorderRadius.only(
                                          bottomRight: Radius.circular(8),
                                          topRight: Radius.circular(8))
                                      : BorderRadius.zero,
                        ),
                        side: BorderSide(
                            width: 0,
                            color: Theme.of(context).dialogBackgroundColor)),
                    onPressed: Button.fromJson(button).disable ?? false
                        ? null
                        : () => refresh(button),
                  )),
          ],
        ),
      ]),
    ));
  }
}
