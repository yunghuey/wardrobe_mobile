import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/piechart_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/piechart_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/piechart_state.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/totalgarment_state.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_bloc.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_event.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_state.dart';
import 'package:wardrobe_mobile/model/barchart.dart';
import 'package:wardrobe_mobile/model/piechart.dart';
import 'package:wardrobe_mobile/pages/garment/mapView.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

enum TitleType {
  brand,
  country,
  colour,
  size,
}

class _HomeViewState extends State<HomeView> {
  late DisplayAnalysisBloc analysisBloc;
  late TotalGarmentBloc displaytotalBloc;
  late PieChartBloc pieBloc;
  late GetWeatherBloc weatherBloc;

  // location
  double lat = 0.0, long = 0.0;

  // group button
  int selectedIndex = 1;
  final List<bool> isSelected = [true, false, false, false];

  // dropdown button
  List<String> dropdownItem = [];
  String dropdownValue = "";
  bool userClicked = false;
  String category = 'brand';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analysisBloc = BlocProvider.of<DisplayAnalysisBloc>(context);
    displaytotalBloc = BlocProvider.of<TotalGarmentBloc>(context);
    pieBloc = BlocProvider.of<PieChartBloc>(context);
    weatherBloc = BlocProvider.of<GetWeatherBloc>(context);
    refreshPage();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
  
  Future<void> _setInitialLocation() async {
    Position position = await determinePosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    weatherBloc.add(FindWeatherPressed(long: long, lat: lat));
  }

