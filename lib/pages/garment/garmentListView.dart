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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readBloc = BlocProvider.of<ReadGarmentBloc>(context);
    refreshPage();
  }

  Future<void> refreshPage() async {
    readBloc.add(GetAllGarmentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Garment List')),
      body: Stack(
        children: [
          _garmentList(),
        ],
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

  Widget _garmentList() {
    return BlocBuilder<ReadGarmentBloc, ReadGarmentState>(
        builder: (context, state) {
      if (state is ReadAllGarmentLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is ReadAllGarmentSuccess) {
        garmentList = state.garmentss;
        return RefreshIndicator(
          onRefresh: refreshPage,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: garmentList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final garment = garmentList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewGarmentDetails(garmentID: garment.id!)));
                    },
                    child: Card(
                      elevation: 5,
                      color: HexColor(garment.colour),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Your existing column
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    garment.name!,
                                    style: TextStyle(
                                      color: getTextColor(garment.colour),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    garment.brand,
                                    style: TextStyle(
                                        color: getTextColor(garment.colour)),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    garment.country,
                                    style: TextStyle(
                                        color: getTextColor(garment.colour)),
                                  ),
                                ],
                              ),
                            ),
                            // New Image widget
                            Image.network(
                              garment.garmentImageURL!, // Replace with your image URL
                              fit: BoxFit.cover,
                              height: 130.0, // You can adjust as needed
                              width: 130.0, // You can adjust as needed
                            ),
                          ],
                        ),
                      
                      ),
                    ),
                  );
                },
              )),
        );
      } else if (state is ReadAllGarmentEmpty) {
        return RefreshIndicator(
          onRefresh: refreshPage,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text('Oopsie, you have no garment yet',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(child: Text('empty thing'));
      }
    });
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => CaptureImageView())),
      child: const Icon(Icons.add),
    );
  }
}
