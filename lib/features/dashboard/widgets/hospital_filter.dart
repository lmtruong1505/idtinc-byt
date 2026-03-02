import 'package:tasa/core/configs/app_style/init_app_style.dart';
import 'package:tasa/core/constants/typography.dart';
import 'package:tasa/core/extension/spacing_extension.dart';
import 'package:tasa/core/widgets/dropdown_button.dart';
import 'package:tasa/features/dashboard/presentation/bloc/department_catalog_cubit.dart';
import 'package:tasa/features/dashboard/presentation/bloc/department_catalog_state.dart';
import 'package:tasa/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class HospitalFilter extends StatefulWidget {
  const HospitalFilter({super.key});

  @override
  State<HospitalFilter> createState() => _HospitalFilterState();
}

class _HospitalFilterState extends State<HospitalFilter> {
  final TextEditingController searchController = TextEditingController();
  bool isMenuOpen = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.logoTasa.image(height: 60, width: 60),
        16.height,
        Text(
          "Bệnh viện đa khoa huyện Quốc Oai",
          textAlign: TextAlign.center,
          style: AppTypography.h5.copyWith(color: AppColors.text_primary),
        ),
        16.height,
        BlocBuilder<DepartmentCatalogCubit, DepartmentCatalogState>(
          builder: (context, state) {
            final items = [
              DropdownButtonModel(label: "Toàn viện", value: null),
              ...state.departments.map(
                (e) => DropdownButtonModel(label: e.tenKhoa ?? '', value: e),
              ),
            ];

            return CustomDropdownButton(
              value: state.selectedDepartment,
              items: items,
              hintText: "Toàn viện",
              onChanged: (model) {
                context.read<DepartmentCatalogCubit>().selectDepartment(
                  model?.value,
                );
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border:
                      isMenuOpen
                          ? Border.all(color: AppColors.main, width: 2)
                          : Border.all(color: AppColors.grey40, width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 64,
                searchInnerWidget: Container(
                  height: 64,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey20, width: 1),
                    ),
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      hintText: 'Tìm kiếm',
                      hintStyle: AppTypography.p6,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.grey20),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.grey20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.main),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value?.label.toLowerCase().contains(
                        searchValue.toLowerCase(),
                      ) ??
                      false;
                },
              ),
              onMenuStateChange: (isOpen) {
                setState(() {
                  isMenuOpen = isOpen;
                });
                if (!isOpen) {
                  searchController.clear();
                }
              },
              showDivider: true,
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                ),
                maxHeight: 400,
                offset: const Offset(0, 4),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            );
          },
        ),
      ],
    );
  }
}
