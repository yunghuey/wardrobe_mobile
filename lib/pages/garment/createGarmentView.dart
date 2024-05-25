import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';
import 'package:wardrobe_mobile/pages/ValueConstant.dart';

class CreateGarmentView extends StatefulWidget {
  final GarmentModel garment;
  final File image;

  const CreateGarmentView({
    required this.garment, 
    required this.image,
    Key? key
  }): super(key: key);

  @override
  State<CreateGarmentView> createState() => _CreateGarmentViewState();
}

class _CreateGarmentViewState extends State<CreateGarmentView> {
  late GarmentModel garmentResult;
  late File imageResult;
  final _formKey = GlobalKey<FormState>();
  late CreateGarmentBloc createBloc;

  bool colourChanged = false;

  String? _selectedCountry;
  String? _selectedSize;
  String? _selectedBrand;
  String? _selectedColour;
  late ValueNotifier<Color> _colorNotifier;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    garmentResult = widget.garment;
    imageResult = widget.image;
    createBloc =  BlocProvider.of<CreateGarmentBloc>(context);
    _selectedCountry = garmentResult.country;
    _selectedSize = garmentResult.size;
    _selectedBrand = garmentResult.brand;
    _selectedColour = garmentResult.colour_name;
    _colorNotifier = ValueNotifier<Color>(HexColor(garmentResult.colour));
  }

  @override
  Widget build(BuildContext context) {
    return
     BlocListener<CreateGarmentBloc, CreateGarmentState>(
      listener: (context, state) {
        if (state is CreateGarmentLoadingState){
          final snackBar = const SnackBar(content: Text("loading"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is CreateGarmentSuccessState){
          final snackBar = const SnackBar(content: Text("success"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
                fullscreenDialog: false,
              ),
              (route) => false,
            );
        } else if (state is CreateGarmentFailState){
          final snackBar = const SnackBar(content: Text("fail"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: 
      Scaffold(
        appBar: AppBar(title: const Text('Create garment form')),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _garmentImage(),
                  _garmentName(),
                  _garmentCountry(),
                  _garmentBrand(),
                  _garmentSize(),
                  _garmentColour(),
                  // _garmentColorCode(),
                  _garmentSubmit(),
                ]
              ),  
            ),
          ),
        ),
      ),
    );
  }
  
  // set default colorcode for color changed
  Widget _garmentColour(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Garment Colour:'), // Label
      DropdownButton<String>(
      value: _selectedColour,
      onChanged: (String? newValue){
        setState((){
          _selectedColour = newValue; 
          colourChanged = true;
        });
      },
      items: ValueConstant.COLOUR_NAME.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    ),
    ],
  ); 
  }

  Widget _garmentSubmit(){
    return ElevatedButton(
      onPressed: (){
        if(_formKey.currentState!.validate() && _selectedCountry != ValueConstant.COUNTRY[0] 
        && _selectedBrand != ValueConstant.BRANDS_NAME[0] && _selectedSize != ValueConstant.SIZES[0] && _selectedColour != ValueConstant.COLOUR_NAME[0]
        && nameController.text != ''){
          // is to check garment name
          String colorString = _colorNotifier.value.toString(); // Color(0xffcca2ae)
          String hexColor = '#${colorString.split('(0xff')[1].split(')')[0]}'; // cca2ae

          GarmentModel garmentObj = GarmentModel(
            brand:_selectedBrand ?? '',
            colour: hexColor,
            country:_selectedCountry ?? '',
            size: _selectedSize ?? '',
            colour_name: _selectedColour ?? 'WHITE',
            name:nameController.text.trim(),
            image: imageResult
          );

          createBloc.add(CreateButtonPressed(garment: garmentObj));
        } else{
          const snackBar = SnackBar(content: Text('form not complete'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        // image
      }, 
      child: const Text("submit"));
  }

   Widget _garmentColorCode(){
    // can make into InkWell to detect press and display showDialog
    return Padding(
      padding: const EdgeInsets.all(40),
      child: ValueListenableBuilder<Color>(
        valueListenable: _colorNotifier, 
        builder: (_, color, __){
          return ColorPicker(
            color: color,
            onChanged: (value) {
              _colorNotifier.value = value;
            },
          );
        }
      ),
    );
  }

Widget _garmentSize(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Garment Size:'), // Label
      DropdownButton<String>(
      value: _selectedSize,
      onChanged: (String? newValue){
        setState((){
          _selectedSize = newValue; // Corrected the variable name
        });
      },
      items: ValueConstant.SIZES.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    ),
    ],
  );
  }

  Widget _garmentBrand(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Garment Brand:'), // Label
      DropdownButton<String>(
      value: _selectedBrand,
      onChanged: (String? newValue){
        setState((){
          _selectedBrand = newValue; // Corrected the variable name
        });
      },
      items: ValueConstant.BRANDS_NAME.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    ),
    ],
  );

  }
  
  Widget _garmentCountry(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Garment Country:'), // Label
      DropdownButton<String>(
      value: _selectedCountry,
      onChanged: (String? newValue){
        setState((){
          _selectedCountry = newValue; // Corrected the variable name
        });
      },
      items: ValueConstant.COUNTRY.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    ),
    ],
  );
  }

  Widget _garmentName(){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Garment Name',
          hintText: 'Enter garment name',
        ),
        
      ),
    );
  }

  Widget _garmentImage(){
    Uint8List bytes;
    try {
      bytes = imageResult.readAsBytesSync();
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