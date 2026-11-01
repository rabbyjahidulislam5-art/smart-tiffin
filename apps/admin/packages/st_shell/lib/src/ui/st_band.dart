enum StBand { compact, medium, expanded, large }

StBand bandOf(double w) {
  if (w < 600) return StBand.compact;
  if (w < 840) return StBand.medium;
  if (w < 1200) return StBand.expanded;
  return StBand.large;
}

bool isWide(StBand b) => b == StBand.expanded || b == StBand.large;
