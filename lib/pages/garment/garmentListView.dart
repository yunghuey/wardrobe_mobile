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

class GarmentListView extends StatefulWidget {
  const GarmentListView({super.key});

  @override
  State<GarmentListView> createState() => _GarmentListViewState();
}

class _GarmentListViewState extends State<GarmentListView> {
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
      appBar: AppBar(title: Text('Garment List')),
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

  Color getTextColor(String hexColor) {
    // print(hexColor);
    int colorValue = int.parse(hexColor.replaceAll('#', ''), radix: 16);
    // If the color value is less than the threshold, return white; otherwise, return black.
    return colorValue < 0x666666 ? Colors.white : Colors.black;
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
                  elevation: 5,
                  color: HexColor(garment.colour),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(garment.name!, style: TextStyle(
                          color: getTextColor(garment.colour),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          ),
                        ),
                        Text(garment.brand, style: TextStyle(color: getTextColor(garment.colour)),),
                        SizedBox(height: 5,),
                        Text(garment.country, style: TextStyle(color: getTextColor(garment.colour)),),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: (){
                                showDialog(
                                  context: context, 
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Delete garment'),
                                    content: const Text('Are you sure to delete this garment?'),
                                    actions: [
                                      TextButton(onPressed:() => Navigator.pop(context), child: Text("No")),
                                      TextButton(onPressed: () =>deleteBloc.add(DeleteButtonPressed(garmentID:garment.id!)), child: Text("Yes"),)
                                    ],
                                  ) 
                                );
                              }, 
                              icon: const Icon(Icons.remove), 
                              label: const Text("Delete"),
                            ),
                            SizedBox(width: 8,),
                            ElevatedButton.icon(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewGarmentDetails(garmentID: garment.id!)));
                              }, 
                              icon: const Icon(Icons.details), 
                              label: const Text("View"),
                            ),
                          ],
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