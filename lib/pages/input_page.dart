import 'package:apersi/utils/currency.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter/material.dart';
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
  late TextEditingController noPolController;
  late TextEditingController golonganController;
  late TextEditingController swTerakhirController;
  late TextEditingController daftarController;
  late TextEditingController swBaruController;
  final DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  late DateTime swBaru = DateTime(today.year + 1, today.month, today.day);
  late DateTime swTerakhir = today;
  String golongan = '';
  late Golongan selectedGolongan;
  int bulanSebelum = 0,
      tahunSebelum = 0,
      totalPokok = 0,
      totalDenda = 0,
      total = 0;

  @override
  void initState() {
    super.initState();
    noPolController = TextEditingController();
    golonganController = TextEditingController();
    swTerakhirController = TextEditingController();
    daftarController = TextEditingController();
    swBaruController = TextEditingController();
    daftarController.text = displayDateString(today);
    golonganController.text = '--- Pilih golongan ---';
    swTerakhirController.text = '--- Pilih tanggal ---';
    swBaruController.text =
        displayDateString(DateTime(today.year + 1, today.month, today.day));
  }

  @override
  void dispose() {
    noPolController.dispose();
    golonganController.dispose();
    swTerakhirController.dispose();
    daftarController.dispose();
    swBaruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        surfaceTintColor: whiteColor,
        shadowColor: blackColor,
        // leading: Image.asset('assets/images/jasa-raharja-logo.png'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...textFieldWithSeparatedLabel(
                  controller: noPolController,
                  placeholder: 'Nomor Polisi',
                  suffixIcon: const Icon(Symbols.pin)),
              const SizedBox(height: 16),
              ...golonganDropdown('Golongan', golonganController),
              const SizedBox(height: 16),
              ...textFieldWithSeparatedLabel(
                controller: swTerakhirController,
                placeholder: 'Tanggal SW Terakhir',
                suffixIcon: const Icon(Symbols.calendar_month),
                isReadOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),
              ...textFieldWithSeparatedLabel(
                controller: daftarController,
                placeholder: 'Tanggal Daftar',
                suffixIcon: const Icon(Symbols.calendar_month),
                isReadOnly: true,
              ),
              const SizedBox(height: 16),
              ...textFieldWithSeparatedLabel(
                controller: swBaruController,
                placeholder: 'Tanggal SW yang Akan Datang',
                suffixIcon: const Icon(Symbols.calendar_month),
                isReadOnly: true,
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
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: swTerakhir,
      firstDate: DateTime(1970, 1, 1),
      lastDate: swBaru,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: lightBlueColor, // Header background color
            dividerColor: whiteColor,
            // accentColor: Colors.black, // Text color of selected date
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
        swTerakhirController.text = displayDateString(picked);
        swTerakhir = picked;
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
      int tahunSesudah = 1, bulanProrata = 0;
      if (today.isAfter(swTerakhir)) {
        tahunSebelum = today.year - swTerakhir.year;
        bulanSebelum = tahunSebelum * 12 + today.month - swTerakhir.month;
        if (today.day < swTerakhir.day) {
          bulanSebelum--;
        }
        if (today.month < swTerakhir.month ||
            (today.month == swTerakhir.month && today.day < swTerakhir.day)) {
          tahunSebelum--;
        }
        bulanSebelum = bulanSebelum % 12;
        bulanProrata = bulanSebelum;
        if (tahunSebelum == 0 && bulanSebelum == 0) {
          bulanSebelum = 1;
        }
      }
      int pokok = (tahunSesudah + tahunSebelum) * selectedGolongan.pokok;
      int prorata =
          bulanProrata > 0 ? selectedGolongan.prorata[bulanProrata - 1] : 0;
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
      if (today.isAfter(swTerakhir)) {
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
        // simpen ke sharedpref
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().substring(11)),
        ),
      );
    }
  }
}
