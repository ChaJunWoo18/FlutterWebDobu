import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/api/saving.dart';
import 'package:prob/model/income_model.dart';
import 'package:prob/model/saving_model.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/income_provider.dart';
import 'package:prob/provider/saving_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/main_page/calendar_widget.dart';
import 'package:prob/widgets/profile/fixed_consume/date_picker.dart';
import 'package:provider/provider.dart';
import 'package:speech_balloon/speech_balloon.dart';

class Saving extends StatefulWidget {
  const Saving({super.key});

  @override
  State<Saving> createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  @override
  void initState() {
    super.initState();
    final savingProvider = context.read<SavingProvider>();
    final incomeProvider = context.read<IncomeProvider>();
    final authProvider = context.read<AuthProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchIncomeWithAuthCheck(
        authProvider: authProvider,
        context: context,
        incomeProvider: incomeProvider,
      );
      fetchSavingsWithAuthCheck(
        authProvider: authProvider,
        context: context,
        savingProvider: savingProvider,
      );
    });
  }

  void fetchSavingsWithAuthCheck(
      {required BuildContext context,
      required SavingProvider savingProvider,
      required AuthProvider authProvider}) async {
    final accessToken = await context.read<AuthProvider>().getToken();
    if (accessToken == 'fail' && context.mounted) {
      MyAlert.failShow(context, '로그인 만료', '/');
    }
    savingProvider.fetchSavingsData(accessToken);
  }

  void fetchIncomeWithAuthCheck(
      {required BuildContext context,
      required IncomeProvider incomeProvider,
      required AuthProvider authProvider}) async {
    if (incomeProvider.incomeData == null) {
      final accessToken = await context.read<AuthProvider>().getToken();
      if (accessToken == 'fail' && context.mounted) {
        MyAlert.failShow(context, '로그인 만료', '/');
      }

      incomeProvider.fetchIncomeData(accessToken);
    }
  }

  double calculatePercentage(
      List<SavingModel> savings, IncomeModel incomeData, int index) {
    final totalSavings =
        savings.fold<int>(0, (sum, saving) => sum + saving.amount);
    int income = 0;
    switch (index) {
      case 0:
        income = incomeData.twoMonthAgoIncome == 0
            ? 1
            : incomeData.twoMonthAgoIncome;
        break;
      case 1:
        income = incomeData.preIncome == 0 ? 1 : incomeData.preIncome;
        break;
      case 2:
        income = incomeData.curIncome == 0 ? 1 : incomeData.curIncome;
        break;
    }
    // final income = incomeData.curIncome == 0 ? 1 : incomeData.curIncome;
    final result = (totalSavings / income) * 100;
    if (result >= 100) {
      return 100;
    }
    return result;
  }

  String generateMessage(double percent) {
    if (percent == 0) {
      return '저축 내역이 없어요';
    } else if (percent < 40) {
      return '더 분발해야해요!';
    } else if (percent < 60) {
      return '충분히 저축했어요!';
    } else {
      return '훌륭해요!';
    }
  }

  String formatNumberWithComma(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF3B2304);
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xFFFFFBF5),
        child: Consumer2<SavingProvider, IncomeProvider>(
          builder: (context, savingProvider, incomeProvider, child) {
            if (savingProvider.isLoading || incomeProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (savingProvider.errorMessage != null ||
                incomeProvider.errorText != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      savingProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF9DEB9),
                      ),
                      onPressed: () async {
                        fetchIncomeWithAuthCheck(
                          authProvider: context.read<AuthProvider>(),
                          context: context,
                          incomeProvider: incomeProvider,
                        );
                        fetchSavingsWithAuthCheck(
                          authProvider: context.read<AuthProvider>(),
                          context: context,
                          savingProvider: savingProvider,
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 7, horizontal: 26),
                        child: Text(
                          "재시도",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final cardData = savingProvider.savingsData;
            final incomeData = incomeProvider.incomeData;
            return Column(
              children: [
                ...List.generate(cardData.length, (index) {
                  // print(index);
                  final data = cardData[index];
                  final percent =
                      calculatePercentage(data.savings, incomeData!, index);
                  return SavingsCard(
                    month: data.month,
                    percentage:
                        percent, //calculatePercentage(data.savings, incomeData),
                    message: generateMessage(percent),
                    black: black,
                    dataList: data.savings,
                  );
                }),
                const SizedBox(height: 40),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF9DEB9),
                  ),
                  onPressed: () async {
                    _addModal(
                      context: context,
                      title: '저축내역 추가',
                      itemId: -1,
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 26),
                    child: Text(
                      "+ 추가",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void _addModal(
    {required BuildContext context,
    required String title,
    required int itemId}) {
  Future<void> saveData(BuildContext context) async {
    final savingProvider = context.read<SavingProvider>();
    final accessToken = await context.read<AuthProvider>().getToken();
    if (accessToken == 'fail' && context.mounted) {
      MyAlert.failShow(context, '로그인 만료', '/');
    }

    try {
      final newData = savingProvider.getFieldValues();
      final savingMap = await SavingApi.addSaving(newData, accessToken);
      savingProvider.setSavings(savingMap);
      savingProvider.resetFields();
      if (context.mounted) {
        showCustomSnackBar(context, '저장 완료');
        Navigator.of(context).pop();
      }
    } catch (e) {
      // print(e);
      if (context.mounted) {
        MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
      }
    }
  }

  Future<void> removeData(BuildContext context, int itemId) async {
    final savingProvider = context.read<SavingProvider>();
    final accessToken = await context.read<AuthProvider>().getToken();
    if (accessToken == 'fail' && context.mounted) {
      MyAlert.failShow(context, '로그인 만료', '/');
    }

    try {
      final data = await SavingApi.removeSaving(itemId, accessToken);
      savingProvider.setSavings(data);
      savingProvider.resetFields();
      if (context.mounted) {
        showCustomSnackBar(context, '삭제 완료');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
      }
    }
  }

  const black = Color(0xFF3B2304);
  const textStyle = TextStyle(color: black, fontSize: 17);
  const dividerColor = Color(0xFFE1E1E1);
  const maxWidth = 300.0;
  const maxHeight = 500.0;
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      final savingProvider = context.read<SavingProvider>();
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        content: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 16, left: 16),
                child: Text(title, style: textStyle),
              ),
              const Divider(color: dividerColor, thickness: 1, height: 0),
              Consumer<SavingProvider>(builder: (context, provider, child) {
                return SavingItem(
                  subTitle: '날짜',
                  controller: provider.dateController,
                  errorText: provider.dateError,
                  provider: provider,
                  black: black,
                );
              }),
              Consumer<SavingProvider>(builder: (context, provider, child) {
                return SavingItem(
                  subTitle: '항목',
                  controller: provider.receiverController,
                  errorText: provider.receiverError,
                  provider: provider,
                  black: black,
                );
              }),
              Consumer<SavingProvider>(builder: (context, provider, child) {
                return SavingItem(
                    subTitle: '금액',
                    controller: provider.amountController,
                    errorText: provider.amountError,
                    provider: provider,
                    black: black);
              }),
              const SizedBox(height: 47),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        savingProvider.resetFields();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDBCDCF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 7.0, horizontal: 40.0),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Color(0xFF4F4F4F),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    title == '저축내역 추가'
                        ? ElevatedButton(
                            onPressed: () async {
                              final valid = savingProvider.validateFields(
                                  isRepeat: false);
                              if (valid) {
                                await saveData(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5366DF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 40.0),
                            ),
                            child: const Text(
                              '저장',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              // addProvider.resetFields();
                              await removeData(context, itemId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE2344D),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.0, horizontal: 40.0),
                            ),
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                  ],
                ),
              ),
              const SizedBox(height: 23)
            ],
          ),
        ),
      );
    },
  );
}

