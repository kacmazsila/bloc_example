import 'dart:math';

import 'package:bloc_example/bloc/pizza_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/pizza_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PizzaBloc()..add(LoadPizzaCounter())),
      ],
      child: MaterialApp(
        title: 'Bloc Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocBuilder<PizzaBloc, PizzaState>(builder: (context, state) {
          if (state is PizzaInitial) {
            return const CircularProgressIndicator(
              color: Colors.orange,
            );
          } else if (state is PizzaLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${state.pizzas.length}",
                  style: const TextStyle(
                      fontSize: 60, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      for (int index = 0; index < state.pizzas.length; index++)
                        Positioned(
                          left: Random.secure().nextDouble(),
                          top: Random.secure().nextDouble(),
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: state.pizzas[index].image,
                          ),
                        )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Text('Hata oluştu');
          }
        }),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              child: Icon(Icons.local_pizza),
              onPressed: () {
                context.read<PizzaBloc>().add(AddPizza(Pizza.pizzas[0]));
              }),
          FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                context.read<PizzaBloc>().add(RemovePizza(Pizza.pizzas[0]));
              })
        ],
      ),
    );
  }
}
