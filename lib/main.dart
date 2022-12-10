import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_practice/bloc/bloc/crud_bloc.dart';
import 'package:sqflite_practice/page/add_item.dart';
import 'package:sqflite_practice/splash_screen/splash_screen.dart';

import 'page/details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CrudBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SqFliteDemo extends StatefulWidget {
  const SqFliteDemo({Key? key}) : super(key: key);

  @override
  State<SqFliteDemo> createState() => _SqFliteDemoState();
}

class _SqFliteDemoState extends State<SqFliteDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Hyper Garage Sale'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.black87,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const AddItemPage()));
        },
      ),
      body: BlocBuilder<CrudBloc, CrudState>(
        builder: (context, state) {
          if (state is CrudInitial) {
            context.read<CrudBloc>().add(const FetchItems());
          }
          if (state is DisplayItems) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  state.cItem.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(2),
                            itemCount: state.cItem.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<CrudBloc>().add(
                                      FetchSpecificItem(id: state.cItem[i].id!));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const DetailsPage()),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(bottom: 14),
                                  child: Card(
                                    elevation: 10,
                                    color: Colors.blue,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            state.cItem[i].title.toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CrudBloc>()
                                                        .add(DeleteItem(
                                                            id: state
                                                                .cItem[i].id!));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      content:
                                                          Text("deleted item"),
                                                    ));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Text(''),
                ]),
              ),
            );
          }
          return Container(
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