class SavingItem extends StatelessWidget {
  const SavingItem(
      {super.key,
      required this.subTitle,
      required this.controller,
      this.errorText,
      required this.provider,
      required this.black});

  final String subTitle;
  final Color black;
  final dynamic controller;
  final String? errorText;
  final SavingProvider provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(30).copyWith(bottom: 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: black,
            ),
          ),
          const SizedBox(width: 42),
          Expanded(
              child: subTitle == '날짜'
                  ? DatePickerWithTextField(provider: provider)
                  : TextField(
                      controller: controller,
                      cursorColor: const Color(0xFF707070),
                      cursorWidth: 1,
                      style: TextStyle(fontSize: 15, color: black),
                      decoration: InputDecoration(
                        errorText: errorText,
                        errorStyle: const TextStyle(fontSize: 10),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 136, 81, 10),
                                width: 1.5)),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(color: Color(0xFF707070))),
                      ),
                    ))
        ]));
  }
}

class SavingsCard extends StatelessWidget {
  final String month;
  final double percentage;
  final String message;
  final Color black;
  final List<SavingModel> dataList;

  const SavingsCard(
      {super.key,
      required this.month,
      required this.percentage,
      required this.message,
      required this.black,
      required this.dataList});

  @override
  Widget build(BuildContext context) {
    const cardHorPadding = 13.0;
    const bodyHorPadding = 16.0;
    return Card(
      margin: const EdgeInsets.only(
          top: 40, left: cardHorPadding, right: cardHorPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: header(month: month),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: bodyHorPadding, right: bodyHorPadding, bottom: 28),
          child: body(
              context: context,
              totalPadding: (cardHorPadding + bodyHorPadding) * 2),
        ),
      ]),
    );
  }

  Widget header({required String month}) {
    return Column(
      children: [
        Center(
          child: Text(
            "$month 월",
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF3B2304),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(
          color: Color.fromRGBO(59, 35, 4, 0.48),
        ),
      ],
    );
  }

  Widget body({required BuildContext context, required double totalPadding}) {
    final linearWidth = MediaQuery.of(context).size.width - totalPadding;
    const balloonWidth = 28.0;
    final leftPosition = (percentage / 100) * linearWidth - (balloonWidth / 2);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform.translate(
            offset: const Offset(0, -7),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Color(0xFFAF6B12),
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: const Size(15, 35),
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.all(10)),
            onPressed: () =>
                _showSavingsDetail(context, black, month, dataList),
            child: const Text(
              '자세히 보기',
              style: TextStyle(color: Color(0xFF3B2304), fontSize: 12),
            ),
          ),
        ],
      ),
      const SizedBox(height: 35),

      // 진행률 표시줄
      Stack(
        clipBehavior: Clip.none,
        children: [
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: const Color(0xFFBC6E9B),
            color: const Color(0xFF7F84C8),
            minHeight: 7,
            borderRadius: BorderRadius.circular(0),
          ),
          Positioned(
            left: leftPosition,
            top: -30,
            child: SpeechBalloon(
              width: balloonWidth,
              height: 20,
              borderColor: const Color(0xFF3B2304),
              color: Colors.white,
              child: Center(
                child: Text(
                  "${percentage.toStringAsFixed(0)}%",
                  style: TextStyle(
                    color: const Color(0xFF3B2304),
                    fontSize: percentage == 100.0 ? 10 : 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

//자세히 보기
void _showSavingsDetail(
    BuildContext context, Color black, String month, List<SavingModel> data) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      const divider =
          Divider(color: Color(0xFFE1E1E1), height: 0, thickness: 1);
      const textStyle = TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFA1978A));
      const padding = EdgeInsets.only(left: 24, right: 19, top: 16, bottom: 16);
      final totalAmount = data.fold<int>(0, (sum, item) => sum + item.amount);
      final savingProvider = context.read<SavingProvider>();
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12, top: 26, left: 21),
                child: Text(
                  "저축내역 상세 - $month월",
                  style: TextStyle(
                    fontSize: 17,
                    color: black,
                  ),
                ),
              ),
              divider,
              ListView.separated(
                shrinkWrap: true,
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    final saving = data[index];
                    return _buildRow(saving, padding, context);
                  } else {
                    return divider;
                  }
                },
                separatorBuilder: (context, index) => divider,
              ),
              Padding(
                padding: padding.copyWith(right: 32, left: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL', style: textStyle),
                    Text(savingProvider.formatNumberWithComma(totalAmount),
                        style: textStyle),
                  ],
                ),
              ),
              divider,
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDBCDCF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 7.0, horizontal: 40.0),
                  ),
                  child: const Text(
                    '닫기',
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 23)
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildRow(SavingModel saving, EdgeInsets padding, BuildContext context) {
  const textStyle = TextStyle(color: Color(0xFFA1978A), fontSize: 15);
  final provider = context.read<SavingProvider>();
  return TextButton(
    onPressed: () {
      provider.setEditInfo(
          amount: saving.amount, date: saving.date, receiver: saving.receiver);
      _addModal(context: context, title: '저축내역 상세', itemId: saving.id);
    },
    child: Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            saving.receiver,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
          Text(provider.formatNumberWithComma(saving.amount), style: textStyle),
        ],
      ),
    ),
  );
}

class ProgressWithLabel extends StatelessWidget {
  final double percentage;

  const ProgressWithLabel({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerLeft,
        children: [
          Container(
            width: double.infinity,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              widthFactor: percentage / 100,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: MediaQuery.of(context).size.width * (percentage / 100) - 25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${percentage.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  CustomPaint(
                    painter: TrianglePainter(),
                    size: const Size(10, 5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 말풍선 아래 삼각형
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(size.width / 2, 0) // 시작점
      ..lineTo(0, size.height) // 왼쪽 점
      ..lineTo(size.width, size.height) // 오른쪽 점
      ..close();

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
