import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:digital_library/core/providers/settings_provider.dart';

class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;

    final List<Map<String, dynamic>> activeLoans = [
      {
        'title': 'البرمجة بلغة بايثون',
        'loan_date': '2026-08-20',
        'due_date': '2026-09-05',
        'status': 'active',
        'fine_amount': 0.00,
        'days_left': 8,
      },
      {
        'title': 'هياكل البيانات',
        'loan_date': '2026-08-01',
        'due_date': '2026-08-15',
        'status': 'overdue',
        'fine_amount': 500.00,
        'days_left': -13,
      },
    ];

    final List<Map<String, dynamic>> returnedLoans = [
      {
        'title': 'مقدمة في علوم الحاسب',
        'loan_date': '2026-03-01',
        'return_date': '2026-03-14',
        'status': 'returned',
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,

        body: SafeArea(
          child: Column(
            children: [
              // 1. الترويسة العلوية الموحدة (متوافقة مع اتجاه اللغة)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // العنوان في المنتصف
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'general_main_screen.my_loans'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),

                      // زر الرجوع القياسي (يتكيف تلقائياً مع لغة التطبيق RTL / LTR)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              size: 22
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 2. شريط التبويبات الموحد
              Container(
                color: Colors.transparent,
                child: TabBar(
                  dividerColor: Colors.transparent,
                  labelColor: primaryGreen,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryGreen,
                  labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: 'الحالية والكتب المتأخرة'),
                    Tab(text: 'سجل القراءة'),
                  ],
                ),
              ),

              // 3. محتوى التبويبات
              Expanded(
                child: TabBarView(
                  children: [
                    _buildLoansList(activeLoans, isDarkMode, primaryGreen, isActiveList: true),
                    _buildLoansList(returnedLoans, isDarkMode, primaryGreen, isActiveList: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoansList(List<Map<String, dynamic>> loans, bool isDarkMode, Color primaryGreen, {required bool isActiveList}) {
    if (loans.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد بيانات',
          style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        final isOverdue = loan['status'] == 'overdue';

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverdue ? Colors.red.withOpacity(0.5) : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              width: isOverdue ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isOverdue ? Colors.red.withOpacity(0.1) : primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                          Icons.book,
                          color: isOverdue ? Colors.red : primaryGreen,
                          size: 32
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loan['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade500),
                              const SizedBox(width: 4),
                              Text(
                                'تاريخ الإعارة: ${loan['loan_date']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),

                if (isActiveList) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تاريخ الإرجاع المطلوب:',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: 'Cairo'),
                          ),
                          Text(
                            loan['due_date'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isOverdue ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOverdue
                              ? 'متأخر (${loan['days_left'].abs()} أيام)'
                              : 'متبقي ${loan['days_left']} أيام',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isOverdue ? Colors.red : Colors.orange.shade800,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (loan['fine_amount'] > 0) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'غرامة تأخير مسجلة: ${loan['fine_amount']} ريال',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'تم الإرجاع بنجاح في: ${loan['return_date']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}