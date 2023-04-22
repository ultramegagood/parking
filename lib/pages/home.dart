/// Сатып алынған автотұрақ абоненттерін көрсету үшін басты бет
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:parking/pages/timer_widget.dart';
import 'package:parking/stores/car_store.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../service_locator.dart';
import '../stores/auth_store.dart';
import 'dart:async';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CarListPage extends StatefulWidget {
  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final _carStore = serviceLocator<CarStore>();
  late Timer _timer;
  String getFormattedTime(DateTime purchaseTime) {
    final timePassed = DateTime.now().difference(purchaseTime).inSeconds;
    final hoursPassed = timePassed ~/ 3600;
    final minutesPassed = (timePassed % 3600) ~/ 60;
    final secondsPassed = timePassed % 60;

    final hoursText = hoursPassed > 0 ? "$hoursPassed сагат${hoursPassed > 1 ? "s" : ""} " : "";
    final minutesText = minutesPassed > 0 ? "$minutesPassed минут${minutesPassed > 1 ? "s" : ""} " : "";
    final secondsText = "$secondsPassed секунд${secondsPassed > 1 ? "s" : ""}";

    return "$hoursText$minutesText$secondsText";
  }
  String getFormattedPrice(Car car) {
    final timePassed = DateTime.now().difference(car.purchaseTime).inSeconds;
    final hoursPassed = timePassed ~/ 3600;

    if (hoursPassed == 0) {
      return "70 T";
    } else {
      return "${(hoursPassed * 250)} T";
    }
  }

  Future<Uint8List> generateReceiptPdf(Car car) async {
    final pdf = pw.Document();

    // Добавляем шрифт Montserrat
    final fontData = await rootBundle.load("assets/fonts/Montserrat-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final bold = pw.Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Bold.ttf"));
    final pw.ThemeData theme = pw.ThemeData.withFont(
      base: ttf,
      bold: bold,
    );

    // Создаем страницу PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Theme(
          data: theme,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Тұрақ туралы түбіртек", textScaleFactor: 2),
              pw.SizedBox(height: 20),
              pw.Text("Госномер: ${car.grnz}"),
              pw.Text("Уақыт тоқталды: ${getFormattedTime(car.purchaseTime)}"),
              pw.Text("Бағасы: ${getFormattedPrice(car)}"),
            ],
          ),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (_) => pdf.save());

    return pdf.save();
  }

  @override
  void initState() {
    super.initState();
    _carStore.loadCars();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car List'),
      ),
      body: Observer(
        builder: (context) {
          final carList = _carStore.carList;
          return ListView.builder(
            itemCount: carList.length,
            itemBuilder: (context, index) {
              final car = carList[index];
              final timePassed = DateTime.now().difference(car.purchaseTime).inSeconds;
              final hoursPassed = timePassed ~/ 3600;
              final minutesPassed = (timePassed % 3600) ~/ 60;
              final secondsPassed = timePassed % 60;

              int price;
              if (hoursPassed == 0) {
                price = 70;
              } else if (hoursPassed == 1) {
                price = 10 + 50;
              } else {
                price = 10 + 50 + (hoursPassed - 1) * 250;
              }

              return ListTile(
                onTap: ()async{
                  final receiptPdf = await generateReceiptPdf(car);

                },
                leading: SvgPicture.asset(
                  'assets/car-svgrepo-com.svg',
                  height: 25,
                  width: 26,
                  color: Colors.teal[100 * (index % 9)],
                ),
                title: Text('${car.grnz}'),
                subtitle: Text(
                    'бағасы: $priceтг.   Орын:${car.numberPlace}\nУақыт өтті: $hoursPassed:$minutesPassed:$secondsPassed'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _carStore.deleteCar(car),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewCar,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewCar() {
    context.go("/payment");
  }
}
