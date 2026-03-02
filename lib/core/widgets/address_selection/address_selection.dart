import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasa/core/base/base_state.dart';
import 'package:tasa/core/constants/colors.dart';
import 'package:tasa/core/constants/spacing.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/utilities/screens.dart';
import 'package:tasa/core/widgets/address_selection/bloc/address_selection_cubit.dart';
import 'package:tasa/core/widgets/address_selection/bloc/address_selection_state.dart';
import 'package:tasa/core/widgets/address_selection/models/address_selection_model.dart';
import 'package:tasa/core/widgets/base/base_loading.dart';
import 'package:tasa/core/widgets/buttons/extra_button.dart';
import 'package:tasa/core/widgets/textfield/validate_textfield.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({
    super.key,
    required this.initialValue,
    this.hiddenStep,
    this.isFilter = false,
  });

  final AddressSelectionModel initialValue;
  final List<int>? hiddenStep;
  final bool? isFilter;

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState
    extends BaseState<AddressSelection, AddressSelectionCubit> {
  Widget buildTitleSelected(
    String field,
    AddressSelectionState state,
    bool showDot,
    int step,
  ) {
    String dot = '';

    if (showDot) {
      dot = ' • ';
    }

    String text = '';

    bool clicked = false;

    switch (field) {
      case 'province':
        clicked = true;
        if (state.province == null) {
          text = 'Tỉnh/ Thành phố';
        } else {
          text = state.province['name'];
        }
        break;
      case 'district':
        clicked = state.districts.isNotEmpty;
        if (state.district == null) {
          text = '${dot}Quận/ Huyện';
        } else {
          text = (dot) + state.district['name'];
        }
        break;
      case 'ward':
        clicked = state.wards.isNotEmpty;
        if (state.ward == null) {
          text = '${dot}Phường/ Xã';
        } else {
          text = (dot) + state.ward['name'];
        }
        break;
      case 'address':
        text = '${dot}Chi tiết';
        clicked = true;
    }
    return GestureDetector(
      onTap: () {
        if (clicked) {
          bloc.onChangeStep(step);
        }
      },
      child: Text(
        text,
        style: AppTypography.p6.copyWith(color: AppColors.main),
      ),
    );
  }

  Widget buildStep_1() {
    bool isSelected(AddressSelectionState state, int index) {
      if (state.province == null) {
        return false;
      }
      return state.provinces[index]['code'] == state.province['code'];
    }

    return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const BaseLoading();
        } else {
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: List.generate(state.provinces.length, (index) {
                return GestureDetector(
                  onTap: () {
                    bloc.onChangeProvince(state.provinces[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color:
                        isSelected(state, index)
                            ? AppColors.bg_2
                            : Colors.transparent,
                    child: Text(
                      state.provinces[index]['name'],
                      style: AppTypography.p4,
                    ),
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }

  Widget buildStep_2() {
    bool isSelected(AddressSelectionState state, int index) {
      if (state.district == null) {
        return false;
      }
      return state.districts[index]['code'] == state.district['code'];
    }

    return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const BaseLoading();
        } else {
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: List.generate(state.districts.length, (index) {
                return GestureDetector(
                  onTap: () {
                    bloc.onChangeDistrict(state.districts[index]);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color:
                        isSelected(state, index)
                            ? AppColors.bg_2
                            : Colors.transparent,
                    child: Text(
                      state.districts[index]['name'],
                      style: AppTypography.p4,
                    ),
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }

  Widget buildStep_3() {
    bool isSelected(AddressSelectionState state, int index) {
      if (state.ward == null) {
        return false;
      }
      return state.wards[index]['code'] == state.ward['code'];
    }

    return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const BaseLoading();
        } else {
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: List.generate(state.wards.length, (index) {
                return GestureDetector(
                  onTap: () {
                    bloc.onChangeWard(
                      state.wards[index],
                      hiddenDetail: (widget.hiddenStep ?? []).contains(4),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color:
                        isSelected(state, index)
                            ? AppColors.bg_2
                            : Colors.transparent,
                    child: Text(
                      state.wards[index]['name'],
                      style: AppTypography.p4,
                    ),
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }

  Widget buildStep_4() {
    return BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
      builder: (context, state) {
        String initialValue = '';
        if (state.address != null) {
          initialValue = state.address!;
        }
        return Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                ValidateTextField(
                  initialValue: initialValue,
                  margin: EdgeInsets.zero,
                  backgroundColor: AppColors.white,
                  hintText: 'Địa chỉ chi tiết',
                  hintStyle: AppTypography.p6.copyWith(color: AppColors.grey_1),
                  onChanged: (value) {
                    bloc.onChangeAddress(value);
                  },
                  onClear: () {
                    bloc.onChangeAddress('');
                  },
                  maxLines: 8,
                ),
                const Spacer(),
                Row(
                  children: [
                    ExtraButton(
                      largeButton: false,
                      title: 'Đặt lại',
                      onTap: () {
                        bloc.setInitialValue(
                          const AddressSelectionModel(
                            text: null,
                            ward: null,
                            address: null,
                            district: null,
                            province: null,
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    ExtraButton(
                      largeButton: false,
                      title: 'Huỷ bỏ',
                      onTap: () {
                        navigator.pop();
                      },
                    ),
                    const SizedBox(width: 8),
                    ExtraButton(
                      largeButton: false,
                      title: 'Xác nhận',
                      color: AppColors.white,
                      bgColor: AppColors.main,
                      borderColor: AppColors.main,
                      onTap: () {
                        navigator.pop(
                          result: {
                            "text": bloc.state.text,
                            "ward": bloc.state.ward,
                            "address": bloc.state.address,
                            "district": bloc.state.district,
                            "province": bloc.state.province,
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    bloc.getProvinces(provinces: appCubit.state.provinces);
    bloc.setInitialValue(widget.initialValue);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AddressSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget buildPage(BuildContext context) {
    final List<Widget> stepList = [
      buildStep_1(),
      buildStep_2(),
      buildStep_3(),
      buildStep_4(),
    ];

    return BlocListener<AddressSelectionCubit, AddressSelectionState>(
      listener: (context, state) {
        if (appCubit.state.provinces.isEmpty) {
          appCubit.setProvinces(state.provinces);
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: AppColors.white,
              height:
                  heightDevice(context) - AppBar().preferredSize.height - 42,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top:
                          MediaQuery.of(context).viewInsets.bottom >
                                  AppBar().preferredSize.height
                              ? AppBar().preferredSize.height
                              : 24,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      children: [
                        const Text("Chọn địa chỉ", style: AppTypography.h5),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            navigator.pop();
                          },
                          child: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                    builder: (context, state) {
                      return Container(
                        padding: Spacing.h16,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (!(widget.hiddenStep ?? []).contains(1))
                                buildTitleSelected('province', state, false, 1),
                              if (!(widget.hiddenStep ?? []).contains(2))
                                buildTitleSelected('district', state, true, 2),
                              if (!(widget.hiddenStep ?? []).contains(3))
                                buildTitleSelected('ward', state, true, 3),
                              if (!(widget.hiddenStep ?? []).contains(4))
                                buildTitleSelected('address', state, true, 4),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                    builder: (context, state) {
                      if (state.step != 4) {
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            Padding(
                              padding: Spacing.h16,
                              child: ValidateTextField(
                                margin: EdgeInsets.zero,
                                backgroundColor: AppColors.white,
                                hintText: 'Tìm kiếm',
                                hintStyle: AppTypography.p6.copyWith(
                                  color: AppColors.grey_1,
                                ),
                                leadingIcon: const Padding(
                                  padding: EdgeInsets.only(right: 6),
                                  child: Icon(Icons.search, size: 22),
                                ),
                                maxLines: 1,
                                onChanged: bloc.handleSearch,
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                    builder: (context, state) {
                      return stepList[state.step - 1];
                    },
                  ),
                  if (widget.isFilter == true)
                    BlocBuilder<AddressSelectionCubit, AddressSelectionState>(
                      builder: (context, state) {
                        return state.isLoading
                            ? const SizedBox.shrink()
                            : Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ExtraButton(
                                      largeButton: false,
                                      title: 'Xóa bộ lọc',
                                      borderColor: AppColors.border_1,
                                      color: AppColors.blackish,
                                      onTap: () {
                                        bloc.setInitialValue(
                                          const AddressSelectionModel(
                                            text: null,
                                            ward: null,
                                            address: null,
                                            district: null,
                                            province: null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ExtraButton(
                                      largeButton: false,
                                      title: 'Xác nhận',
                                      color: AppColors.white,
                                      bgColor: AppColors.main,
                                      borderColor: AppColors.main,
                                      onTap: () {
                                        navigator.pop(
                                          result: {
                                            "text": bloc.state.text,
                                            "ward": bloc.state.ward,
                                            "address": bloc.state.address,
                                            "district": bloc.state.district,
                                            "province": bloc.state.province,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
