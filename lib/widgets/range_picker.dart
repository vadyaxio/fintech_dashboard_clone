import 'package:maxbonus_index/enum/selection_period.dart';
import 'package:maxbonus_index/layout/modal_bottom_sheet_layout.dart';
import 'package:maxbonus_index/models/dropdown_period.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RangePicker extends StatefulWidget {
  final String type;
  final Map<String, DateTime?>? date;
  final Function updateDate;
  final num? dynamic;

  const RangePicker(
      {Key? key,
      required this.type,
      required this.updateDate,
      this.date,
      this.dynamic})
      : super(key: key);

  @override
  State<RangePicker> createState() => _RangePickerState();
}

class _RangePickerState extends State<RangePicker> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, DateTime?> _date = {
    "begin": null,
    "end": null,
  };

  final List<DropdownPeriod> _dropdownOptions = SelectionPeriod().getOptions();

  late DropdownPeriod? _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _date['begin'] = widget.date!['begin'];
    _date['end'] = widget.date!['end'];

    _selectedPeriod = findElementDropdownPeriod(_dropdownOptions);
  }

  findElementDropdownPeriod(List<DropdownPeriod> selectedPeriod) {
    final index = selectedPeriod.indexWhere(
      (element) =>
          DateFormat('yyyy-MM-dd').format(element.dateStart) ==
              DateFormat('yyyy-MM-dd')
                  .format(_date['begin'] ?? DateTime.now()) &&
          DateFormat('yyyy-MM-dd').format(element.dateEnd) ==
              DateFormat('yyyy-MM-dd').format(_date['end'] ?? DateTime.now()),
    );

    return index >= 0 ? selectedPeriod[index] : null;
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _date['begin'] = args.value.startDate;
      _date['end'] = args.value.endDate ?? args.value.startDate;
    }
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      widget.updateDate(_date, widget.type);
      Navigator.pop(context);
    }
  }

  void clearForm() async {
    widget.updateDate({
      "begin": null,
      "end": null,
    }, widget.type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                (widget.date!['begin'] == null && widget.date!['end'] == null)
                    ? 'Укажите период'
                    : '${DateFormat('dd.MM').format(widget.date!['begin'] ?? DateTime.now())} - ${DateFormat('dd.MM').format(widget.date!['end'] ?? DateTime.now())}',
                style: TextStyle(
                    color: widget.dynamic! == 0
                        ? Colors.black54
                        : widget.dynamic! > 0
                            ? const Color.fromARGB(255, 19, 193, 4)
                            : const Color.fromARGB(255, 255, 0, 1),
                    fontSize: (widget.date!['begin'] == null &&
                            widget.date!['end'] == null)
                        ? 10
                        : 12,
                    fontWeight: FontWeight.w100),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Icon(
                  widget.type == 'period'
                      ? Icons.calendar_month
                      : Icons.compare_arrows,
                  size: 20.0,
                  color: widget.dynamic! == 0
                      ? Colors.black54
                      : widget.dynamic! > 0
                          ? const Color.fromARGB(255, 19, 193, 4)
                          : const Color.fromARGB(255, 255, 0, 1),
                ),
              )
            ],
          ),
          style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: widget.dynamic! == 0
                  ? Theme.of(context).dialogBackgroundColor
                  : widget.dynamic! > 0
                      ? const Color.fromARGB(255, 231, 250, 212)
                      : const Color.fromARGB(255, 250, 230, 212),
              shadowColor: Theme.of(context).dialogBackgroundColor,
              side: BorderSide(
                  width: 0, color: Theme.of(context).dialogBackgroundColor)),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return ModalBottomSheetLayout(
                        heightFactor: 0.84,
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.type == 'period'
                                        ? 'Выбрать период'
                                        : 'Сравнить данные',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20))),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        31, 156, 156, 156)),
                                                child: Text(
                                                  widget.date!['begin'] != null
                                                      ? DateFormat(
                                                              'dd MMM yyyy',
                                                              Localizations
                                                                      .localeOf(
                                                                          context)
                                                                  .languageCode)
                                                          .format(widget.date![
                                                                  'begin'] ??
                                                              DateTime.now())
                                                      : 'Дата не указана',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2.5,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: const Color.fromARGB(
                                                        31, 156, 156, 156)),
                                                child: Text(
                                                  widget.date!['end'] != null
                                                      ? DateFormat(
                                                              'dd MMM yyyy',
                                                              Localizations
                                                                      .localeOf(
                                                                          context)
                                                                  .languageCode)
                                                          .format(widget.date![
                                                                  'end'] ??
                                                              DateTime.now())
                                                      : 'Дата не указана',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ))
                                          ]),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              60,
                                          height: 40,
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color.fromARGB(
                                                  31, 156, 156, 156)),
                                          child: DropdownButton<DropdownPeriod>(
                                            value: _selectedPeriod,
                                            iconSize: 18,
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            elevation: 16,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            onChanged:
                                                (DropdownPeriod? newValue) {
                                              _date['begin'] =
                                                  newValue!.dateStart;
                                              _date['end'] = newValue.dateEnd;
                                              setState(() {
                                                _selectedPeriod = newValue;
                                              });
                                              submitForm();
                                            },
                                            hint: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Выбор предустановленного периода",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            items: _dropdownOptions
                                                .map((DropdownPeriod option) {
                                              return DropdownMenuItem<
                                                  DropdownPeriod>(
                                                value: option,
                                                child: Text(
                                                  option.value,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                              );
                                            }).toList(),
                                          )),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              40,
                                          child: SfDateRangePicker(
                                            rangeTextStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 250, 102, 28),
                                            ),
                                            monthViewSettings:
                                                const DateRangePickerMonthViewSettings(
                                                    firstDayOfWeek: 1),
                                            onSelectionChanged:
                                                _onSelectionChanged,
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .range,
                                            initialSelectedRange:
                                                PickerDateRange(
                                                    widget.date!['begin'],
                                                    widget.date!['end']),
                                          )),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        child: ElevatedButton(
                                          onPressed: submitForm,
                                          child: const Text(
                                            'ПРИМЕНИТЬ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsets>(
                                                      const EdgeInsets.all(16)),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ))),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        child: TextButton(
                                          onPressed: clearForm,
                                          child: const Text('ОЧИСТИТЬ'),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 10, 10, 10),
                                            primary: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                    ])),
                          ],
                        ));
                  });
                });
          },
        ));
  }
}
