import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:wardrobe_mobile/model/barchart.dart';

import 'package:wardrobe_mobile/pages/valueConstant.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';

class DisplayAnalysisBloc extends Bloc<DisplayAnalysisEvent,DisplayAnalysisState>{
  AnalysisRepository repo;
  DisplayAnalysisBloc(DisplayAnalysisState initialState, this.repo): super(initialState){

    on<GetBrandAnalysisEvent>((event, emit) async{
      try{
        emit(FetchingAnaDataState());
        Map<String, dynamic> branddata = await repo.brandAnalysis();
        List<BarChartModel> eachBrandGarment = [];
        double highest = 0;
        branddata.forEach((brandName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.BRANDS_NAME.indexOf(brandName);
          var brand = BarChartModel(name: brandName, numberOfGarment: totalNum, code: index);
          eachBrandGarment.add(brand);
        });
        if(highest == 0.0){
          emit(DataAndNumberEmpty());
        }
        else if (eachBrandGarment != [] || highest != 0.0){
          emit(DataAndNumberBarChart(data: eachBrandGarment,y: highest));
        }
      } catch (e){
        emit(DataAndNumberError(message: e.toString()));
      }
    });
  
    on<GetCountryAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.countryAnalysis();
        List<BarChartModel> eachCountryGarment = [];
        double highest = 0;
        countrydata.forEach((countryName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.COUNTRY.indexOf(countryName);
          var brand = BarChartModel(name: countryName, numberOfGarment: totalNum, code: index);
          eachCountryGarment.add(brand);
        });

        if (eachCountryGarment != []){
          emit(DataAndNumberBarChart(data: eachCountryGarment,y: highest));
        }
        else {
          emit(DataAndNumberEmpty());
        }
      } catch (e){
        emit(DataAndNumberError(message: e.toString()));
      }
    });

    on<GetColourAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.colourAnalysis();
        List<BarChartModel> eachColourGarment = [];
        double highest = 0;
        countrydata.forEach((colourName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.COLOUR_NAME.indexOf(colourName);
          var brand = BarChartModel(name: colourName, numberOfGarment: totalNum, code: index);
          eachColourGarment.add(brand);
        });
        
        if (eachColourGarment != []){
          emit(DataAndNumberBarChart(data: eachColourGarment,y: highest));
        }
        else {
          emit(DataAndNumberEmpty());
        }
      } catch (e){
        emit(DataAndNumberError(message: e.toString()));
      }
    });

    on<GetSizeAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.sizeAnalysis();
        List<BarChartModel> eachSizeGarment = [];
        double highest = 0;
        countrydata.forEach((sizeName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.SIZES.indexOf(sizeName);
          var brand = BarChartModel(name: sizeName, numberOfGarment: totalNum, code: index);
          eachSizeGarment.add(brand);
        });
        
        if (eachSizeGarment != []){
          emit(DataAndNumberBarChart(data: eachSizeGarment,y: highest));
        }
        else {
          emit(DataAndNumberEmpty());
        }
      } catch (e){
        emit(DataAndNumberError(message: e.toString()));
      }
    });
  }
}