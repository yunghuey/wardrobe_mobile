import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_event.dart';
import 'package:wardrobe_mobile/bloc/garment/ReadGarment/readgarment_state.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/pages/garment/detectGarmentView.dart';
import 'package:wardrobe_mobile/pages/garment/viewGarmentDetails.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ReadGarmentBloc readBloc;
  late List<GarmentModel> garmentList;
  late DeleteGarmentBloc deleteBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readBloc = BlocProvider.of<ReadGarmentBloc>(context);
    deleteBloc = BlocProvider.of<DeleteGarmentBloc>(context);
    refreshPage();
  }
  
  Future<void> refreshPage() async {
    readBloc.add(GetAllGarmentEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('homepage')),
      body: 
      MultiBlocListener(
        listeners: [
          BlocListener<DeleteGarmentBloc, DeleteGarmentState>(
            listener: (context, state){
              if (state is DeleteGarmentSuccess){
                final snackBar = SnackBar(content: Text('garment deleted'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                refreshPage();
              }
              else if (state is DeleteGarmentFail){
                final snackbar = SnackBar(content: Text(state.message));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            }
          ),
        ],
        child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          child: _garmentList(),
          ),
        ),
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  
  Widget _garmentList(){
    return BlocBuilder<ReadGarmentBloc, ReadGarmentState>(
      builder: (context, state) {
        if (state is ReadAllGarmentLoading){
          return Center(
                child: CircularProgressIndicator(),
              );
        } else if (state is ReadAllGarmentSuccess){
          garmentList = state.garmentss;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount:  garmentList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                final garment = garmentList[index];
                return Card(
                  color: HexColor(garment.colour),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Brand: ${garment.brand}"),
                        Text("Size: ${garment.size}"),
                        Text("Name: ${garment.name!}"),
                        // Text("Id: ${garment.id!}"),
                        // Text("Color: ${garment.colour}"),
                        // Text("Status: ${garment.status}"),
                        // Image.network(garment.imageURL!),
                        // Text("Image: ${garment.imageURL!}"),
                        // Text("Country: ${garment.country}"),
                        // Text("Created date:${garment.created_date}"),
                        ElevatedButton.icon(
                          onPressed: (){
                            deleteBloc.add(DeleteButtonPressed(garmentID:garment.id!));
                          }, 
                          icon: const Icon(Icons.remove), 
                          label: const Text("remove"),
                        ),
                        ElevatedButton.icon(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewGarmentDetails(garmentID: garment.id!)));
                          }, 
                          icon: const Icon(Icons.details), 
                          label: const Text("detail"),
                        ),

                      ],
                    ),
                  ),
                );
              },


            )
          );
        } else if (state is ReadAllGarmentEmpty){
          return RefreshIndicator(
            onRefresh: refreshPage,
            child: Stack(
              children: <Widget>[
                Text('no garment found'),
                ]
            )
          );
        } else {
          return Container(child: Text('empty thing'));
        }
      }
    );
  }

  Widget _floatingButton(){
    return FloatingActionButton(
      onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> CaptureImageView())),
      child: const Icon(Icons.add),
    );
  }

  
}