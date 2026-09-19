/// Calculates overdue penalties based on total delayed days and daily rate.
double computeFine({required int overdueDays, double dailyRate = 2.50}) {
  if (overdueDays <= 0) {
    return 0.0;
  }
  return overdueDays * dailyRate;
}
