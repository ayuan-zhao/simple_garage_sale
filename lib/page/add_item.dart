import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garage_sale/bloc/bloc/crud_bloc.dart';
import '../models/utility.dart';
import '../widgets/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _price = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  XFile? imgFile;
  String imgString = "";

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await imagePicker.pickImage(source: media);
    String imgStr = Utility.base64String(await img!.readAsBytes());

    setState(() {
      imgFile = img;
      imgString = imgStr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CustomText(text: 'title'.toUpperCase()),
              TextFormField(controller: _title),
              CustomText(text: 'description'.toUpperCase()),
              TextFormField(controller: _description),
              CustomText(text: 'price'.toUpperCase()),
              TextFormField(controller: _price),
              MaterialButton(
                  color: Colors.blue,
                  child: const Text("Pick Images from Gallery",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  }),
              SizedBox(
                height: 20,
              ),
              //if image not null show the image
              //if image null show text
              imgFile != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image, you type like this.
                          File(imgFile!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                        ),
                      ),
                    )
                  : Text(
                      "No Image",
                      style: TextStyle(fontSize: 20),
                    ),
              BlocBuilder<CrudBloc, CrudState>(
                builder: (context, state) {
                  return ElevatedButton(
                      onPressed: () {
                        if (_title.text.isNotEmpty &&
                            _description.text.isNotEmpty) {
                          context.read<CrudBloc>().add(
                                AddItem(
                                  title: _title.text,
                                  c_price: int.parse(_price.text),
                                  c_image: imgString,
                                  number: 0,
                                  description: _description.text,
                                  createdTime: DateTime.now(),
                                ),
                              );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text("Commodity Item added successfully"),
                          ));
                          context.read<CrudBloc>().add(const FetchItems());
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "title and description fields must not be blank"
                                    .toUpperCase()),
                          ));
                        }
                      },
                      child: const Text('Add an Item'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
