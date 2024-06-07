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
import 'package:wardrobe_mobile/bloc/recommendation/recommend_bloc.dart';
import 'package:wardrobe_mobile/bloc/recommendation/recommend_event.dart';
import 'package:wardrobe_mobile/bloc/recommendation/recommend_state.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_bloc.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_event.dart';
import 'package:wardrobe_mobile/bloc/weather/getWeather_state.dart';
import 'package:wardrobe_mobile/model/barchart.dart';
import 'package:wardrobe_mobile/model/garment.dart';
import 'package:wardrobe_mobile/model/piechart.dart';
import 'package:wardrobe_mobile/pages/garment/mapView.dart';
import 'package:wardrobe_mobile/pages/garment/viewGarmentDetails.dart';
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
  late RecommendationBloc recommendBloc;

  // location
  double lat = 0.0, long = 0.0;
  String area = "";

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
    recommendBloc = BlocProvider.of<RecommendationBloc>(context);

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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
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
    if (category == "brand") {
      analysisBloc.add(GetBrandAnalysisEvent());
    } else if (category == "country") {
      analysisBloc.add(GetCountryAnalysisEvent());
    } else if (category == "colour") {
      analysisBloc.add(GetColourAnalysisEvent());
    } else if (category == "size") {
      analysisBloc.add(GetSizeAnalysisEvent());
    }
    // weather bloc & recommend bloc
    await _setInitialLocation();
    recommendBloc.add(GetRecommendationEvent(lat: lat, long: long));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home page')),
      body: Padding(
        padding: EdgeInsets.all(2.0),
        child: RefreshIndicator(
            onRefresh: refreshPage,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(5),
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
                        // _getCurrentLocation(),
                        _getCurrentTemp(),
                      ],
                    ),
                  ),
                  // recommend clothes
                  Card(
                    elevation: 4,
                    // color: HexColor("#C3EBCA"),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          BlocBuilder<RecommendationBloc, RecommendationState>(
                              builder: (context, state) {
                        if (state is RecommendationEmpty) {
                          return const Center(child: Text('No suitable recommendation '),);
                        } else if (state is RecommendationSuccess) {
                          return Column(
                            children: [
                              const Text("Recommendation", style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF46208B),
                              ),),
                              Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.garmentList.length,
                                      itemBuilder: (context, index) {
                                        GarmentModel m =
                                            state.garmentList[index];
                                        return InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewGarmentDetails(
                                                              garmentID:
                                                                  m.id!)));
                                            },
                                            child: ListTile(
                                              title: Text(m.name!, style: TextStyle(fontSize: 17),),
                                              subtitle: Text(
                                                  "${m.colour_name} in colour, ${m.brand} brand"),
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                            ));
                                      })),
                            ],
                          );
                        } else if (state is RecommendationError) {
                          return Text(state.message);
                        } else if (state is GetRecommendationLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Center(child: Text("Enable location for the result"));
                      }),
                    ),
                  ),
                  // barchart
                  BlocBuilder<DisplayAnalysisBloc, DisplayAnalysisState>(
                    builder: (context, state) {
                      if (state is DataAndNumberBarChart) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Card(
                            elevation: 0,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                _buttonGroupCategory(),
                                const SizedBox(height: 10),
                                Text("Total number of garment by $category",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
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
                        return Card(
                          color: HexColor("#f9e8f4"),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Center(
                              child:
                                  Text("No insights of garment can be shown"),
                            ),
                          ),
                        );
                      }
                      return _displayFetchData();
                    },
                  ),
                  BlocBuilder<PieChartBloc, DisplayPieChartState>(
                      builder: (context, state) {
                    if (state is PieChartInitState) {
                      getPieEvent(category, dropdownValue);
                      return Container();
                    } else if (state is FetchingPieData) {
                      return _displayFetchData();
                    } else if (state is PieChartDataState) {
                      return _pieChartDiagram(state);
                    } else if (state is PieChartEmpty) {
                      return Text("No result can be shown");
                    } else if (state is PieChartError) {
                      return Text("${state.error}");
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
                getTooltipColor: (BarChartGroupData group) =>
                    HexColor("#dfaf37"),
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
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
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
        }); // end of setstate
        //  reset chart
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
    return const Card(
        child: const Center(
          child: Text(
            "Fetching data...",
            style: TextStyle(fontSize: 18),
          ),
        ));
  }

  Widget _displayGarmentNumber(int numberOfGarment) {
    return SizedBox(
      width: 170,
      height: 125,
      child: Card(
        // color: HexColor("#f0dbf7"),
        child: Column(children: [
          SizedBox(height: 10),
          Text(
            numberOfGarment.toString(),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, 
            //color:Color.fromARGB(255, 103, 24, 230), 
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              'Total Garment',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ]),
      ),
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
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: state.pie1
                .asMap()
                .map<int, PieChartSectionData>((index, data) {

                  final isTouched = index == 18; // To highlight the touched section
                  final double fontSize = isTouched ? 18 : 14; // Increase font size for touched section
                  final double radius = isTouched ? 60 : 50; // Increase radius for touched section
                  final Color color = isTouched ? Colors.blue : data.color; // Change color for touched section
                  final value = PieChartSectionData(
                    color: data.color,
                    value: data.percent,
                    title: data.name,
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(data.color.toString())
                    ),
                    showTitle: true,
                  );
                  return MapEntry(index, value);
                })
                .values
                .toList(),
          ),
          swapAnimationDuration: Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeInOut,
          ),
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
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: state.pie2
                .asMap()
                .map<int, PieChartSectionData>((index, data) {

                  final isTouched = index == 18; // To highlight the touched section
                  final double fontSize = isTouched ? 18 : 14; // Increase font size for touched section
                  final double radius = isTouched ? 60 : 50; // Increase radius for touched section
                  final Color color = isTouched ? Colors.blue : data.color; // Change color for touched section
                  final value = PieChartSectionData(
                    color: data.color,
                    value: data.percent,
                    title: data.name,
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: getTextColor(data.color.toString()),
                    ),
                    showTitle: true,
                  );
                  return MapEntry(index, value);
                })
                .values
                .toList(),
          ),
          swapAnimationDuration: Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeInOut,
          ),
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
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: state.pie3
                .asMap()
                .map<int, PieChartSectionData>((index, data) {

                  final isTouched = index == 18; // To highlight the touched section
                  final double fontSize = isTouched ? 18 : 14; // Increase font size for touched section
                  final double radius = isTouched ? 60 : 50; // Increase radius for touched section
                  final Color color = isTouched ? Colors.blue : data.color; // Change color for touched section
                  final value = PieChartSectionData(
                    color: data.color,
                    value: data.percent,
                    title: data.name,
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color:getTextColor(data.color.toString()),
                    ),
                    showTitle: true,
                  );
                  return MapEntry(index, value);
                })
                .values
                .toList(),
          ),
          swapAnimationDuration: Duration(milliseconds: 800),
          swapAnimationCurve: Curves.easeInOut,
          ),
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
                  _toMapScreen();
                },
                child: Text("Update")),
            Text("area ${area}"),
          ],
        ),
      ),
    );
  }

  Widget _getCurrentTemp() {
    var headingtext =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return SizedBox(
      width: 170,
      height: 125,
      child: Card(
        // color: HexColor("#efd0ff"),
        child: BlocBuilder<GetWeatherBloc, GetWeatherState>(
          builder: (context, state){
            if (state is GetWeatherSuccess) {
              return InkWell(
                onTap: (){
                  showDialog(context: context, 
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text(state.weather.weatherday!),
                      content: Text("Today is ${state.weather.description}, it's feels like ${state.weather.humidityTemperature}°C",
                      style: TextStyle(fontSize: 15)),
                      actions: [
                        TextButton(onPressed: ()=> Navigator.pop(context), child: Text("Alright!"))
                      ],
                    );
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Center(child: Text('Now'),),
                  Center(
                    child: Text("${state.weather.currentTemperature!.toStringAsFixed(1)}°C", 
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),)
                  ),
                ],),
              );
            }
            return Container(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Enable location for weather result')),
            ),);
          },

        ),
        )
    ,);
    
    

  }

  void _toMapScreen() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => MapScreen()))
        .then((result) => {
              if (result != null)
                {
                  setState(() {
                    lat = result['lat'];
                    long = result['lng'];
                    area = result['address'];
                  }),
                  weatherBloc.add(FindWeatherPressed(long: long, lat: lat)),
                }
            });
  }

  Future<void> getPieEvent(String category, String dropdownvalue) async {
    if (dropdownvalue.isNotEmpty) {
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

    Color getTextColor(String hexColor) {

    // print(hexColor);
    // String hexValue = hexColor.split('(0x')[1].split(')')[0];
  // Parse the hexadecimal string as an integer
  // int colorValue = int.parse(hexValue, radix: 16);
  // If the color value is less than the threshold, return white; otherwise, return black.
  // return colorValue <  0xffAAAAAA ? Colors.white : Colors.black;
  return Colors.black;
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
