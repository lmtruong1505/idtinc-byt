import 'package:tasa/core/base/base_cubit.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tasa/core/configs/dio_config.dart';
import 'package:tasa/core/constants/api_constants.dart';
import 'package:tasa/core/utilities/converts.dart';
import 'package:tasa/core/widgets/address_selection/models/address_selection_model.dart';

import 'address_selection_state.dart';

@Injectable()
class AddressSelectionCubit extends BaseCubit<AddressSelectionState> {
  AddressSelectionCubit(this._baseDio) : super(const AddressSelectionState());

  final BaseDio _baseDio;

  final formKey = GlobalKey<FormState>();

  void onChangeText(String text) {
    emit(state.copyWith(text: text));
  }

  void handleSearch(String keyword) {
    keyword = keyword.trim().toLowerCase();

    List<dynamic> dataClone = [];

    if (state.step == 1) {
      dataClone = state.provincesClone;
    } else if (state.step == 2) {
      dataClone = state.districtsClone;
    } else if (state.step == 3) {
      dataClone = state.wardsClone;
    }

    if (keyword.isNotEmpty) {
      final searchs =
          dataClone.where((e) {
            final name = removeVietnameseTones(
              (e['name'] as String).toLowerCase(),
            );
            final keywordRemoveTones = removeVietnameseTones(keyword);
            return name.contains(keywordRemoveTones);
          }).toList();

      if (state.step == 1) {
        emit(state.copyWith(provinces: searchs));
      } else if (state.step == 2) {
        emit(state.copyWith(districts: searchs));
      } else if (state.step == 3) {
        emit(state.copyWith(wards: searchs));
      }
    } else {
      if (state.step == 1) {
        emit(state.copyWith(provinces: dataClone));
      } else if (state.step == 2) {
        emit(state.copyWith(districts: dataClone));
      } else if (state.step == 3) {
        emit(state.copyWith(wards: dataClone));
      }
    }
  }

  void initData(AddressSelectionModel initialValue) async {
    initData(initialValue);

    if (initialValue.address != null) {
      emit(state.copyWith(step: 4));
    }

    if (initialValue.address != null) {
      emit(state.copyWith(step: 4));
    }

    if (initialValue.ward != null) {
      emit(state.copyWith(step: 4));
    } else if (initialValue.district != null) {
      emit(state.copyWith(step: 2));
      getDistricts();
    }
  }

  void onChangeWard(dynamic ward, {bool? hiddenDetail = false}) {
    final text = [];

    if (state.address != null) {
      text.add(state.address);
    }
    text.add(ward['name']);
    if (state.district != null) {
      text.add(state.district['name']);
    }
    if (state.province != null) {
      text.add(state.province['name']);
    }

    final newText = text.join(", ");

    emit(
      state.copyWith(
        ward: ward,
        step: hiddenDetail == true ? 3 : 4,
        text: newText,
      ),
    );
  }

  void onChangeAddress(String address) {
    address = address.trim();

    final text = address.isNotEmpty ? [address] : [];

    if (state.ward != null) {
      text.add(state.ward['name']);
    }
    if (state.district != null) {
      text.add(state.district['name']);
    }
    if (state.province != null) {
      text.add(state.province['name']);
    }

    final newText = text.join(", ");

    emit(state.copyWith(address: address, text: newText));
  }

  void onChangeDistrict(dynamic district) {
    final text = [];

    if (state.address != null) {
      text.add(state.address);
    }
    text.add(district['name']);
    if (state.province != null) {
      text.add(state.province['name']);
    }

    final newText = text.join(", ");

    emit(
      state.copyWith(district: district, step: 3, ward: null, text: newText),
    );
    getWards();
  }

  void onChangeProvince(dynamic province) {
    final text = [];

    if (state.address != null) {
      text.add(state.address);
    }
    text.add(province['name']);

    final newText = text.join(", ");

    emit(
      state.copyWith(
        province: province,
        step: 2,
        district: null,
        ward: null,
        text: newText,
      ),
    );
    getDistricts();
  }

  void onChangeStep(int step) {
    emit(state.copyWith(step: step));
  }

  void setInitialValue(AddressSelectionModel initialValue) {
    emit(
      state.copyWith(
        step: initialValue.address != null ? 4 : 1,
        text: initialValue.text,
        ward: initialValue.ward,
        address: initialValue.address,
        district: initialValue.district,
        province: initialValue.province,
      ),
    );

    if (initialValue.province != null) {
      getDistricts();
    }

    if (initialValue.district != null) {
      getWards();
    }
  }

  Future<List<dynamic>> getProvinces({List<dynamic>? provinces}) async {
    emit(state.copyWith(step: 1, isLoading: true));
    if (provinces != null && provinces.isNotEmpty) {
      emit(
        state.copyWith(
          isLoading: false,
          provinces: provinces,
          provincesClone: provinces,
        ),
      );
      return provinces;
    }
    try {
      final data = {"page": 0, "search": "", "page_size": 1000};
      final res = await _baseDio.post(Api.provinceASBC, data: data);
      emit(
        state.copyWith(
          isLoading: false,
          provinces: res.data['data'],
          provincesClone: res.data['data'],
        ),
      );
      return res.data['data'];
    } catch (e) {
      emit(state.copyWith(isLoading: false, provinces: [], provincesClone: []));
      return [];
    }
  }

  Future getDistricts() async {
    emit(state.copyWith(step: 2, isLoading: true));
    try {
      final data = {
        "province": state.province['code'],
        "page": 0,
        "search": "",
        "page_size": 1000,
      };
      final res = await _baseDio.post(Api.districtASBC, data: data);
      emit(
        state.copyWith(
          districts: res.data['data'],
          districtsClone: res.data['data'],
        ),
      );
    } catch (e) {
      emit(state.copyWith(districts: [], districtsClone: []));
    }
    emit(state.copyWith(isLoading: false));
  }

  Future getWards() async {
    emit(state.copyWith(step: 3, isLoading: true));
    try {
      final data = {
        "district": state.district['code'],
        "page": 0,
        "search": "",
        "page_size": 1000,
      };
      final res = await _baseDio.post(Api.wardsASBC, data: data);
      emit(
        state.copyWith(wards: res.data['data'], wardsClone: res.data['data']),
      );
    } catch (e) {
      emit(state.copyWith(wards: [], wardsClone: []));
    }
    emit(state.copyWith(isLoading: false));
  }
}
