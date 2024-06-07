import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';

class EditGarmentView extends StatefulWidget {
  final GarmentModel garment;

  const EditGarmentView({required this.garment, Key? key}) : super(key: key);

  @override
  State<EditGarmentView> createState() => _EditGarmentViewState();
}

class _EditGarmentViewState extends State<EditGarmentView> {
  late UpdateGarmentBloc updateBloc;

  late GarmentModel updateGarment;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String? _selectedCountry;
  String? _selectedSize;
  String? _selectedBrand;
  String? _selectedColour;
  String? garmentImageURL;
  String? materialImageURL;
  bool isChanged = false;
  double percentageSum = 0.0;
  late List<MaterialModel> materials;
  late DeleteGarmentBloc deleteBloc;

  final loadingWidget = BlocBuilder<UpdateGarmentBloc, UpdateGarmentState>(
    builder: (context, state) {
      if (state is UpdateGarmentLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Container();
      }
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateBloc = BlocProvider.of<UpdateGarmentBloc>(context);
    deleteBloc = BlocProvider.of<DeleteGarmentBloc>(context);

    updateGarment = widget.garment;
    nameController.text = updateGarment.name!;
    _selectedBrand = updateGarment.brand;
    _selectedColour = updateGarment.colour_name;
    _selectedCountry = updateGarment.country;
    _selectedSize = updateGarment.size;
    garmentImageURL = updateGarment.garmentImageURL;
    materialImageURL = updateGarment.materialImageURL;
    materials = updateGarment.materialList!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit garment'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpdateGarmentBloc, UpdateGarmentState>(
          listener: (context, state) {
            if (state is UpdateGarmentSuccess) {
              const snackBar = SnackBar(content: Text('Updated successfully!'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoutePage(
                            page: 1,
                          )),
                  (route) => false);
            } else if (state is UpdateGarmentFail) {
              const snackBar = SnackBar(content: Text(''));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          ),
          BlocListener<DeleteGarmentBloc, DeleteGarmentState>(
            listener: (context, state){
              if (state is DeleteGarmentSuccess){
                final snackBar = SnackBar(content: Text('Garment is deleted'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RoutePage(page: 1,)),(route) => false);
              }
              else if (state is DeleteGarmentFail){
                final snackbar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            }
          ),
        ],
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _displayImage(),
                    _displayMaterialImage(),
                    _nameTextField(),
                    _countryField(),
                    _sizeField(),
                    _brandField(),
                    _colourField(),
                    _materialCustomization(),
                    loadingWidget,
                    _submitButton(),
                    SizedBox(height: 20),
                    _deleteButton(),
                    SizedBox(height: 20),
                  ]),
            ),
          ),
      ),      
    );
  }

  Widget _deleteButton() {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete garment'),
                  content: const Text('Are you sure to delete this garment?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("No")),
                    TextButton(
                      onPressed: () => deleteBloc.add(
                          DeleteButtonPressed(garmentID: updateGarment.id!)),
                      child: Text("Yes"),
                    )
                  ],
                ));
      },
      icon: const Icon(Icons.remove, color: Color.fromARGB(255, 93, 63, 184)),
      label: const Text("Delete garment", style: TextStyle(color: Color.fromARGB(255, 93, 63, 184))),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
      )
    );
  }

  Widget _materialCustomization() {
    return Column(
      children: [
        Text(
          "Materials",
          style: TextStyle(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 70.0, right: 70.0, top: 10.0, bottom: 10.0),
          child: ElevatedButton(
            onPressed: () {
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
                    percentage: 0.0);
                materials.add(newRow);
                setState(() {});
              } else if (percentageSum == 200) {
                final snackBar =
                    SnackBar(content: Text("Please choose a material"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                final snackBar = SnackBar(
                    content:
                        Text("Percentage has exceed 100, cannot add anymore"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
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
                      initialValue: materials[index].percentage.toStringAsFixed(0),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        double newPercentage = double.tryParse(value) ?? 0.0;
                        if (newPercentage <= 100) {
                          setState(() {
                            materials[index].percentage = newPercentage;
                          });
                        }
                        if (newPercentage == 0.0) {
                          // final snackBar =
                          //     SnackBar(content: Text("Percentage cannot be 0"));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                        SnackBar sn =
                            SnackBar(content: Text("Unable to remove"));
                        ScaffoldMessenger.of(context).showSnackBar(sn);
                      }
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

  Widget _displayImage() {
    return Image.network(
      garmentImageURL!,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  Widget _displayMaterialImage() {
    return Image.network(
      materialImageURL!,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        percentageSum = 0.0;
        for (final m in materials) {
          percentageSum += m.percentage;
        }
        if (_formKey.currentState!.validate() &&
            _selectedCountry != ValueConstant.COUNTRY[0] &&
            _selectedBrand != ValueConstant.BRANDS_NAME[0] &&
            _selectedSize != ValueConstant.SIZES[0] &&
            _selectedColour != ValueConstant.COLOUR_NAME[0] &&
            percentageSum == 100) {
          String colorCode = updateGarment.colour;
    
          if (isChanged) {
            int index =
                ValueConstant.COLOUR_NAME.indexOf(_selectedColour!);
            colorCode = ValueConstant.COLOUR_CODE[index];
            // colour_name is changed, need to changed colour hexcode also
            // updateGarment.colour = ValueConstant.COLOUR_CODE[]
          }
          GarmentModel garmentObj = GarmentModel(
            id: updateGarment.id,
            country: _selectedCountry ?? '',
            brand: _selectedBrand ?? '',
            name: nameController.text.trim(),
            colour: colorCode,
            size: _selectedSize ?? '',
            colour_name: _selectedColour,
            status: true,
            materialList: materials,
          );
          updateBloc.add(UpdateButtonPressed(garment: garmentObj));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 93, 63, 184),
        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // side: BorderSide(color: Color.fromARGB(255, 93, 63, 184), width: 2)
      ),
      child: Text('Submit', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _nameTextField() {
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

  Widget _colourField() {
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
                isChanged = true;
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

  Widget _sizeField() {
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

  Widget _brandField() {
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

  Widget _countryField() {
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
}
