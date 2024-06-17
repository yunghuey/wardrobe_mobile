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
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/CreateGarment/creategarment_state.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_bloc.dart';
import 'package:wardrobe_mobile/bloc/garment/DeleteGarment/deletegarment_state.dart';
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
  late DeleteGarmentBloc deleteBloc;
  late CreateGarmentBloc createBloc;

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

  // pie chart
  int touchedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analysisBloc = BlocProvider.of<DisplayAnalysisBloc>(context);
    displaytotalBloc = BlocProvider.of<TotalGarmentBloc>(context);
    pieBloc = BlocProvider.of<PieChartBloc>(context);
    weatherBloc = BlocProvider.of<GetWeatherBloc>(context);
    recommendBloc = BlocProvider.of<RecommendationBloc>(context);
    deleteBloc = BlocProvider.of<DeleteGarmentBloc>(context);
    createBloc = BlocProvider.of<CreateGarmentBloc>(context);

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<DeleteGarmentBloc, DeleteGarmentState>(listener: (context, state){
            if (state is DeleteGarmentSuccess){
              refreshPage();
              }
          }),
          BlocListener<CreateGarmentBloc, CreateGarmentState>(
            listener: (context, state) {
              if (state is CreateGarmentSuccessState) {
                refreshPage();
              }

            })
        ],
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: RefreshIndicator(
              onRefresh: refreshPage,
              child: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(children: <Widget>[
                    Row(
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
                        _getCurrentTemp(),
                      ],
                    ),
                    // recommend clothes
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
                            // color: HexColor("#f9e8f4"),
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
                        return Column(
                          children: [
                            Text(state.pie1Type),
                            _smallBarChartDiagram(
                                state.y + 1, state.pie1, state.pie1Type),
                            SizedBox(height: 10),
                            Text(state.pie2Type),
                            _smallBarChartDiagram(
                                state.y + 1, state.pie2, state.pie2Type),
                            SizedBox(height: 10),
                            Text(state.pie3Type),
                            _smallBarChartDiagram(
                                state.y + 1, state.pie3, state.pie3Type),
                          ],
                        );
                      } else if (state is PieChartEmpty) {
                        return Text("No result can be shown");
                      } else if (state is PieChartError) {
                        return Text("${state.error}");
                      }
                      return Text(state.toString());
                    }),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            BlocBuilder<RecommendationBloc, RecommendationState>(
                                builder: (context, state) {
                          if (state is RecommendationEmpty) {
                            return const Center(
                              child: Text('No suitable recommendation '),
                            );
                          } else if (state is RecommendationSuccess) {
                            return Column(
                              children: [
                                Text(
                                  "Recommendation",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // color: HexColor("#dfaf37"),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.all(8.0),
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
                                                              garmentID: m.id!)));
                                            },
                                            child: Card(
                                              elevation: 5,
                                              color: HexColor(m.colour),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: Row(
                                                  children: [
                                                    // Your existing column
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            m.name!,
                                                            style: TextStyle(
                                                              color: getTextColor(
                                                                  m.colour),
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // New Image widget
                                                    Image.network(
                                                      m.garmentImageURL!, // Replace with your image URL
                                                      fit: BoxFit.cover,
                                                      height:
                                                          110.0, // You can adjust as needed
                                                      width:
                                                          110.0, // You can adjust as needed
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
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
                          return Center(
                              child: Text("Enable location for the result"));
                        }),
                      ),
                    ),
                  
                  ]),
                ),
              )),
        ),
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
                interval: 1, // Adjust as needed
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
                            color: HexColor("#dfaf37"),
                            width: 18,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: y + 1,
                              color: Color.fromARGB(255, 93, 63, 184),
                            ))
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _smallBarChartDiagram(
      double y, List<BarChartModel> data, String categoryy) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: BarChart(
          BarChartData(
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
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
            titlesData: FlTitlesData(
              show: true,
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                reservedSize: 30,
                interval: 1, // Adjust as needed
                showTitles: true,
              )),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  switch (categoryy) {
                    case "Brand":
                      return getBrandTitles(value, meta);
                    case "Country":
                      return getCountryTitles(value, meta);
                    case "Colour":
                      return getColourTitles(value, meta);
                    case "Size":
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
                            color: HexColor("#dfaf37"),
                            width: 18,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: y + 1,
                              color: Color.fromARGB(255, 93, 63, 184),
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
      borderColor: Color.fromARGB(255, 93, 63, 184),
      fillColor: Color.fromARGB(255, 93, 63, 184),
      borderWidth: 1,
      selectedBorderColor: Color.fromARGB(255, 93, 63, 184),
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
        // color: HexColor("#F1DCF6"),
        child: Column(children: [
          SizedBox(height: 10),
          Text(
            numberOfGarment.toString(),
            style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold,
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

  List<PieChartSectionData> getSections(List<PieChartModel> listt) {
    return List.generate(listt.length, (index) {
      final PieChartModel data = listt[index]; // Declare 'data' before using it
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 60 : 50;
      final Color color = isTouched ? Colors.blue : data.color;
      return PieChartSectionData(
        color: color,
        value: data.percent,
        // title: '${data.name}\n(${data.totalNumber})',
        title: data.name,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: getTextColor(data.color.toString()),
        ),
        showTitle: true,
        badgeWidget: isTouched ? TooltipWidget(data.totalNumber) : null,
        badgePositionPercentageOffset: 1.2,
      );
    });
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
    return SizedBox(
      width: 170,
      height: 125,
      child: Card(
        color: Color.fromARGB(255, 93, 63, 184),
        child: BlocBuilder<GetWeatherBloc, GetWeatherState>(
          builder: (context, state) {
            if (state is GetWeatherSuccess) {
              return InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(state.weather.weatherday!),
                          content: Text(
                              "Today is ${state.weather.description}, it's feels like ${state.weather.humidityTemperature}°C",
                              style: TextStyle(fontSize: 15)),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Alright!"))
                          ],
                        );
                      });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child:
                            Text('Now', style: TextStyle(color: Colors.white))),
                    Center(
                        child: Text(
                      "${state.weather.currentTemperature!.toStringAsFixed(1)}°C",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    )),
                  ],
                ),
              );
            }
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text('Enable location for weather result',
                        style: TextStyle(color: Colors.white))),
              ),
            );
          },
        ),
      ),
    );
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
    int colorValue = int.parse(hexColor.replaceAll('#', ''), radix: 16);
    // If the color value is less than the threshold, return white; otherwise, return black.
    return colorValue < 0x666666 ? Colors.white : Colors.black;
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

class TooltipWidget extends StatelessWidget {
  final int value;

  TooltipWidget(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '$value',
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}
