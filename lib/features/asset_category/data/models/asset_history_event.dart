class AssetHistoryEvent {
  final String date;
  final AssetEventType type;
  final String title;
  final String departmentName;
  final String? departmentType;
  final String? assigneeName;
  final String? assigneeRole;
  final int incidentsCount;
  final bool isWarning;

  const AssetHistoryEvent({
    required this.date,
    required this.type,
    required this.title,
    required this.departmentName,
    this.departmentType,
    this.assigneeName,
    this.assigneeRole,
    this.isWarning = false,
    this.incidentsCount = 0,
  });
}

enum AssetEventType {
  initial,
  transfer,
  transferRejected,
  transferPending,
  disposePending,
  disposed,
}
