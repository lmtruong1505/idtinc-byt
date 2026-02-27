enum ModuleEnum { TM_ORDER }

extension ModuleEnumExtension on ModuleEnum {
  ModuleEnum get moduleEnum {
    switch (this) {
      case ModuleEnum.TM_ORDER:
        return ModuleEnum.TM_ORDER;
    }
  }

  String get title {
    switch (this) {
      case ModuleEnum.TM_ORDER:
        return "TM_ORDER";
    }
  }
}

extension ModuleEnumExtension2 on String {
  ModuleEnum get moduleEnum {
    switch (this) {
      case "TM_ORDER":
        return ModuleEnum.TM_ORDER;
      default:
        return ModuleEnum.TM_ORDER;
    }
  }
}
