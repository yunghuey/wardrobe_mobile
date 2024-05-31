import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late DisplayAnalysisBloc analysisBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analysisBloc = BlocProvider.of<DisplayAnalysisBloc>(context);
    refreshPage();
  }

  Future<void> refreshPage() async {
    analysisBloc.add(GetTotalGarmentEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RefreshIndicator(
          onRefresh: refreshPage,
          child:  SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  // this row is to show the total garment and temperature
                  Row(children: [
                    _displayGarmentNumber(),
                  ],),
                  // this row is to show the statistic bar chart
                ]
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _displayGarmentNumber(){
    return BlocBuilder<DisplayAnalysisBloc,DisplayAnalysisState>(
      builder: (context,state){
        if (state is FailGarmentAnalysis){
          return Center(child: Text(state.message));
        }
        else if (state is DisplayGarmentAnalysis){
          return Card(
          
            color: HexColor("#FFE6E6"),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, color: Colors.red, size: 48),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Garment',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Text(state.numberOfGarment.toString(),)
              ]
            ),
          );
        }
        return Center(child: Text("Fetching data...", style: TextStyle(fontSize: 18),),);
      }
    );
  }
}