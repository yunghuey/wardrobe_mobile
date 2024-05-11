import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/pages/garment/EditGarmentView.dart';

class ViewGarmentDetails extends StatefulWidget {
  final String garmentID;
  const ViewGarmentDetails({ required this.garmentID, Key? key }):super(key: key);

  @override
  State<ViewGarmentDetails> createState() => _ViewGarmentDetailsState();
}

class _ViewGarmentDetailsState extends State<ViewGarmentDetails> {
  late ReadOneGarmentBloc readBloc;
  late GarmentModel garment;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readBloc = BlocProvider.of<ReadOneGarmentBloc>(context);
    readBloc.add(GetOneGarmentEvent(garmentID: widget.garmentID));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('one garment page'),
        actions: [
          BlocBuilder<ReadOneGarmentBloc, OneGarmentState>(
            builder: (context, state) {
              if (state is ReadOneGarmentSuccess) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> EditGarmentView(garment: garment)));
                  },
                  icon: const Icon(Icons.edit),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ReadOneGarmentBloc, OneGarmentState>(
              builder: (context, state){
                if (state is ReadOneGarmentSuccess){
                  garment = state.garment;
                  return _displayGarment();
                }
                else if (state is ReadOneGarmentError){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("garment error from server"),
                  );
                }
                else {
                  return Text("no state is given");
                }
              }),
          ],
        ),
      ),
    );
  }

  Widget _displayGarment(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        // display image
        Image.network(garment.imageURL!),
        Text("Brand: ${garment.brand}"),
        Text("Size: ${garment.size}"),
        Text("Name: ${garment.name!}"),
        Text("Id: ${garment.id!}"),
        Text("Color: ${garment.colour}"),
        Text("Color name: ${garment.colour_name}"),
        Text("Status: ${garment.status}"),
        Text("Image: ${garment.imageURL!}"),
        Text("Country: ${garment.country}"),
        Text("Created date:${garment.created_date}"),
      ]),
    );
  }
}