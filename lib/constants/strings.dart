var loanCategory = [
  {"asset": "car.svg", "category": "Emergency Loan"},
  {"asset": "school.svg", "category": "School Loan"},
  {"asset": "asset.svg", "category": "Asset Financing"},
  {"asset": "money.svg", "category": "Salary Advances"},
  {"asset": "lorry.svg", "category": "Logbook Loan"}
];

var actionCategory = [
  {"asset": "arrow_right.svg", "category": "Make a loan"},
  {"asset": "arrow_down.svg", "category": "Make a deposit"},
  {"asset": "record.svg", "category": "Record"},
  {"asset": "repeat.svg", "category": "Cash back"},
  {"asset": "settings.svg", "category": "Settings"},
  {"asset": "download.svg", "category": "Download slips"}
];

List transactionSource = [
  {"title": "Mobile Money Transfer"},
  {"title": "Bank Money Transfer"},
  {"title": "Cash Payment"}
];

///api uri links
///base url
var baseUrl = 'http://tuula_loan_app.test/api/v1';

///get dashboard
Uri dashboardUrl = Uri.parse('$baseUrl/dashboard/get_all/');

///get loan categories
Uri getUser = Uri.parse('$baseUrl/end_users');


