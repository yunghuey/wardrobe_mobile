import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/onegarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/material.dart';
import 'package:wardrobe_mobile/pages/garment/EditGarmentView.dart';
import 'package:intl/intl.dart';

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
    reloadpage();
  }

  Future<void> reloadpage() async {
    readBloc.add(GetOneGarmentEvent(garmentID: widget.garmentID));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information"),
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
      body: RefreshIndicator(
        onRefresh: reloadpage,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              BlocBuilder<ReadOneGarmentBloc, OneGarmentState>(
                builder: (context, state){
                  if (state is ReadOneGarmentSuccess){
                    garment = state.garment;
                    return _displayGarment();
                  }
                  else if (state is ReadOneGarmentError){
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("garment error from server"),
                    );
                  }
                  else {
                    return Center(child: const Text("Fetching data", style: TextStyle(fontSize: 17),));
                  }
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayGarment(){

    String? datestring = garment.created_date!;
    DateTime datetime = DateTime.parse(datestring);
    String formattedDate = DateFormat.yMMMMd().format(datetime);
    return Column(children: [
      // display image
      Center(child: Text("Garment Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
      Image.network(
        garment.garmentImageURL!,
        width: 300,
        height:300,
        fit: BoxFit.cover,
      ),
      SizedBox(height: 20,),
      Center(child: Text("Material Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),),
      Image.network(
        garment.materialImageURL!,
        width: 300,
        height:300,
        fit: BoxFit.cover,
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Name"),
          subtitle: Text(garment.name!),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Brand"),
          subtitle: Text(garment.brand),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Colour"),
          subtitle: Text(garment.colour_name!),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Size"),
          subtitle: Text(garment.size),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Country"),
          subtitle: Text(garment.country),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      Container(
        padding: const EdgeInsets.only(left: 12, right:12),
        child: ListTile(
          title: const Text("Registered date"),
          subtitle: Text(formattedDate),
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 12, right:12),
        child: Divider(),
      ),
      SizedBox(height: 20, child: Text("Materials"),),
      Padding(
        padding: const EdgeInsets.only(left:20),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: garment.materialList!.length,
          itemBuilder: (context, index) {
            MaterialModel m = garment.materialList![index];
            return Container(
              padding: const EdgeInsets.all(3),
              child: Text(
                "${m.materialName} contains ${m.percentage.toStringAsFixed(1)}%"
              ),
            );
          },
        ),
      ),
      SizedBox(height: 20,),
    ]);
  }
}