  Future<void> refreshPage() async {
    displaytotalBloc.add(GetTotalEvent());
    pieBloc.add(PieChartReset());
    if (category == "brand"){
      analysisBloc.add(GetBrandAnalysisEvent());
    }
    else if (category == "country"){
      analysisBloc.add(GetCountryAnalysisEvent());
    }
    else if (category == "colour"){
      analysisBloc.add(GetColourAnalysisEvent());
    }
    else if (category == "size"){
      analysisBloc.add(GetSizeAnalysisEvent());
    }
    await _setInitialLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: RefreshIndicator(
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // total garment
                        BlocBuilder<TotalGarmentBloc, TotalGarmentState>(
                            builder: (context, state) {
                          if (state is FailGarmentAnalysis) {
                            return Center(child: Text(state.message));
                          } else if (state is TotalGarmentAnalysis) {
                            return _displayGarmentNumber(state.numberOfGarment);
                          }
                          return _displayFetchData();
                        }),
                        // get user location
                        _getCurrentLocation(),
                      ],
                    ),
                  ),
                  Card(
                    color: HexColor("#C3EEFA"),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocBuilder<GetWeatherBloc, GetWeatherState>(builder:(context, state){
                        if (state is GetWeatherInitState){
                          return Center(child: Text('Enable location to view'),);
                        }
                        else if (state is GetWeatherSuccess){
                          var textstyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Row(
                                children: [
                                  Text("${state.weather.weatherday!}  ", style: textstyle,),
                                  Text(state.weather.description!),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Temperature  ", style: textstyle,),
                                  Text("${state.weather.currentTemperature!.toStringAsFixed(1)}°C"),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Humidity  ", style: textstyle,),
                                  Text("${state.weather.humidityTemperature!.toStringAsFixed(1)}°C"),
                                ],
                              ),
                                                  
                            ],),
                          );
                        }
                        else if (state is GetWeatherFail){
                          return Text(state.message);
                        }
                        else if (state is GettingWeatherState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return Container();
                      }),
                    ),
                  ),
                  BlocBuilder<DisplayAnalysisBloc, DisplayAnalysisState>(
                    builder: (context, state) {
                      if (state is DataAndNumberBarChart) {
                        // List<BarChartModel> brand = state.data;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Card(
                            color: HexColor("#f9e8f4"),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                _buttonGroupCategory(),
                                const SizedBox(height: 10),
                                Text("Total number of garment by $category", style: TextStyle(fontWeight: FontWeight.bold)),
                                _barChartDiagram(state.y, state.data),
                                const SizedBox(height: 10),
                                _displayDropDown(state),
                              ],
                            ),
                          ),
                        );
                      } else if (state is DataAndNumberError) {
                        return Center(
                          child: Text(state.message),
                        );
                      } else if (state is FetchingAnaDataState) {
                        // return _displayFetchData();
                        return Container();
                      } else if (state is DataAndNumberEmpty) {
                        return const Center(
                          child: Text("No result can be shown"),
                        );
                      }
                      return _displayFetchData();
                    },
                  ),
                  BlocBuilder<PieChartBloc, DisplayPieChartState>(builder: (context, state){
                    if (state is PieChartInitState){
                      getPieEvent(category, dropdownValue);
                      return Center(child: CircularProgressIndicator(),);
                    }
                    else if (state is FetchingPieData){
                      return _displayFetchData();
                    }
                    else if (state is PieChartDataState){
                      return _pieChartDiagram(state);
                    }
                    else if (state is PieChartEmpty){
                      return Text("${category}, ${dropdownValue}, ${userClicked}");
                    }
                    else if (state is PieChartError){
                      return Text("${category}, ${dropdownValue}, ${userClicked}, ${state.error}");
                    }
                    return Text(state.toString());
                  }),
                ]),
              ),
            )),
      ),
    );
  }

  Widget _barChartDiagram(double y, List<BarChartModel> data) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: false),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (BarChartGroupData group) => HexColor("#dfaf37"),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toStringAsFixed(0),
                  TextStyle(
                    color: HexColor("#572a66"), 
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: false,
              )),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (category) {
                    case "brand":
                      return getBrandTitles(value, meta);
                    case "country":
                      return getCountryTitles(value, meta);
                    case "colour":
                      return getColourTitles(value, meta);
                    case "size":
                      return getSizeTitles(value, meta);
                    default:
                      return Container(); // Return an empty container if category is unknown
                  }
                },
                reservedSize: 130,
              )),
            ),
            minY: 0,
            maxY: y + 1,
            barGroups: data
                .map((data) => BarChartGroupData(
                      x: data.code,
                      barRods: [
                        BarChartRodData(
                            toY: data.numberOfGarment.toDouble(),
                            color: HexColor("#572a66"),
                            width: 18,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: y + 1,
                              color: HexColor("#dfaf37"),
                            ))
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buttonGroupCategory() {
    return ToggleButtons(
      borderColor: Color.fromARGB(255, 70, 32, 139),
      fillColor: Color.fromARGB(255, 93, 63, 184),
      borderWidth: 1,
      selectedBorderColor: Color.fromARGB(255, 103, 24, 230),
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            if (i == index) {
              isSelected[i] = true;
            } else {
              isSelected[i] = false;
            }
            pieBloc.add(PieChartReset());
          }
        }); // end of setstate
        //  reset chart
        userClicked = false;
        dropdownItem = [];
        dropdownValue = "";
        category = 'brand';
        switch (index) {
          case 0:
            analysisBloc.add(GetBrandAnalysisEvent());
            break;
          case 1:
            analysisBloc.add(GetCountryAnalysisEvent());
            category = 'country';
            break;
          case 2:
            analysisBloc.add(GetColourAnalysisEvent());
            category = 'colour';
            break;
          case 3:
            analysisBloc.add(GetSizeAnalysisEvent());
            category = 'size';
            break;
          default:
            analysisBloc.add(GetBrandAnalysisEvent());
            break;
        }
      },
      isSelected: isSelected,
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

  Widget _displayFetchData() {
    return Card(
        color: HexColor("#FFE6E6"),
        child: const Center(
          child: Text(
            "Fetching data...",
            style: TextStyle(fontSize: 18),
          ),
        ));
  }

  Widget _displayGarmentNumber(int numberOfGarment) {
    return Card(
      color: HexColor("#f0dbf7"),
      child: Column(children: [
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
        Text(
          numberOfGarment.toString(),
        )
      ]),
    );
  }

  Widget _pieChartDiagram(PieChartDataState state) {
        return Column(
          children: [
            Center(
                child: Text(
              state.pie1Type,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 60,
                sections: state.pie1
                    .asMap()
                    .map<int, PieChartSectionData>((index, data) {
                      final value = PieChartSectionData(
                        color: data.color,
                        value: data.percent,
                        title: data.totalNumber.toString(),
                        showTitle: true,
                      );
                      return MapEntry(index, value);
                    })
                    .values
                    .toList(),
              )),
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              state.pie2Type,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                borderData: FlBorderData(show: false),
                sections: state.pie2
                    .asMap()
                    .map<int, PieChartSectionData>((index, data) {
                      final value = PieChartSectionData(
                        color: data.color,
                        value: data.percent,
                        title: data.name,
                      );
                      return MapEntry(index, value);
                    })
                    .values
                    .toList(),
              )),
            ),
            SizedBox(height: 20),
            Center(
                child: Text(
              state.pie3Type,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 200,
              child: PieChart(PieChartData(
                borderData: FlBorderData(show: false),
                sections: state.pie3
                    .asMap()
                    .map<int, PieChartSectionData>((index, data) {
                      final value = PieChartSectionData(
                        color: data.color,
                        value: data.percent,
                        title: data.name,
                      );
                      return MapEntry(index, value);
                    })
                    .values
                    .toList(),
              )),
            ),
          ],
        );
  }

  Widget _getCurrentLocation() {
    var headingtext =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    return Card(
      color: HexColor("#F1B2AE"),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Text(
              "My Location",
              style: headingtext,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapScreen()))
                      .then((result) => {
                            if (result != null)
                              {
                                setState(() {
                                  lat = result['lat'];
                                  long = result['lng'];
                                }),
                                weatherBloc.add(FindWeatherPressed(long: long, lat: lat)),
                              }
                          });
                },
                child: Text("get")),
            Text("Lat: ${lat.toString()}"),
            Text("Long: ${long.toString()}"),
          ],
        ),
      ),
    );
  }

  Future<void> getPieEvent(String category, String dropdownvalue) async {
    if (dropdownvalue.isNotEmpty){
      pieBloc.add(PieChartReset());
      if (category == "brand") {
        pieBloc.add(BrandPieChart(brandname: dropdownValue));
      } else if (category == "country") {
        pieBloc.add(CountryPieChart(countryname: dropdownValue));
      } else if (category == "colour") {
        pieBloc.add(ColourPieChart(colourname: dropdownValue));
      } else if (category == "size") {
        pieBloc.add(SizePieChart(sizename: dropdownValue));
      }
    }
  }

  Future<void> loadData(DisplayAnalysisState state) async {
    if (!userClicked) {
      dropdownItem = [];
      var data;
      if (state is DataAndNumberBarChart) data = state.data;

      for (final b in data) {
        dropdownItem.add(b.name);
      }
      if (dropdownValue.isEmpty && dropdownItem.isNotEmpty) {
        dropdownValue = dropdownItem.first;
      }
      // Trigger event of pie chart
      print("loaddata ${category}, ${dropdownValue}");
      await getPieEvent(category, dropdownValue);
    }
  }

  Widget _displayDropDown(DisplayAnalysisState state) {
    loadData(state);
    return Center(
      child: DropdownButton(
        value: dropdownValue,
        items: dropdownItem.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            userClicked = true;
            print("The category is $category and value is $dropdownValue");
            // Call the event for pie chart
            getPieEvent(category, dropdownValue);
          });
        },
      ),
    );
  }

  Widget getCountryTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns:
            3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.COUNTRY[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget getColourTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns:
            3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.COLOUR_NAME[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget getBrandTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns:
            3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.BRANDS_NAME[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }

  Widget getSizeTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: HexColor("#655e67"),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: RotatedBox(
        quarterTurns:
            3, // Rotate the text 270 degrees (90 degrees counter-clockwise)
        child: Text(
          ValueConstant.SIZES[value.toInt()],
          style: style,
          textAlign: TextAlign.center, // Center the text vertically
        ),
      ),
    );
  }
}
