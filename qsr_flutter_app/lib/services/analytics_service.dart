class AnalyticsService {
  static Future<Map<String, dynamic>> getAnalyticsData() async {
    // Stub: return sample analytics data
    return {
      'totalRevenue': 0,
      'totalOrders': 0,
      'averageOrderValue': 0,
      'topSellingItems': [],
      'dailyRevenue': [],
      'customerStats': {
        'newCustomers': 0,
        'returningCustomers': 0,
        'totalCustomers': 0,
      },
    };
  }
}
