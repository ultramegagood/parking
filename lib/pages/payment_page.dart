/// Деректерді енгізу және билетті төлеу беті
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:parking/routes.dart';

import '../service_locator.dart';
import '../stores/car_store.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int hours = 0;
  int price = 0;
  String region = "";
  final carStore = serviceLocator<CarStore>();
  final _formKey = GlobalKey<FormState>();

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
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Если цена парковки выше 5 часов то цена 250 тенге\nЕсли меньше 5 часов то цена 70 тенге",
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val){
                    if(val != null && val.isNotEmpty){
                      return null ;
                    }else{
                      return "Ошибка введите данные";
                    }
                  },
                  inputFormatters: [maskFormatter],
                  decoration: const InputDecoration(
                    hintText: 'Госномер',
                    prefixIcon: Icon(Icons.car_rental),
                  ),
                  onChanged: (val) {
                    carStore.grnz = maskFormatter.unmaskText(val);
                    logger.w(maskFormatter.unmaskText(val).length);
                    if(maskFormatter.unmaskText(val).length == 8) {
                      String lastTwoDigits = maskFormatter.unmaskText(val).substring(maskFormatter.unmaskText(val).length - 2);

                     setState(() {
                       region = getRegion(lastTwoDigits);
                     });}
                  },
                ),
                if(region.isNotEmpty)
                const SizedBox(
                  height: 5,
                ),
                if(region.isNotEmpty)
                  Text(region),
                  const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (val){
                    if(val != null && val.isNotEmpty){
                      return null ;
                    }else{
                      return "Ошибка введите данные";
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Сколько часов?',
                    prefixIcon: Icon(Icons.watch_later_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (val.isNotEmpty) {
                      carStore.hour = val;
                      setState(() {
                        hours = int.parse(val);
                        if (hours > 5) {
                          price = 250;
                        } else {
                          price = 70;
                        }
                      });
                    } else {
                      carStore.hour = "0";

                      setState(() {
                        hours = 0;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hours > 0)
                      Text(
                        "Цена: ${hours * price} тенге",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        carStore.addCar();
                        context.pop();
                      }
                    },
                    child: const Text("Оплатить"))
              ],
            ),
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
