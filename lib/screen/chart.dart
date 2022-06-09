import 'package:flutter/material.dart';
import 'package:maxbonus_index/api/api.dart';
import 'package:maxbonus_index/layout/common_layout.dart';
import 'package:maxbonus_index/layout/modal_bottom_sheet_layout.dart';
import 'package:maxbonus_index/models/user_factor.dart';
import 'package:maxbonus_index/sections/chart_section.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  Key _key = const Key('');
  late List<UserFactor> _list = [];
  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = false;
  }

  requestApi() async {
    API().userFactorsApi(context).then((result) => {
          setState(() {
            _list = result;
            _loading = false;
          }),
          _renderShowModal()
        });
  }

  Future<void> _changeVisibleApi(index, bool? value, changeState) async {
    _list[index].isVisible = value!;
    _loading = true;
    API().userUpdateFactorApi(context, _list[index]).then((result) => {
          if (!result)
            {
              changeState(() {
                _list[index].isVisible = !value;
              })
            },
          setState(() {
            _loading = false;
          }),
        });
    _pullRefresh();
  }

  Future<void> _pullRefresh() async {
    setState(() {
      _key = Key(DateTime.now().millisecondsSinceEpoch.toString());
    });
  }

  _renderShowModal() {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return ModalBottomSheetLayout(
                heightFactor: 0.5,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Показывать',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Scrollbar(
                            child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: _list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 240,
                                child: Text(
                                  _list[index].factorName,
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Checkbox(
                                  value: _list[index].isVisible,
                                  onChanged: (bool? value) {
                                    _loading
                                        ? null
                                        : setState(() {
                                            _changeVisibleApi(
                                                index, value, setState);
                                          });
                                  })
                            ]);
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ))),
                  ],
                ));
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromARGB(255, 250, 102, 28),
                  Color.fromARGB(248, 255, 68, 0)
                ]),
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Основные показатели'),
        actions: [
          IconButton(
            icon: _loading
                ? const SizedBox(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3),
                    width: 20,
                    height: 20,
                  )
                : const Icon(Icons.edit),
            tooltip: 'Управление видимостью показателей',
            onPressed: () {
              _loading
                  ? null
                  : setState(() {
                      _loading = true;
                      requestApi();
                    });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SafeArea(
            child: CommonLayout(
              content: ChartSection(key: _key),
            ),
          )),
    );
  }
}
