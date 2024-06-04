// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/pages/garment/captureMaterialView.dart';
import 'package:wardrobe_mobile/pages/garment/createGarmentView.dart'; 

class CaptureImageView extends StatefulWidget {
  const CaptureImageView({super.key});

  @override
  State<CaptureImageView> createState() => _CaptureImageViewState();
}

class _CaptureImageViewState extends State<CaptureImageView> {
  File? image;
  final _picker = ImagePicker();
  // late CreateGarmentBloc createBloc;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
      Navigator.pop(context);
    }
  }

  Future<Uint8List?> _getImageBytes(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();
      return Uint8List.fromList(imageBytes);
    } catch (e) {
      print("Error reading image as bytes: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Image'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              _insertImage(context),
              _captureText(),
              _captureButton(),
            ],
          ),
        ),
      ),
    );
}


  Widget _captureButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[ElevatedButton(
          onPressed: () {
            if (image != null){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CaptureMaterialView(garmentImage: image!,)));
            }
            // if got image
            // if (image != null){
            //   Uint8List? imageData = await _getImageBytes(image!);
            //   if (imageData != null){
                // String base64String = base64Encode(Uint8List.fromList(imageData));
                // createBloc.add(SubmitImageEvent(imageBytes: base64String));
            //   }
            // }
          },
          child: const Text('Submit'),
        ),],
      ),
    );
  }

  Widget _insertImage(BuildContext context) {
      return Center(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => _bottomSheet(context)),
                );
              },
              child: Container(
                width: 300,
                height: 550,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: HexColor("#3c1e08"),
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FutureBuilder<Uint8List?>(
                    future: image != null ? _getImageBytes(image!) : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Image.memory(
                          snapshot.data!,
                          width: 300,
                          height: 550,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const Center(
                          child: Text('Pick an Image'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.0,
              right: 20.0,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => _bottomSheet(context)),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: HexColor("#3c1e08"),
                  size: 28.0,
                ),
              ),
            ),
          ],
        ),
      );
    }

  Widget _captureText(){
    return Container(
      margin: const EdgeInsets.only(left: 7.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: const Center(
          child: Text("Click the item above to submit an image.")
        ),
      ),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Container(
      height: 150.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Image",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera, color: HexColor("#3c1e08")),
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                label: Text("Camera", style: TextStyle(color:HexColor("#3c1e08")),),
              ),
              TextButton.icon(
                icon: Icon(Icons.image, color: HexColor("#3c1e08")),
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                label: Text("Gallery", style: TextStyle(color:HexColor("#3c1e08")),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
