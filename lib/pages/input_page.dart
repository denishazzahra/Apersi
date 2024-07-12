import 'dart:convert';
import 'package:apersi/utils/currency.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/golongan.dart';
import '../utils/date.dart';
import '../widgets/buttons.dart';
import '../widgets/textfields.dart';
import '../utils/colors.dart';
import '../widgets/texts.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController noPolController = TextEditingController();
  TextEditingController golonganController = TextEditingController();
  TextEditingController swTerakhirController = TextEditingController();
  TextEditingController daftarController = TextEditingController();
  TextEditingController swBaruController = TextEditingController();
  DateTime tglDaftar = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  late DateTime swBaru =
      DateTime(tglDaftar.year + 1, tglDaftar.month, tglDaftar.day);
  late DateTime swTerakhir = tglDaftar;
  String golongan = '';
  late Golongan selectedGolongan;
  int bulanSebelum = 0,
      tahunSebelum = 0,
      totalPokok = 0,
      totalDenda = 0,
      total = 0;
  late SharedPreferences storage;
  Map<String, dynamic> tempAnswers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...textFieldWithSeparatedLabel(
              key: 'nopol',
              controller: noPolController,
              placeholder: 'Nomor Polisi',
              suffixIcon: const Icon(Symbols.pin),
              onChanged: _storeTemp,
            ),
            const SizedBox(height: 16),
            ...golonganDropdown('Golongan', golonganController),
            const SizedBox(height: 16),
            ...textFieldWithSeparatedLabel(
              key: 'swTerakhir',
              controller: swTerakhirController,
              placeholder: 'Tanggal SW Terakhir',
              suffixIcon: const Icon(Symbols.calendar_month),
              isReadOnly: true,
              onTap: () {
                _selectDate(swTerakhirController, 'swTerakhir');
              },
            ),
            const SizedBox(height: 16),
            ...textFieldWithSeparatedLabel(
              key: 'daftar',
              controller: daftarController,
              placeholder: 'Tanggal Daftar',
              suffixIcon: const Icon(Symbols.calendar_month),
              isReadOnly: true,
              onTap: () {
                _selectDate(swTerakhirController, 'daftar');
              },
            ),
            const SizedBox(height: 16),
            ...textFieldWithSeparatedLabel(
              key: 'swBaru',
              controller: swBaruController,
              placeholder: 'Tanggal SW yang Akan Datang',
              suffixIcon: const Icon(Symbols.calendar_month),
              isReadOnly: true,
              onChanged: _storeTemp,
            ),
            const SizedBox(height: 32),
            Divider(color: lightGreyColor),
            const SizedBox(height: 32),
            itemTotal('Nilai Pokok', formatCurrency(totalPokok)),
            const SizedBox(height: 8),
            itemTotal('Denda', formatCurrency(totalDenda)),
            const SizedBox(height: 8),
            wholeTotal('Total', formatCurrency(total)),
            const SizedBox(height: 32),
            lightBlueButton(context, 'Simpan', simpanData)
          ],
        ),
      ),
    );
  }

  void _selectDate(TextEditingController controller, String label) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('id'),
      initialDate: label == 'swTerakhir' ? swTerakhir : tglDaftar,
      firstDate: DateTime(1970, 1, 1),
      lastDate: swBaru,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: lightBlueColor, // Header background color
            dividerColor: whiteColor,
            colorScheme: ColorScheme.light(
              primary: lightBlueColor, // Selected date color
              onPrimary: whiteColor, // Text color on selected date
              surface: whiteColor, // Background color
            ),
            dialogBackgroundColor: whiteColor, // Background color of the picker
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Handle the selected date (picked)
      setState(() {
        if (label == 'swTerakhir') {
          swTerakhirController.text = displayDateString(picked);
          swTerakhir = picked;
          _storeTemp('swTerakhir', formattedDateString(picked));
        } else {
          daftarController.text = displayDateString(picked);
          tglDaftar = picked;
          swBaru = DateTime(tglDaftar.year + 1, tglDaftar.month, tglDaftar.day);
          swBaruController.text = displayDateString(swBaru);
          _storeTemp('daftar', formattedDateString(picked));
        }
        hitungPokok();
        hitungDenda();
      });
    }
  }

  List<Widget> golonganDropdown(
      String title, TextEditingController controller) {
    return [
      label(title),
      const SizedBox(height: 8),
      DropdownMenu<String>(
        width: MediaQuery.of(context).size.width - 30,
        controller: controller,
        enableFilter: false,
        requestFocusOnTap: false,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: lightGreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: lightGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: lightGreyColor, width: 1.5),
          ),
        ),
        onSelected: (String? golongan) {
          setState(() {
            this.golongan = golongan!;
            _storeTemp('golongan', golongan);
            hitungPokok();
            hitungDenda();
          });
        },
        dropdownMenuEntries: listGolongan.map<DropdownMenuEntry<String>>(
          (Golongan golongan) {
            return DropdownMenuEntry<String>(
              value: golongan.nama,
              label: golongan.nama,
            );
          },
        ).toList(),
      )
    ];
  }

  void hitungPokok() {
    try {
      selectedGolongan =
          listGolongan.where((item) => item.nama == golongan).first;
      int totalBulan = (swBaru.year - swTerakhir.year) * 12 +
          tglDaftar.month -
          swTerakhir.month;
      int pokok = (totalBulan / 12).floor() * selectedGolongan.pokok;
      int prorata = (totalBulan % 12) > 0
          ? selectedGolongan.prorata[(totalBulan % 12) - 1]
          : 0;
      setState(() {
        totalPokok = pokok + prorata;
      });
    } catch (error) {
      // not executed
    }
  }

  void hitungDenda() {
    try {
      int denda = 0;
      if (tglDaftar.isAfter(swTerakhir)) {
        tahunSebelum = tglDaftar.year - swTerakhir.year;
        bulanSebelum = tahunSebelum * 12 + tglDaftar.month - swTerakhir.month;
        if (tglDaftar.day < swTerakhir.day) {
          bulanSebelum--;
        }
        if (tglDaftar.month < swTerakhir.month ||
            (tglDaftar.month == swTerakhir.month &&
                tglDaftar.day < swTerakhir.day)) {
          tahunSebelum--;
        }
        bulanSebelum = bulanSebelum % 12;
        if (tahunSebelum == 0 && bulanSebelum == 0) {
          bulanSebelum = 1;
        }
        denda = tahunSebelum * selectedGolongan.denda[3];
        int temp = ((bulanSebelum + 1) / 3).ceil();
        if (bulanSebelum > 0) {
          denda += selectedGolongan.denda[temp - 1];
        }
      }
      setState(() {
        totalDenda = denda;
        total = totalPokok + totalDenda;
      });
    } catch (error) {
      // not executed
    }
  }

  void simpanData() {
    try {
      if (noPolController.text.trim().isEmpty) {
        throw Exception('Nomor polisi tidak boleh kosong!');
      } else if (!RegExp(r'^[A-Za-z]{1,2} ?\d{1,4} ?[A-Za-z]{1,3}$')
          .hasMatch(noPolController.text.trim())) {
        throw Exception('Format nomor polisi tidak sesuai!');
      } else if (golonganController.text == '--- Pilih golongan ---') {
        throw Exception('Golongan tidak boleh kosong!');
      } else if (swTerakhirController.text == '--- Pilih tanggal ---') {
        throw Exception('Tanggal SW terakhir tidak boleh kosong!');
      } else {
        tempAnswers = {
          'nopol': noPolController.text.trim(),
          'golongan': golongan,
          'swTerakhir': formattedDateString(swTerakhir),
          'daftar': formattedDateString(tglDaftar),
          'swBaru': formattedDateString(swBaru),
          'pokok': totalPokok,
          'denda': totalDenda,
          'total': total
        };
        SharedPreferences.getInstance().then((storage) {
          List<String> data =
              storage.containsKey('data') ? storage.getStringList('data')! : [];
          data.insert(0, jsonEncode(tempAnswers));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil tersimpan!'),
            ),
          );
          setState(() {
            storage.remove('temp');
            storage.setStringList('data', data);
            noPolController.text = '';
            swTerakhir = tglDaftar;
            swTerakhirController.text = '--- Pilih tanggal ---';
            golongan = '';
            golonganController.text = '--- Pilih golongan ---';
            totalDenda = 0;
            totalPokok = 0;
            total = 0;
          });
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().substring(11)),
        ),
      );
    }
  }

  void _loadData() {
    SharedPreferences.getInstance().then((storage) {
      tempAnswers = jsonDecode(storage.getString('temp')!);
    }).catchError((error) {
      tempAnswers = {};
    }).whenComplete(() {
      if (tempAnswers.containsKey('nopol')) {
        noPolController.text = tempAnswers['nopol'];
      }
      if (tempAnswers.containsKey('golongan')) {
        golongan = tempAnswers['golongan'];
        golonganController.text = golongan;
      } else {
        golonganController.text = '--- Pilih golongan ---';
      }
      if (tempAnswers.containsKey('swTerakhir')) {
        swTerakhir = parseFromString(tempAnswers['swTerakhir']);
        swTerakhirController.text = displayDateString(swTerakhir);
      } else {
        swTerakhirController.text = '--- Pilih tanggal ---';
      }
      if (tempAnswers.containsKey('daftar')) {
        tglDaftar = parseFromString(tempAnswers['daftar']);
        swBaru = DateTime(tglDaftar.year + 1, tglDaftar.month, tglDaftar.day);
      }
      daftarController.text = displayDateString(tglDaftar);
      swBaruController.text = displayDateString(swBaru);
      if (tempAnswers.isNotEmpty) {
        hitungPokok();
        hitungDenda();
      }
    });
  }

  void _storeTemp(key, value) {
    tempAnswers[key] = value;
    SharedPreferences.getInstance().then((storage) {
      storage.setString('temp', jsonEncode(tempAnswers));
    }).catchError((error) {
      tempAnswers = {};
    });
  }
}
