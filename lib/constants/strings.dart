String closeWarning =
    'You are closing without editing/saving changes. You may lose changes and they cannot be retrieved/reversed';
String closePrompt = 'Do you wish to close?';

String deletePrompt = 'Do you wish to delete?';
String deleteLoanWarning =
    'You are deleting this loan category and this action is not reversible, this information will not be available for other users. Confirm action to delete';

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
var baseUrl = 'https://tuulacredit.com/jubilant-waddle/public/api/v1';

///get dashboard
Uri dashboardUrl = Uri.parse('$baseUrl/dashboard/get_all');

///get all users
Uri getUsersUrl = Uri.parse('$baseUrl/user/get_all');

///get all admin users
Uri getAdminUsersUrl = Uri.https('$baseUrl/user/get_admins');

///get dashboard
Uri allLoansUrl = Uri.parse('$baseUrl/loan/get_loan_applications');

///get all users
Uri getUser = Uri.parse('$baseUrl/end_users');

///get all payments
Uri getAllPayments = Uri.parse('$baseUrl/payments/get_all');

///get FAQ
Uri getFAQs = Uri.parse('$baseUrl/settings/get_faqs');

///get positions
Uri allPositionsUrl = Uri.parse('$baseUrl/settings/get_positions');

///add position
Uri addPositionUrl = Uri.parse('$baseUrl/settings/add_position');

///get transaction type
Uri getTransactionTypes = Uri.parse('$baseUrl/settings/get_transaction_types');

///get salary scale
Uri getSalaryScale = Uri.parse('$baseUrl/settings/get_salary_scales');

///get all professions
Uri getProfessions = Uri.parse('$baseUrl/settings/get_professions');

///add FAQ
Uri addFAQ = Uri.parse('$baseUrl/settings/add_faq');

///add transaction type
Uri addTransactionType = Uri.parse('$baseUrl/settings/add_transaction_type');

///add salary scale
Uri addSalaryScale = Uri.parse('$baseUrl/settings/add_salary_scale');

///add profession
Uri addProfession = Uri.parse('$baseUrl/settings/add_profession');

///get all loan categories
Uri getAllLoanTypes = Uri.parse('$baseUrl/settings/get_all_loan_categories');

///create new loan category
Uri addLoanType = Uri.parse('$baseUrl/settings/new_loan_category');
