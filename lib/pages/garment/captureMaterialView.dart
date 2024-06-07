// ignore: file_names
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_state.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/pages/garment/createGarmentView.dart';

class CaptureMaterialView extends StatefulWidget {
  final File garmentImage;

  const CaptureMaterialView({
    required this.garmentImage,
    Key? key
  }): super(key: key);
  @override
  State<CaptureMaterialView> createState() => _CaptureMaterialViewState();
}

class _CaptureMaterialViewState extends State<CaptureMaterialView> {
  File? materialImage;
  final _picker = ImagePicker();
  late CreateGarmentBloc createBloc;
  late CaptureMaterialBloc materialBloc;

  GarmentModel? garment;
  File? garmentImage;
  List<MaterialModel>? materialList;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      materialImage = File(pickedFile.path);
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
    garmentImage = widget.garmentImage;
    createBloc = BlocProvider.of<CreateGarmentBloc>(context);
    materialBloc = BlocProvider.of<CaptureMaterialBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateGarmentBloc, CreateGarmentState>(
          listener: (context, state){
            if (state is DetectGarmentSuccessState){
              garment = state.result;
              if (materialList != null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGarmentView(garment: garment!,materialImage: materialImage!, garmentImage: garmentImage!)));
              }
            }
            else if (state is DetectGarmentFailState){
              final snackBar = SnackBar(content: Text(state.message),);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            }
            else if (state is DetectGarmentLoadingState){
            // Handle loading state
            showDialog(
              context: context,
              barrierDismissible: false, // Prevent dismissing while loading
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    // Blurred background
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    // Centered loading indicator
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              },
            );
          }
          }
        ),
        BlocListener<CaptureMaterialBloc, CaptureMaterialState>(
          listener: (context, state){
            if (state is CaptureMaterialSuccess){
              materialList = state.materialList;
              if (garment != null){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGarmentView(garment: garment!,materialImage: materialImage!, garmentImage: garmentImage!)));
              }
            }
            else if (state is CaptureMaterialFail){
              final snackBar = SnackBar(content: Text(state.message),);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            else if (state is ReadingMaterialLoading){
              showDialog(
              context: context,
              barrierDismissible: false, // Prevent dismissing while loading
              builder: (BuildContext context) {
                return Stack(
                  children: <Widget>[
                    // Blurred background
                    Container(
                      color: Colors.black.withOpacity(0.1),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    // Centered loading indicator
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              },
            );
            }
          }),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Capture Material'),
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
      ),
    );
}


  Widget _captureButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[ElevatedButton(
          onPressed: () async {
            // if got image
            if (materialImage != null){
              Uint8List? imageData = await _getImageBytes(materialImage!);
              if (imageData != null){
                String base64String = base64Encode(Uint8List.fromList(imageData));
                materialBloc.add(SubmitMaterialImage(imageBytes: base64String));
              }
            }

            if (garmentImage != null){
              Uint8List? imageData = await _getImageBytes(garmentImage!);
              if (imageData != null){
                String base64String = base64Encode(Uint8List.fromList(imageData));
                createBloc.add(SubmitImageEvent(imageBytes: base64String));
              }
            }
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
                    future: materialImage != null ? _getImageBytes(materialImage!) : null,
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
          child: Text("Find the garment composition and submit it here ")
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
