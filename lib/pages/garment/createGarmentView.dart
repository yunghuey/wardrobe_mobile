import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CaptureMaterial/captureMaterial_state.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';
import 'package:wardrobe_mobile/pages/ValueConstant.dart';
import 'dart:math';

class CreateGarmentView extends StatefulWidget {
  final GarmentModel garment;
  final File garmentImage;
  final File materialImage;

  const CreateGarmentView(
      {required this.garment,
      required this.garmentImage,
      required this.materialImage,
      Key? key})
      : super(key: key);

  @override
  State<CreateGarmentView> createState() => _CreateGarmentViewState();
}

class _CreateGarmentViewState extends State<CreateGarmentView> {
  late GarmentModel garmentResult;
  late File garmentImageResult;
  late File materialImageResult;
  final _formKey = GlobalKey<FormState>();
  late CreateGarmentBloc createBloc;
  late List<MaterialModel> materials;
  bool colourChanged = false;

  String? _selectedCountry;
  String? _selectedSize;
  String? _selectedBrand;
  String? _selectedColour;
  String? colorCode;
  bool isChanged = false;
  late ValueNotifier<Color> _colorNotifier;
  TextEditingController nameController = TextEditingController();

  // for material
  late double percentageSum;
  bool materialComplete = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    garmentResult = widget.garment;
    garmentImageResult = widget.garmentImage;
    materialImageResult = widget.materialImage;
    createBloc = BlocProvider.of<CreateGarmentBloc>(context);
    _selectedCountry = garmentResult.country;
    _selectedSize = garmentResult.size;
    _selectedBrand = garmentResult.brand;
    _selectedColour = garmentResult.colour_name;
    _colorNotifier = ValueNotifier<Color>(HexColor(garmentResult.colour));
    colorCode = garmentResult.colour;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateGarmentBloc, CreateGarmentState>(
      listener: (context, state) {
        if (state is CreateGarmentLoadingState) {
          final snackBar = const SnackBar(content: Text("loading"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is CreateGarmentSuccessState) {
          final snackBar = const SnackBar(content: Text("Successfully created garment"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const RoutePage(),
              fullscreenDialog: false,
            ),
            (route) => false,
          );
        } else if (state is CreateGarmentFailState) {
          final snackBar = const SnackBar(content: Text("fail"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                _garmentImage(),
                _materialImage(),
                _garmentName(),
                _garmentCountry(),
                _garmentBrand(),
                _garmentSize(),
                _garmentColour(),
                _materialCustomization(),
                // _garmentColorCode(),
                _garmentSubmit(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _materialCustomization() {
    return BlocBuilder<CaptureMaterialBloc, CaptureMaterialState>(
      builder: (context, state) {
        if (state is CaptureMaterialSuccess) {
          materials = state.materialList;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 10.0, bottom: 10.0),
                child: ElevatedButton(
                  onPressed: !materialComplete ? () {
                    percentageSum = 0.0;
                    setState(() {
                      for (var m in materials) {
                        if (m.materialName != ValueConstant.MATERIAL_NAME[0]) {
                          percentageSum += m.percentage;
                        } else {
                          percentageSum = 200;
                        }
                        if (m.percentage == 0) {
                          percentageSum = 300;
                        }
                      }
                    });
                    if (percentageSum < 100) {
                      var newRow = MaterialModel(
                          materialName: ValueConstant.MATERIAL_NAME[0],
                          percentage: 100-percentageSum);
                      materials.add(newRow);
                      setState(() {});
                    } else if (percentageSum == 200) {
                      final snackBar =
                          SnackBar(content: Text("Please choose a material"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // final snackBar = SnackBar(
                      //     content: Text(
                      //         "Percentage has exceed 100, cannot add anymore"));
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      null;
                    }
                    materialComplete =true;
                    setState(() {});
                  }: null,
                  child: Row(
                      children: [
                        const Icon(Icons.add),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Add material", style: TextStyle(color:Color.fromARGB(255, 93, 63, 184))),
                      ],
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButton<String>(
                            value: materials[index].materialName,
                            onChanged: (String? newValue) {
                              setState(() {
                                materials[index].materialName = newValue!;
                              });
                            },
                            items: _getDropdownItems(index),
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 70, // Set the width you want here
                          child: TextFormField(
                            initialValue:
                                min(100, materials[index].percentage).toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              double newPercentage =
                                  double.tryParse(value) ?? 0.0;
                              if (newPercentage <= 100) {
                                setState(() {
                                  materials[index].percentage = newPercentage;
                                });
                              }
                              if (newPercentage == 0.0) {
                                final snackBar = SnackBar(
                                    content: Text("Percentage cannot be 0"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 3),
                        IconButton(
                          onPressed: () {
                            if (materials.length > 1) {
                              setState(() {
                                materials.removeAt(index);
                              });
                            } else {
                              // SnackBar sn =
                              //     SnackBar(content: Text("Unable to remove"));
                              // ScaffoldMessenger.of(context).showSnackBar(sn);
                              null;
                            }
                            setState(() {
                              materialComplete = false;
                            });
                          },
                          icon: Icon(Icons.remove_circle),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  List<DropdownMenuItem<String>> _getDropdownItems(int index) {
    List<String> selectedMaterials =
        materials.map((m) => m.materialName).toList();

    if (selectedMaterials.isNotEmpty) {
      selectedMaterials.removeAt(index);
    } else {
      selectedMaterials.removeAt(0);
    }
    List<String> availableMaterials = ['Select material'];
    availableMaterials.addAll(ValueConstant.MATERIAL_NAME
        .where((material) =>
            material != 'Select material' &&
            !selectedMaterials.contains(material))
        .toList());
    return availableMaterials.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(value: value, child: Text(value));
    }).toList();
  }

  // set default colorcode for color changed
  Widget _garmentColour() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Garment Colour:'), // Label
          DropdownButton<String>(
            value: _selectedColour,
            onChanged: (String? newValue) {
              setState(() {
                _selectedColour = newValue;
              });
            },
            items: ValueConstant.COLOUR_NAME
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _garmentSubmit() {
    return ElevatedButton(
        onPressed: () {
          // calculate material summation
          percentageSum = 0.0;
          for (final m in materials) {
            percentageSum += m.percentage;
          }
          if (_formKey.currentState!.validate() &&
              _selectedCountry != ValueConstant.COUNTRY[0] &&
              _selectedBrand != ValueConstant.BRANDS_NAME[0] &&
              _selectedSize != ValueConstant.SIZES[0] &&
              _selectedColour != ValueConstant.COLOUR_NAME[0] &&
              nameController.text != '' &&
              percentageSum == 100) {
            // is to check garment name
            if (isChanged) {
                  int index = ValueConstant.COLOUR_NAME.indexOf(_selectedColour!);
                  colorCode = ValueConstant.COLOUR_CODE[index];
            }
            else {
            String colorString =
                _colorNotifier.value.toString(); // Color(0xffcca2ae)
            colorCode = '#${colorString.split('(0xff')[1].split(')')[0]}'; // cca2ae
            }
            GarmentModel garmentObj = GarmentModel(
              brand: _selectedBrand ?? '',
              colour: colorCode!,
              // country: ValueConstant.COUNTRY[1],
              country: _selectedCountry ?? '',
              size: _selectedSize ?? '',
              colour_name: _selectedColour ?? 'WHITE',
              name: nameController.text.trim(),
              garmentImage: garmentImageResult,
              materialImage: materialImageResult,
              materialList: materials,
            );

            createBloc.add(CreateButtonPressed(garment: garmentObj));
          } 
          else if (nameController.text == ''){
            const snackBar =
                SnackBar(content: Text('Give a name for your garment.'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else if (percentageSum != 100){
            const snackBar =
                SnackBar(content: Text('The material must not exceed 100%'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          else {
            const snackBar =
                SnackBar(content: Text('Please complete the form'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          // image
        },
        child: const Text("Create garment", style: TextStyle(color: Color.fromARGB(255, 93, 63, 184))),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
      ),
      );
  }

  Widget _garmentColorCode() {
    // can make into InkWell to detect press and display showDialog
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ValueListenableBuilder<Color>(
          valueListenable: _colorNotifier,
          builder: (_, color, __) {
            return ColorPicker(
              color: color,
              onChanged: (value) {
                _colorNotifier.value = value;
              },
            );
          }),
    );
  }

  Widget _garmentSize() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Garment Size:'), // Label
          DropdownButton<String>(
            value: _selectedSize,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSize = newValue; // Corrected the variable name
              });
            },
            items: ValueConstant.SIZES
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _garmentBrand() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Garment Brand:'), // Label
          DropdownButton<String>(
            value: _selectedBrand,
            onChanged: (String? newValue) {
              setState(() {
                _selectedBrand = newValue; // Corrected the variable name
              });
            },
            items: ValueConstant.BRANDS_NAME
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _garmentCountry() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Align children to the left
        children: [
          const Text('Garment Country:'), // Label
          DropdownButton<String>(
            value: _selectedCountry,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountry = newValue; // Corrected the variable name
              });
            },
            items: ValueConstant.COUNTRY
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _garmentName() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Garment Name',
          hintText: 'Enter garment name',
        ),
      ),
    );
  }

  Widget _garmentImage() {
    Uint8List bytes;
    try {
      bytes = garmentImageResult.readAsBytesSync();
    } catch (e) {
      print("Error reading image file: $e");
      bytes = Uint8List(0);
    }
    return Container(
      height: 185,
      width: 185,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: MemoryImage(bytes),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _materialImage() {
    Uint8List bytes;
    try {
      bytes = materialImageResult.readAsBytesSync();
    } catch (e) {
      print("Error reading image file: $e");
      bytes = Uint8List(0);
    }
    return Container(
      height: 185,
      width: 185,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: MemoryImage(bytes),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
