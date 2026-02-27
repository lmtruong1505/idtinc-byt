import 'package:bpg_retail/core/configs/app_style/init_app_style.dart';
import 'package:bpg_retail/core/constants/typography.dart';
import 'package:bpg_retail/core/extension/spacing_extension.dart';
import 'package:bpg_retail/core/widgets/dropdown_button.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/department_catalog_cubit.dart';
import 'package:bpg_retail/features/dashboard/presentation/bloc/department_catalog_state.dart';
import 'package:bpg_retail/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class HospitalFilter extends StatelessWidget {
  const HospitalFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.logo.image(height: 60, width: 60),
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
                  border: Border.all(color: AppColors.grey40, width: 1.2),
                ),
                padding: const EdgeInsets.only(left: 12, right: 12),
                width: double.infinity,
              ),
            );
          },
        ),
      ],
    );
  }
}
