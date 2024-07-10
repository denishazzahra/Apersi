import 'dart:convert';

import 'package:apersi/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colors.dart';
import '../utils/currency.dart';
import '../widgets/texts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Map<String, dynamic>> data = [];
  late List<bool> itemState = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (data.isEmpty) {
      return Center(
        child: secondaryText(text: 'Data kosong!'),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: data
              .asMap()
              .entries
              .map((item) => dismissibleItem(item.key))
              .toList(),
        ),
      );
    }
  }

  Widget dismissibleItem(int index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: dangerColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Symbols.delete,
                fill: 0,
                color: whiteColor,
              ),
            )
          ],
        ),
      ),
      secondaryBackground: Container(
        color: dangerColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Symbols.delete,
                fill: 0,
                color: whiteColor,
              ),
            )
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return _confirmDialog(index);
          },
        );
      },
      onDismissed: (direction) {
        _deleteData(index);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600,
              // spreadRadius: 5,
              blurRadius: 2,
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label(data[index]['nopol']),
                    secondaryText(text: 'Golongan ${data[index]['golongan']}'),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    smallSecondaryText(
                      displayDateString(
                        parseFromString(data[index]['daftar']),
                      ),
                    ),
                    const SizedBox(height: 4),
                    boldDefault(text: formatCurrency(data[index]['total'])),
                  ],
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      itemState[index] = !itemState[index];
                    });
                  },
                  icon: itemState[index]
                      ? const Icon(Symbols.keyboard_arrow_down)
                      : const Icon(Symbols.keyboard_arrow_right),
                  color: darkGreyColor,
                  iconSize: 24,
                  splashRadius: 24,
                  visualDensity: VisualDensity.compact,
                )
              ],
            ),
            detailData(index),
          ],
        ),
      ),
    );
  }

  Widget _confirmDialog(int index) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Konfirmasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text('Apakah Anda yakin untuk menghapus data ini?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(color: darkGreyColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Ya, hapus',
                    style: TextStyle(color: dangerColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget detailData(int index) {
    return itemState[index]
        ? Container(
            margin: const EdgeInsets.only(top: 16),
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: lightGreyColor),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    secondaryText(text: 'Tanggal SW Terakhir'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: secondaryText(
                        text: displayDateString(
                          parseFromString(data[index]['swTerakhir']),
                        ),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    secondaryText(text: 'Tanggal Daftar'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: secondaryText(
                        text: displayDateString(
                          parseFromString(data[index]['daftar']),
                        ),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    secondaryText(text: 'Tanggal SW Baru'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: secondaryText(
                        text: displayDateString(
                          parseFromString(data[index]['swBaru']),
                        ),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    secondaryText(text: 'Nilai Pokok'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: secondaryText(
                        text: formatCurrency(data[index]['pokok']),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    secondaryText(text: 'Denda'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: secondaryText(
                        text: formatCurrency(data[index]['denda']),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldDefault(text: 'Total'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: boldDefault(
                        text: formatCurrency(data[index]['total']),
                        alignment: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container();
  }

  void _deleteData(int index) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    setState(() {
      data = List.from(data);
      itemState = List.from(itemState);
      data.removeAt(index);
      itemState.removeAt(index);
      storage.setStringList(
        'data',
        data.map((item) => jsonEncode(item)).toList(),
      );
      _loadData();
    });
  }

  void _loadData() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    setState(() {
      final storedData = storage.getStringList('data');
      if (storedData != null) {
        data = storedData
            .map((item) => jsonDecode(item) as Map<String, dynamic>)
            .toList();
        itemState = List<bool>.filled(data.length, false);
      } else {
        data = [];
        itemState = [];
      }
      isLoading = false;
    });
  }
}
