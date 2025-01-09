const String baseUrl = 'https://jt-hcm.simise.id/api';
const String baseUrl2 = 'https://jt-hcm.simise.id';

class ApiConfig {
  static const String apiKey = 'H2BSQUDSOEJXRLT0P2W1GLI9BSYGCQ08';
}

class ApiEndpoints {
  static String login(String db, String username, String password) =>
      '$baseUrl/login?db=$db&login=$username&password=$password';
//
  static String fetchAttendance(employeeId) =>
      '$baseUrl/hr.attendance/search?domain=[(\'employee_id\',\'=\',$employeeId)]&fields=[\'employee_id\',\'check_in\',\'check_out\',\'worked_hours\']'; //bottom_content | home
//
  static String fetchActivities(userId) =>
      "$baseUrl/hr.leave/search?domain=[('state','in',['confirm','validate1']),('|'), ('employee_id.user_id', '!=', $userId),('|'),('%26'),('state','=','confirm'),('holiday_status_id.leave_validation_type','=','hr'),('state','=','validate1')]&fields=['employee_id','holiday_status_id','name','date_from','date_to','duration_display','state','create_date','private_name', 'id']"; //content_approval |time_off

  static String fetchCategories(employeeId) =>
      "$baseUrl/hr/leave/allocation?employee_id=$employeeId"; //top_content |time_off

  static String submitTimeOffRequest() =>
      "$baseUrl/hr.leave/create"; //page_time_off |time_off

  static String uploadFile() =>
      "$baseUrl/ir.attachment/create"; //page_time_off(upload file) |time_off

  static String fetchActivities2(employeeId) =>
      "$baseUrl/hr.leave/search?domain=[('employee_id','=',$employeeId)]&fields=['employee_id','holiday_status_id','name','date_from','date_to','duration_display','state','create_date','private_name','attachment_ids']"; //content_history |time_off

  static String approvalTimeOff() =>
      "$baseUrl/hr.leave/execute_kw"; //dialog_approval |time_off

  static String refuseTimeOff() =>
      "$baseUrl/hr.leave/execute_kw"; //dialog_approval |time_off
//
  static String submitRequest() =>
      "$baseUrl/hr.expense/create"; //page_reimburse |reimburse

  static String fetchCategories2() =>
      '$baseUrl/product.product/search?domain=[("can_be_expensed","=",True)]&fields=["default_code","product_tmpl_id"]'; //midle_content |reimburse

  static String fetchExpenseData(employeeId) =>
      "$baseUrl/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date','state']"; //reimburse_list | reimburse

  // ignore: no_leading_underscores_for_local_identifiers
  static String fetchHistoryData(String _employeeId) =>
      "$baseUrl/hr.expense.sheet/search?domain=[('employee_id','=',$_employeeId)]"; //page_history | reimburse

  static String fetchExpenseData2(employeeId) =>
      "$baseUrl/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date','state']"; //history_reimburse_list | reimburse

  static String fetchExpenseData3(employeeId) =>
      "$baseUrl/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date']"; //detail_modal | reimburse

  // ignore: no_leading_underscores_for_local_identifiers
  static String fetchExpenseData4(_employeeId) =>
      "$baseUrl/hr.expense.sheet/search?domain=[('employee_id','=',$_employeeId),('state','=','draft')]"; //content_submit_report | reimburse

  static String submitData2() =>
      "$baseUrl/hr.expense.sheet/execute_kw"; //page_submit_report | reimburse

  static String fetchExpenses(userId) =>
      "$baseUrl/hr.expense.sheet/search?domain=[('user_id','=',$userId),('state','=','submit')]&fields=[]"; //content_approval | reimburse

  static String fetchExpenseData5(employeeId) =>
      "$baseUrl/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date','state']"; //content_report | reimburse

  static String fetchExpenseData6(employeeId) =>
      "$baseUrl/hr.expense/search?domain=%5B('employee_id','%3D',$employeeId)%5D&fields=['employee_id','name','product_id','total_amount_currency','date']"; //expense_modal | reimburse

  // static String fetchManagers() =>
  //     "$baseUrl/res.users/search?domain=[('groups_id','in',163)]&fields=['partner_id']"; //report/midle_content | reimburse

  static String approvalReimburse() =>
      "$baseUrl/hr.expense.sheet/execute_kw"; //dialog_approval | reimburse

  static String refuseReimburse() =>
      "$baseUrl/hr.expense.sheet/execute_kw"; //dialog_approval | reimburse
//
  static String fetchLatestSlipId(employeeId) =>
      '$baseUrl/hr.payslip/search?domain=[(\'employee_id\',\'=\',$employeeId)]&fields=[]'; //page_detail_payslip | payslip

  static String fetchPayslipData(domain) =>
      "$baseUrl/hr.payslip/search?domain=$domain&fields=[]"; //content_history | payslip

  static String fetchPayslipData2(slipId) =>
      '$baseUrl/hr.payslip.line/search?domain=[(\'slip_id\',\'=\',$slipId)]&fields=[\'name\',\'amount\',\'category_id\']'; //klik_detail_payslip | payslip

  static String validatePin() =>
      '$baseUrl/validate_pin'; //page_payslip_pin | payslip
//
  // ignore: no_leading_underscores_for_local_identifiers
  static String fetchHistoryData2(_employeeId) =>
      "$baseUrl/hr.overtime/search?domain=[('employee_id','=',$_employeeId)]"; //nav_submited | overtime

  static String createRequest() =>
      "$baseUrl/hr.overtime/create"; //page_request | overtime

  static String fetchOvertimeRules() =>
      "$baseUrl/overtime.rule/search?domain=[]&fields=['id','name']"; //top_content | overtime

  static String fetchOvertimeRules2() =>
      "$baseUrl/overtime.reason/search?domain=[]&fields=['id','name']"; //midle_content | overtime

  static String submitData() =>
      "$baseUrl/hr.overtime/execute_kw"; //page_submit_ovt | overtime

  // ignore: no_leading_underscores_for_local_identifiers
  static String fetchHistoryData3(_employeeId) =>
      "$baseUrl/hr.overtime/search?domain=[('employee_id','=',$_employeeId), ('state','=','draft')]"; //content_submit_ovt | overtime

  // ignore: no_leading_underscores_for_local_identifiers
  static String fetchHistoryData4(_employeeId) =>
      "$baseUrl/hr.overtime/search?domain=[('employee_id','=',$_employeeId)]"; //page_history | overtime

  static String fetchActivities3(userId) =>
      "$baseUrl/hr.overtime/search?domain=[('|'),('approver1_id','=',$userId),('approver2_id','=',$userId),('state','in',('submit','approved1'))]&fields=[]"; //content_approval | overtime

  static String sendApprovalRequest() =>
      "$baseUrl/hr.overtime/execute_kw"; //dialog_approval | overtime

  static String sendRefuseRequest() =>
      "$baseUrl/hr.overtime/execute_kw"; //dialog_approval | overtime
}
