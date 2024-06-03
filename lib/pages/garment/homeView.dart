import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_state.dart';
import 'package:wardrobe_mobile/model/brand.dart';
import 'package:wardrobe_mobile/model/colour.dart';
import 'package:wardrobe_mobile/model/country.dart';
import 'package:wardrobe_mobile/model/size.dart';
import 'package:wardrobe_mobile/pages/garment/mapView.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late DisplayAnalysisBloc analysisBloc;
  late TotalGarmentBloc displaytotalBloc;

  // location
  double lat = 0.0, long = 0.0;

  // group button
  int selectedIndex = 1;
  final List<bool> isSelected = [true,false, false, false];

  // dropdown button
  // var dropdownItem = [];
  String dropdownValue = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analysisBloc = BlocProvider.of<DisplayAnalysisBloc>(context);
    displaytotalBloc = BlocProvider.of<TotalGarmentBloc>(context);
    refreshPage();
  }

  Future<void> refreshPage() async {
    displaytotalBloc.add(GetTotalEvent());
    analysisBloc.add(GetBrandAnalysisEvent());
    selectedIndex = 1;
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _displayGarmentNumber(),
                        _getCurrentLocation(),
                      // get location
                    ],),
                  ),
                  SizedBox(height: 50),
                  _displayGroupButton(),
                  SizedBox(height: 20),
                 SizedBox( 
                    height: 250,
                    child: _displayBarChart()
                  ),
                  _displayDropDown(),
                  // SizedBox(
                  //   height: 300,
                  //   child: _displayPie1(),
                  // ),
                ]
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _displayBarChart(){
    return BlocBuilder<DisplayAnalysisBloc,DisplayAnalysisState>(
      builder: (context, state){
          if (state is BrandAndNumberBarChart){
            List<BrandModel> brand = state.data;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: BarChart(
                BarChartData(
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles:SideTitles(
                    showTitles: true, 
                    getTitlesWidget: getBrandTitles,
                    reservedSize: 100,
                    )),
                ),
                minY: 0,
                maxY: state.y + 1,
                barGroups: brand.map((data)=> 
                  BarChartGroupData(
                    x: data.brandCode,
                    barRods: [BarChartRodData(
                      toY: data.numberOfGarment.toDouble(),
                      color: HexColor("#572a66"),
                      width: 18,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, 
                        toY: state.y + 1,
                        color: HexColor("#f0dbf7"),
                      )
                    )],
                  )
                ).toList(),
              ),
            ),
            );
          }
          else if (state is BrandAndNumberError){
            return Center(child: Text(state.message),);
          }
          else if (state is CountryAndNumberBarChart){
            List<CountryModel> country = state.data;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: BarChart(
                BarChartData(
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles:SideTitles(
                    showTitles: true, 
                    getTitlesWidget: getCountryTitles,
                    reservedSize: 120,
                    )),
                ),
                minY: 0,
                maxY: state.y + 1,
                barGroups: country.map((data)=> 
                  BarChartGroupData(
                    x: data.countryCode,
                    barRods: [BarChartRodData(
                      toY: data.numberOfGarment.toDouble(),
                      color: HexColor("#572a66"),
                      width: 18,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, 
                        toY: state.y + 1,
                        color: HexColor("#f0dbf7"),
                      )
                    )],
                  )
                ).toList(),
              ),
            ),
            );
          }
          else if (state is CountryAndNumberError){
            return Center(child: Text(state.message),);
          }
          else if (state is ColourAndNumberBarChart){
            List<ColourModel> colours = state.data;
            return Padding(
              padding: const EdgeInsets.all(5),
              child: BarChart(
                BarChartData(
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles:SideTitles(
                    showTitles: true, 
                    getTitlesWidget: getColourTitles,
                    reservedSize: 100,
                    )),
                ),
                minY: 0,
                maxY: state.y + 1,
                barGroups: colours.map((data)=> 
                  BarChartGroupData(
                    x: data.colourCode,
                    barRods: [BarChartRodData(
                      toY: data.numberOfGarment.toDouble(),
                      color: HexColor("#572a66"),
                      width: 18,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, 
                        toY: state.y + 1,
                        color: HexColor("#f0dbf7"),
                      )
                    )],
                  )
                ).toList(),
              ),
            ),
            );
          }
          else if (state is ColourAndNumberError){
            return Center(child: Text(state.message),);
          }
          else if (state is SizeAndNumberBarChart){
            List<SizeModel> sizes = state.data; 

            return Padding(
              padding: const EdgeInsets.all(5),
              child: BarChart(
                BarChartData(
                gridData: const FlGridData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                ),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles:SideTitles(
                    showTitles: true, 
                    getTitlesWidget: getSizeTitles,
                    reservedSize: 60,
                    )),
                ),
                minY: 0,
                maxY: state.y + 1,
                barGroups: sizes.map((data)=> 
                  BarChartGroupData(
                    x: data.sizeCode,
                    barRods: [BarChartRodData(
                      toY: data.numberOfGarment.toDouble(),
                      color: HexColor("#572a66"),
                      width: 18,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true, 
                        toY: state.y + 1,
                        color: HexColor("#f0dbf7"),
                      )
                    )],
                  )
                ).toList(),
              ),
            ),
            );
          }
          else if (state is SizeAndNumberError){
            return Center(child: Text(state.message),);
          }
          else if (state is FetchingAnaDataState){
            return Center(child: CircularProgressIndicator(),);
          }
          
          return Container(child: Text("Fetching data"),);
      },
    );
  }

  Widget _displayPie1(){
    return PieChart(PieChartData());
  }
  
  Widget _getCurrentLocation(){
    return Card(
      color: HexColor("#F1B2AE"),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MapScreen()))
                .then((result)=> {
                  if (result != null){
                  setState(() {
                    
                    lat = result['lat'];
                    long = result['lng'];
                  })
                  }
                });
              }, child: Text("get")
            ),
            Text("Lat: ${lat.toString()}"),
            Text("Long: ${long.toString()}"),
          ],
        ),
      ),
    );
  }

  Widget _displayDropDown(){
    return BlocBuilder<DisplayAnalysisBloc, DisplayAnalysisState>(
      builder: (context, state){
        if (state is BrandAndNumberBarChart || state is CountryAndNumberBarChart || state is ColourAndNumberBarChart || state is SizeAndNumberBarChart){
          List<String> dropdownItem = [];
          dropdownValue = "";
          // dropdownItem.clear();
          var data;
          if (state is BrandAndNumberBarChart){
            data = state.data;
          }
          else if (state is CountryAndNumberBarChart){
            data = state.data;
          }
          else if (state is ColourAndNumberBarChart){
            data = state.data;
          }
          else if (state is SizeAndNumberBarChart){
            data = state.data;
          }

          for (final b in data){
            dropdownItem.add(b.name);
          }
          if (dropdownValue.isEmpty && dropdownItem.isNotEmpty) {
            dropdownValue = dropdownItem.first;
          }
         return Center(
            child: DropdownButton(
              value: dropdownValue,
              items: dropdownItem.map((String items){
        return DropdownMenuItem(value:items, child: Text(items),);
      }).toList(), 
              onChanged: (String? newvalue){
                setState(() {
                  dropdownValue = newvalue!;
                });
                print(dropdownValue);
              }
            ),
          );
         
          // return Text("inside if statmeent");
        }
        return Container(child: CircularProgressIndicator(),);
      }
    );
  }

  // Widget _displayDropDown(){
  //   String dropdownvalue1 = 'Item 1';    
  
  // // List of items in our dropdown menu 
  // var items = [     
  //   'Item 1', 
  //   'Item 2', 
  //   'Item 3', 
  //   'Item 4', 
  //   'Item 5', 
  // ]; 
  //   return DropdownButton(
  //     value: dropdownvalue1,
  //     items: items.map((String items){
  //       return DropdownMenuItem(value:items, child: Text(items),);
  //     }).toList(), 
  //     onChanged: (String? newValue) {  
  //               setState(() { 
  //                 dropdownvalue1 = newValue!; 
  //               }); 
  //             }, 
  //   );


  // }
  Widget _displayGroupButton(){
    return ToggleButtons(
      borderColor: Color.fromARGB(255, 70, 32, 139),
      fillColor: Color.fromARGB(255, 93, 63, 184),
      borderWidth: 1,
      selectedBorderColor: Color.fromARGB(255, 103, 24, 230),
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      onPressed:(int index){
        print("Index clicked is${index}");
        setState(() {
          for (int i =0; i< isSelected.length; i++){
            if (i == index){
              isSelected[i] = true;
            } else{
              isSelected[i] = false;
            }
          }
         });
        //  trigger event based on 
        switch(index){
          case 0:
            analysisBloc.add(GetBrandAnalysisEvent());
            break;
          case 1:
            analysisBloc.add(GetCountryAnalysisEvent());
            break;
          case 2:
            analysisBloc.add(GetColourAnalysisEvent());
            break;
          case 3:
            analysisBloc.add(GetSizeAnalysisEvent());
            break;
          default:
            analysisBloc.add(GetBrandAnalysisEvent());
            break;
        }
       },
      isSelected :isSelected,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Brands'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Country'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Colour'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Size'),
        ),
      ],
     );
   }  
  }

 
  Widget getBrandTitles(double value, TitleMeta meta){
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
    axisSide: meta.axisSide,
    child: RotatedBox(
      quarterTurns: 3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
      child: Text(
        ValueConstant.BRANDS_NAME[value.toInt()],
        style: style,
        textAlign: TextAlign.center, // Center the text vertically
      ),
    ),
  );
  }

  Widget getCountryTitles(double value, TitleMeta meta){
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns: 3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.COUNTRY[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget getColourTitles(double value, TitleMeta meta){
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns: 3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.COLOUR_NAME[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget getSizeTitles(double value, TitleMeta meta){
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns: 3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.SIZES[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget _displayGarmentNumber(){
    return BlocBuilder<TotalGarmentBloc,TotalGarmentState>(
      builder: (context,state){
        if (state is FailGarmentAnalysis){
          return Center(child: Text(state.message));
        }
        else if (state is TotalGarmentAnalysis){
          return Card(
            color: HexColor("#f0dbf7"),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, color: Colors.red, size: 48),
                ),
                const Padding(
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
          child: const Center(child: Text("Fetching data...", style: TextStyle(fontSize: 18),),)
        );
      }
    );
  }
