import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:parking/pages/timer_widget.dart';
import 'package:parking/stores/car_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service_locator.dart';
import '../stores/auth_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userStore = serviceLocator<UserStore>();
  final _controller = PageController(viewportFraction: 0.8);
  final carStore = serviceLocator<CarStore>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carStore.getCars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(userStore.user?.email.toString() ?? ""),
          actions: [
            IconButton(
                onPressed: () async {
                  await userStore
                      .signOut()
                      .then((value) => context.go("/auth"));
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            context.go("/payment");
          },
        ),
        body: Observer(builder: (_) {
          return PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: carStore.cars.length,
              itemBuilder: (_, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      carStore.cars[index].grnz.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SvgPicture.asset(
                      "assets/car-svgrepo-com.svg",
                      height: 120,
                      fit: BoxFit.fitHeight,
                      color: Colors.teal[100 * (index % 9)],
                    ),
                    ParkingTimerWidget(
                      paymentDateAndTime: carStore.cars[index].paymentTime,
                      hours: int.parse(carStore.cars[index].hours),
                    )
                  ],
                );
              });
        }));
  }
}
