import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/UpdateGarment/updategarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/pages/RoutePage.dart';
import 'package:wardrobe_mobile/pages/garment/homeView.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';

class EditGarmentView extends StatefulWidget {
  final GarmentModel garment;
  
  const EditGarmentView({
    required this.garment,
    Key? key
  }):super(key:key);

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
  String? imageURL;
  bool isChanged = false;
  
  final loadingWidget = BlocBuilder<UpdateGarmentBloc, UpdateGarmentState>(
    builder: (context, state){
      if (state is UpdateGarmentLoading){
        return Center(child: CircularProgressIndicator());
      } else{
        return Container();
      }
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateBloc = BlocProvider.of<UpdateGarmentBloc>(context);
    updateGarment = widget.garment;
    nameController.text = updateGarment.name!;
    _selectedBrand = updateGarment.brand;
    _selectedColour = updateGarment.colour_name;
    _selectedCountry = updateGarment.country;
    _selectedSize = updateGarment.size;
    imageURL = updateGarment.imageURL;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit garment'),),
      body: BlocListener<UpdateGarmentBloc, UpdateGarmentState>(
        listener: (context, state){
          if (state is UpdateGarmentSuccess){
            const snackBar = SnackBar(content: Text('Updated successfully!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RoutePage(page: 1,)), (route) => false);
          }
          else if (state is UpdateGarmentFail){
            const snackBar = SnackBar(content: Text(''));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _displayImage(),
                _nameTextField(),
                _countryField(),
                _sizeField(),
                _brandField(),
                _colourField(),
                loadingWidget,
                _submitButton(),
                // future enhancement : add delete button here
            ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayImage(){
    return Image.network(
          imageURL!,
          width: 300,
          height:300,
          fit: BoxFit.cover,
        );
  }
  Widget _submitButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: (){
              if (_formKey.currentState!.validate() && _selectedCountry != ValueConstant.COUNTRY[0] 
                && _selectedBrand != ValueConstant.BRANDS_NAME[0] && _selectedSize != ValueConstant.SIZES[0] 
                && _selectedColour != ValueConstant.COLOUR_NAME[0]){
                  String colorCode = updateGarment.colour;

                  if (isChanged){
                    int index = ValueConstant.COLOUR_NAME.indexOf(_selectedColour!);
                    colorCode = ValueConstant.COLOUR_CODE[index];
                    // colour_name is changed, need to changed colour hexcode also
                    // updateGarment.colour = ValueConstant.COLOUR_CODE[]
                  }
                  GarmentModel garmentObj = GarmentModel(
                    id: updateGarment.id,
                    country: _selectedCountry ?? '', 
                    brand:_selectedBrand ?? '',
                    name: nameController.text.trim(),
                    colour: colorCode,
                    size: _selectedSize ?? '',
                    colour_name: _selectedColour,
                    status: true,
                  );
                  updateBloc.add(UpdateButtonPressed(garment: garmentObj));
            }
            },
            child: Text('Submit'),
          ),
        ],
      ),  
    );
  }

  Widget _nameTextField(){
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

  Widget _colourField(){
    return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Garment Colour:'), // Label
        DropdownButton<String>(
        value: _selectedColour,
        onChanged: (String? newValue){
          setState((){
            _selectedColour = newValue; 
            isChanged = true;
          });
        },
        items: ValueConstant.COLOUR_NAME.map<DropdownMenuItem<String>>((String value){
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
      ],
      ),
    );
  }

  Widget _sizeField(){
    return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }

  Widget _brandField(){
    return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
      ),
    );
  }

  Widget _countryField(){
  return Padding(
    padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Align children to the left
      children: [
        const Text('Garment Country:'), // Label
        DropdownButton<String>(
          value: _selectedCountry,
          onChanged: (String? newValue) {
            setState(() {
              _selectedCountry = newValue; // Corrected the variable name
            });
          },
          items: ValueConstant.COUNTRY.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ],
    ),
  );
}

}