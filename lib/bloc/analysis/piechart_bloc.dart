import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:wardrobe_mobile/model/barchart.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';
import 'package:wardrobe_mobile/bloc/analysis/piechart_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/piechart_state.dart';
import 'dart:math';

class PieChartBloc extends Bloc<DisplayPieChartEvent, DisplayPieChartState> {
  AnalysisRepository repo;
  PieChartBloc(DisplayPieChartState initialState, this.repo)
      : super(initialState) {
    on<PieChartReset>((event, emit) {
      emit(PieChartInitState());
    });

    String getRandomColorHex() {
      final random = Random();
      int red = 150 +  random.nextInt(100);
      int green = 150 +  random.nextInt(100);
      int blue = 150 +  random.nextInt(100);

      // Convert RGB values to a hexadecimal string
      return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
    }

    on<BrandPieChart>((event, emit) async {
      try {
        emit(FetchingPieData());
        print("get data again");
        Map<String, dynamic> branddata = await repo.brandAnalysis();
        List<BarChartModel> pieColourList = [];
        List<BarChartModel> pieCountryList = [];
        List<BarChartModel> pieSizeList = [];
        double totalNum = 0;
        branddata.forEach((brandName, data) {
          if (brandName == event.brandname) {
            totalNum = data['total_num'].toDouble();
            var listgroup = data['colour_name'];
            for (final colourMap in listgroup) {
              colourMap.forEach((color, count) {
                int index = ValueConstant.COLOUR_NAME.indexOf(color);
                var data = BarChartModel(
                    name: color,
                    numberOfGarment: count,
                    code: index
                    // percent: secPercentage,
                    );
                pieColourList.add(data);
              });
            }
            // settle for size
            listgroup = data['size'];
            for (final sizeMap in listgroup) {
              sizeMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    // percent: secPercentage,
                     code: ValueConstant.SIZES.indexOf(name)
                  );
                pieSizeList.add(data);
              });
            }
            // settle for country
            listgroup = data['country'];
            for (final countryMap in listgroup) {
              countryMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    // percent: secPercentage,
                    code: ValueConstant.COUNTRY.indexOf(name),
                    // color: HexColor(colourCode)
                    );
                pieCountryList.add(data);
              });
            }
          }
        });

        if (pieColourList.isNotEmpty &&
            pieCountryList.isNotEmpty &&
            pieSizeList.isNotEmpty) {
          emit(PieChartDataState(
              pie1: pieColourList,
              pie2: pieCountryList,
              pie3: pieSizeList,
              pie1Type: 'Colour',
              pie2Type: 'Country',
              pie3Type: 'Size',
              indicator: 'brand',
              y: totalNum
              ));
        } else {
          emit(PieChartEmpty());
        }
      } catch (e, stackTrace) {
        emit(
            PieChartError(error: "${e.toString}, at ${stackTrace.toString()}"));
      }
    });

    on<CountryPieChart>((event, emit) async {
      String requestCountryName = event.countryname;
      try {
        emit(FetchingPieData());
        Map<String, dynamic> countrydata = await repo.countryAnalysis();
        List<BarChartModel> pieColourList = [];
        List<BarChartModel> pieBrandList = [];
        List<BarChartModel> pieSizeList = [];
        double totalNum = 0;
        countrydata.forEach((brandName, data) {
          if (brandName == event.countryname) {
            totalNum = data['total_num'].toDouble();
            // settle colour
            var listgroup = data['colour_name'];
            for (final colourMap in listgroup) {
              colourMap.forEach((color, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                int index = ValueConstant.COLOUR_NAME.indexOf(color);
                // String colorCode = ValueConstant.COLOUR_CODE[index];
                var data = BarChartModel(
                    name: color,
                    numberOfGarment: count,
                    // percent: secPercentage,
                    // color: HexColor(colorCode)
                    code: index,
                    );
                pieColourList.add(data);
              });
            }
            // settle for size
            listgroup = data['size'];
            for (final sizeMap in listgroup) {
              sizeMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    code: ValueConstant.SIZES.indexOf(name)

                  );
                pieSizeList.add(data);
              });
            }
            // settle for country
            listgroup = data['brand'];
            for (final brandMap in listgroup) {
              brandMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    // percent: secPercentage,
                    code: ValueConstant.BRANDS_NAME.indexOf(name),
                    // color: HexColor(colourCode)
                    );
                pieBrandList.add(data);
              });
            }
          }
        });

        print("pie colour list ${pieColourList.length}");
        print("pie brand list ${pieBrandList.length}");
        print("pie size list ${pieSizeList.length}");
        if (pieColourList.isNotEmpty &&
            pieBrandList.isNotEmpty &&
            pieSizeList.isNotEmpty) {
          emit(PieChartDataState(
              pie1: pieColourList,
              pie2: pieBrandList,
              pie3: pieSizeList,
              pie1Type: 'Colour',
              pie2Type: 'Brand',
              pie3Type: 'Size',
              indicator: 'country',
              y: totalNum
              ));
        } else {
          emit(PieChartEmpty());
        }
      } catch (e, stackTrace) {
        print(e.toString());
        print(stackTrace.toString());
        emit(
            PieChartError(error: "${e.toString}, at ${stackTrace.toString()}"));
      }
    });

    on<SizePieChart>((event, emit) async {
      try {
        emit(FetchingPieData());
        Map<String, dynamic> sizeData = await repo.sizeAnalysis();
        List<BarChartModel> pieColourList = [];
        List<BarChartModel> pieBrandList = [];
        List<BarChartModel> pieCountryList = [];
        double totalNum = 0;
        sizeData.forEach((sizeName, data) {
          if (sizeName == event.sizename) {
            totalNum = data['total_num'].toDouble();
            // settle colour
            var listgroup = data['colour_name'];
            for (final colourMap in listgroup) {
              colourMap.forEach((color, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                int index = ValueConstant.COLOUR_NAME.indexOf(color);
                // String colorCode = ValueConstant.COLOUR_CODE[index];
                var data = BarChartModel(
                    name: color,
                    numberOfGarment: count,
                    // percent: secPercentage,
                    code: index
                  );
                pieColourList.add(data);
              });
            }
            // settle for size
            listgroup = data['country'];
            for (final countryMap in listgroup) {
              countryMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    // percent: secPercentage,
                    code: ValueConstant.COUNTRY.indexOf(name)

                    // color: HexColor(colourCode)
                    );
                pieCountryList.add(data);
              });
            }
            // settle for brand
            listgroup = data['brand'];
            for (final brandMap in listgroup) {
              brandMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    code: ValueConstant.BRANDS_NAME.indexOf(name)
                    // percent: secPercentage,
                    // color: HexColor(colourCode)
                    );
                pieBrandList.add(data);
              });
            }
          }
        });

        if (pieColourList.isNotEmpty &&
            pieBrandList.isNotEmpty &&
            pieCountryList.isNotEmpty) {
          emit(PieChartDataState(
              pie1: pieColourList,
              pie2: pieBrandList,
              pie3: pieCountryList,
              pie1Type: 'Colour',
              pie2Type: 'Brand',
              pie3Type: 'Size',
              indicator: 'Size',
              y: totalNum,
              ));
        } else {
          emit(PieChartEmpty());
        }
      } catch (e, stackTrace) {
        print(e.toString());
        print(stackTrace.toString());
        emit(
            PieChartError(error: "${e.toString}, at ${stackTrace.toString()}"));
      }
    });


    on<ColourPieChart>((event, emit) async {
      try {
        emit(FetchingPieData());
        Map<String, dynamic> sizeData = await repo.colourAnalysis();
        List<BarChartModel> pieSizeList = [];
        List<BarChartModel> pieBrandList = [];
        List<BarChartModel> pieCountryList = [];
        double totalNum = 0;
        sizeData.forEach((colour, data) {
          if (colour == event.colourname) {
            double totalNum = data['total_num'].toDouble();
            // settle size
            var listgroup = data['size'];
            for (final sizeMap in listgroup) {
              sizeMap.forEach((color, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                // String colorCode = getRandomColorHex();
                var data = BarChartModel(
                    name: color,
                    code: ValueConstant.SIZES.indexOf(color),
                    numberOfGarment: count,
                    // percent: secPercentage,
                    // color: HexColor(colorCode)
                  );
                pieSizeList.add(data);
              });
            }
            // settle for country
            listgroup = data['country'];
            for (final countryMap in listgroup) {
              countryMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // get index of colour and get index of colour code
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    numberOfGarment: count,
                    code: ValueConstant.COUNTRY.indexOf(name),
                    // percent: secPercentage,
                    // color: HexColor(colourCode)
                    );
                pieCountryList.add(data);
              });
            }
            // settle for brand
            listgroup = data['brand'];
            for (final brandMap in listgroup) {
              brandMap.forEach((name, count) {
                // double secPercentage = count / totalNum * 100;
                // String colourCode = getRandomColorHex();
                var data = BarChartModel(
                    name: name,
                    code: ValueConstant.BRANDS_NAME.indexOf(name),
                    numberOfGarment: count,
                    // percent: secPercentage,
                    // color: HexColor(colourCode)
                    );
                pieBrandList.add(data);
              });
            }
          }
        });

        if (pieSizeList.isNotEmpty &&
            pieBrandList.isNotEmpty &&
            pieCountryList.isNotEmpty) {
          emit(PieChartDataState(
              pie1: pieSizeList,
              pie2: pieBrandList,
              pie3: pieCountryList,
              pie1Type: 'Size',
              pie2Type: 'Brand',
              pie3Type: 'Country',
              indicator: 'Colour',
              y: totalNum,
              ));
        } else {
          emit(PieChartEmpty());
        }
      } catch (e, stackTrace) {
        print(e.toString());
        print(stackTrace.toString());
        emit(
            PieChartError(error: "${e.toString}, at ${stackTrace.toString()}"));
      }
    });
  }
}
