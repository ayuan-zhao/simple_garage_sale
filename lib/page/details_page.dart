import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:garage_sale/bloc/bloc/crud_bloc.dart';
import '../constants/constants.dart';
import '../models/citem.dart';
import '../models/utility.dart';
import '../widgets/custom_text.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final TextEditingController _newTitle = TextEditingController();
  final TextEditingController _newDescription = TextEditingController();
  final TextEditingController _newPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            context.read<CrudBloc>().add(const FetchItems());
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<CrudBloc, CrudState>(
          builder: (context, state) {
            if (state is DisplaySpecificItem) {
              CommodityItem currentItem = state.cItem;
              Image? img = currentItem.c_image.isEmpty
                  ? null
                  : Utility.imageFromBase64String(currentItem.c_image);
              _newTitle.text = currentItem.title;
              _newPrice.text = currentItem.c_price.toString();
              _newDescription.text = currentItem.description;
              return Column(
                children: [
                  CustomText(text: 'title'.toUpperCase()),
                  const SizedBox(height: 10),
                  TextFormField(
                      initialValue: currentItem.title, enabled: false),
                  const SizedBox(height: 10),
                  CustomText(text: 'description'.toUpperCase()),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: currentItem.description,
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  CustomText(text: 'date made'.toUpperCase()),
                  const SizedBox(height: 10),
                  CustomText(
                      text:
                          DateFormat.yMMMEd().format(state.cItem.createdTime)),
                  const SizedBox(height: 10),
                  CustomText(text: 'item price'.toUpperCase()),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: currentItem.c_price.toString(),
                    enabled: false,
                  ),
                  const SizedBox(height: 10),
                  img != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: img,
                          ),
                        )
                      : CustomText(
                          text: "No Image",
                        ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext cx) {
                              return StatefulBuilder(
                                builder: ((context, setState) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Update Item',
                                      style: TextStyle(
                                          fontSize: 25,
                                          letterSpacing: 2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Title')),
                                        Flexible(
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              isDense: true,
                                            ),
                                            maxLines: 1,
                                            controller: _newTitle,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Description')),
                                        Flexible(
                                          child: TextFormField(
                                            controller: _newDescription,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Price')),
                                        Flexible(
                                          child: TextFormField(
                                            controller: _newPrice,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        style: Constants.customButtonStyle,
                                        onPressed: () {
                                          Navigator.pop(cx);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: Constants.customButtonStyle,
                                        onPressed: () async {
                                          context.read<CrudBloc>().add(
                                                UpdateItem(
                                                  cItem: CommodityItem(
                                                    id: currentItem.id,
                                                    createdTime: DateTime.now(),
                                                    description: _newDescription
                                                            .text.isEmpty
                                                        ? currentItem
                                                            .description
                                                        : _newDescription.text,
                                                    c_price: _newPrice
                                                            .text.isEmpty
                                                        ? currentItem.c_price
                                                        : int.parse(
                                                            _newPrice.text),
                                                    c_image:
                                                        currentItem.c_image,
                                                    number: currentItem.number,
                                                    title:
                                                        _newTitle.text.isEmpty
                                                            ? currentItem.title
                                                            : _newTitle.text,
                                                  ),
                                                ),
                                              );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            backgroundColor:
                                                Constants.primaryColor,
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                                'Commodity Item details updated'),
                                          ));
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          context
                                              .read<CrudBloc>()
                                              .add(const FetchItems());
                                        },
                                        child: const Text('Update'),
                                      ),
                                    ],
                                  );
                                }),
                              );
                            });
                      },
                      child: const Text('Update'))
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
