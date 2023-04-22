/// Деректерді енгізу және билетті төлеу беті
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:parking/models/car.dart';
import 'package:parking/routes.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';

import '../service_locator.dart';
import '../stores/car_store.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int price = 0;
  int placeId = 0;
  String region = "";
  bool showqr = true;
  String grnz = "";
  final carStore = serviceLocator<CarStore>();
  final _formKey = GlobalKey<FormState>();
  late QRViewController _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      logger.w([
        scanData.code,
        jsonDecode(scanData.code!)['place'] != null,
        jsonDecode(scanData.code!)['place']
      ]);
      if (jsonDecode(scanData.code!)['place'] != null) {
        placeId = jsonDecode(scanData.code!)['place'];
        showqr = false;
        setState(() {});
      }
      // Обрабатывайте данные, которые были получены при сканировании QR-кода
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  var maskFormatter = SpecialMaskTextInputFormatter();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Observer(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              if (showqr == true)
                SizedBox(
                  height: 150,
                  width: 150,
                  child: QRView(
                    key: _qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (placeId != 0)
                        Text(
                          "Номер парковки ${placeId}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      if (placeId != 0)
                        const SizedBox(
                          height: 20,
                        ),
                      Text(
                        "Если цена парковки выше 5 часов то цена 250 тенге\nЕсли меньше 5 часов то цена 70 тенге",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val != null && val.isNotEmpty) {
                            return null;
                          } else {
                            return "Ошибка введите данные";
                          }
                        },
                        inputFormatters: [maskFormatter],
                        decoration: const InputDecoration(
                          hintText: 'Госномер',
                          prefixIcon: Icon(Icons.car_rental),
                        ),
                        onChanged: (val) {
                          grnz = maskFormatter.unmaskText(val);
                          logger.w(maskFormatter.unmaskText(val).length);
                          if (maskFormatter.unmaskText(val).length == 8) {
                            String lastTwoDigits = maskFormatter
                                .unmaskText(val)
                                .substring(
                                    maskFormatter.unmaskText(val).length - 2);

                            setState(() {
                              region = getRegion(lastTwoDigits);
                            });
                          }
                        },
                      ),
                      if (region.isNotEmpty)
                        const SizedBox(
                          height: 5,
                        ),
                      if (region.isNotEmpty) Text(region),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            var uuid = Uuid();

                            if (_formKey.currentState!.validate()) {
                              carStore.addCar(Car(
                                  id: uuid.v4(),
                                  purchaseTime: DateTime.now(),
                                  grnz: grnz,
                                  hours: "0",
                                  numberPlace: placeId.toString(),
                                  price: "0"));
                              context.pop();
                            }
                          },
                          child: const Text("Оплатить"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

String getRegion(String code) {
  switch (code) {
    case '01':
      return 'г. Нур-Султан (Астана)';
    case '02':
      return 'г. Алматы';
    case '03':
      return 'Акмолинская область';
    case '04':
      return 'Актюбинская область';
    case '05':
      return 'Алматинская область';
    case '06':
      return 'Атырауская область';
    case '07':
      return 'Западно-Казахстанская область';
    case '08':
      return 'Жамбылская область';
    case '09':
      return 'Карагандинская область';
    case '10':
      return 'Костанайская область';
    case '11':
      return 'Кызылординская область';
    case '12':
      return 'Мангистауская область';
    case '13':
      return 'Туркестанская область';
    case '14':
      return 'Павлодарская область';
    case '15':
      return 'Северо-Казахстанская область';
    case '16':
      return 'Восточно-Казахстанская область';
    case '17':
      return 'г. Шымкент';
    case '18':
      return 'Абайская область';
    case '19':
      return 'Жетысуская область';
    case '20':
      return 'Улытауская область';
    default:
      return 'Unknown';
  }
}

class SpecialMaskTextInputFormatter extends MaskTextInputFormatter {
  static String maskA = "### SSS|##";

  SpecialMaskTextInputFormatter({String? initialText})
      : super(
            mask: maskA,
            filter: {"#": RegExp('[0-9]'), "S": RegExp('[a-zA-Z]')},
            initialText: initialText);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return super.formatEditUpdate(oldValue, newValue);
  }
}
