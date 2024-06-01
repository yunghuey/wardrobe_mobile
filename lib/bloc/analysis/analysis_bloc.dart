import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_event.dart';
import 'package:wardrobe_mobile/bloc/analysis/analysis_state.dart';
import 'package:wardrobe_mobile/model/brand.dart';
import 'package:wardrobe_mobile/model/colour.dart';
import 'package:wardrobe_mobile/model/country.dart';
import 'package:wardrobe_mobile/model/size.dart';
import 'package:wardrobe_mobile/pages/valueConstant.dart';
import 'package:wardrobe_mobile/repository/analysis_repo.dart';

class DisplayAnalysisBloc extends Bloc<DisplayAnalysisEvent,DisplayAnalysisState>{
  AnalysisRepository repo;
  DisplayAnalysisBloc(DisplayAnalysisState initialState, this.repo): super(initialState){

    on<GetBrandAnalysisEvent>((event, emit) async{
      try{
        emit(FetchingAnaDataState());
        Map<String, dynamic> branddata = await repo.brandAnalysis();
        List<BrandModel> eachBrandGarment = [];
        double highest = 0;
        branddata.forEach((brandName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.BRANDS_NAME.indexOf(brandName);
          var brand = BrandModel(brandName: brandName, numberOfGarment: totalNum, brandCode: index);
          print("brand ${brandName} number: ${totalNum}");
          eachBrandGarment.add(brand);
        });
        if (eachBrandGarment != []){
          emit(BrandAndNumberBarChart(data: eachBrandGarment,y: highest));
        }
        else {
          emit(BrandAndNumberError(message: "No data can be provided"));
        }
      } catch (e){
        emit(BrandAndNumberError(message: e.toString()));
      }
    });
  
    on<GetCountryAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.countryAnalysis();
        List<CountryModel> eachCountryGarment = [];
        double highest = 0;
        countrydata.forEach((countryName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.COUNTRY.indexOf(countryName);
          var brand = CountryModel(countryName: countryName, numberOfGarment: totalNum, countryCode: index);
          print("country ${countryName} number: ${totalNum}");
          eachCountryGarment.add(brand);
        });

        if (eachCountryGarment != []){
          emit(CountryAndNumberBarChart(data: eachCountryGarment,y: highest));
        }
        else {
          emit(CountryAndNumberError(message: "No data can be provided"));
        }
      } catch (e){
        emit(CountryAndNumberError(message: e.toString()));
      }
    });

    on<GetColourAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.colourAnalysis();
        List<ColourModel> eachColourGarment = [];
        double highest = 0;
        countrydata.forEach((colourName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.COLOUR_NAME.indexOf(colourName);
          var brand = ColourModel(colourName: colourName, numberOfGarment: totalNum, colourCode: index);
          print("colour ${colourName} number: ${totalNum} index ${index}");
          eachColourGarment.add(brand);
        });
        
        if (eachColourGarment != []){
          emit(ColourAndNumberBarChart(data: eachColourGarment,y: highest));
        }
        else {
          emit(ColourAndNumberError(message: "No data can be provided"));
        }
      } catch (e){
        emit(ColourAndNumberError(message: e.toString()));
      }
    });

    on<GetSizeAnalysisEvent>((event, emit) async {
      try{      
        emit(FetchingAnaDataState());
        Map<String, dynamic> countrydata = await repo.sizeAnalysis();
        List<SizeModel> eachSizeGarment = [];
        double highest = 0;
        countrydata.forEach((sizeName, data){
          // inside data got colour name, country, size
          int totalNum =  data['total_num'];
          if (totalNum > highest){
            highest = totalNum.toDouble();
          }
          int index = ValueConstant.SIZES.indexOf(sizeName);
          var brand = SizeModel(sizeName: sizeName, numberOfGarment: totalNum, sizeCode: index);
          print("size ${sizeName} number: ${totalNum}");
          eachSizeGarment.add(brand);
        });
        
        if (eachSizeGarment != []){
          emit(SizeAndNumberBarChart(data: eachSizeGarment,y: highest));
        }
        else {
          emit(SizeAndNumberError(message: "No data can be provided"));
        }
      } catch (e){
        emit(SizeAndNumberError(message: e.toString()));
      }
    });
  }
}