/// Receipt of one export with its provenance (who, when, which range).
class ExportReceipt {
  const ExportReceipt({
    required this.id,
    required this.definitionId,
    required this.range,
    required this.at,
    required this.provenance,
  });

  final String id;
  final String definitionId;
  final String range;
  final String at;
  final String provenance;
}
