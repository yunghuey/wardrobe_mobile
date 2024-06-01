import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class IndividualBar{
  final int x; // position on x
  final double y;

  IndividualBar({ required this.x, required this.y });
}

class BarData{
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  BarData({required this.sunAmount, required this.monAmount,
  required this.tueAmount,required this.wedAmount,
  required this.thuAmount,required this.friAmount,required this.satAmount});

  List<IndividualBar> barData = [];

  void initalizeBarData(){
    barData = [
      IndividualBar(x: 0, y:sunAmount),
      IndividualBar(x: 0, y:monAmount),
      IndividualBar(x: 0, y:tueAmount),
      IndividualBar(x: 0, y:wedAmount),
      IndividualBar(x: 0, y:thuAmount),
      IndividualBar(x: 0, y:friAmount),
      IndividualBar(x: 0, y:satAmount),
    ];
  }
}
class _HomeViewState extends State<HomeView> {
  late DisplayAnalysisBloc analysisBloc;

  List<double> weeklySummary = [
    4.4,
    2.5,
    42.42,
    10.5,
    100.2,
    88.99,
    90.10
  ];


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
                  _displayBarChart(),
                ]
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _displayBarChart(){
      return Center(
        child: BarChart(
          BarChartData(maxY: 100, minY: 0),
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
        return Card(
          color: HexColor("#FFE6E6"),
          child: Center(child: Text("Fetching data...", style: TextStyle(fontSize: 18),),)
        );
      }
    );
  }
}