import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prob/api/fixed_consume.dart';
import 'package:prob/model/fixed_model.dart';
import 'package:prob/model/reqModel/add_consume_hist.dart';
import 'package:prob/provider/add_provider.dart';
import 'package:prob/provider/auth_provider.dart';
import 'package:prob/provider/fixed_provider.dart';
import 'package:prob/widgets/common/custom_alert.dart';
import 'package:prob/widgets/main_page/calendar_widget.dart';
import 'package:provider/provider.dart';

class FixedConsume extends StatelessWidget {
  const FixedConsume({super.key});
  static const dividerColor = Color(0xFFE39B3D);

  @override
  Widget build(context) {
    return Container(
      color: const Color(0xFFFFFBF5),
      child: Column(
        children: [
          const SizedBox(height: 55),
          Container(
            width: 345,
            height: 480,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: const Color(0xFFC19F64),
              ),
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '고정 지출',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B2304),
                    ),
                  ),
                ),
                const Divider(
                  color: Color(0xFFE39B3D),
                ),
                SizedBox(
                  height: 390,
                  child: Consumer2<AddProvider, FixedProvider>(
                      builder: (context, addProvider, fixedProvider, child) {
                    return FixedDataRow(
                      dividerColor: dividerColor.withOpacity(0.76),
                      addProvider: addProvider,
                      fixedProvider: fixedProvider,
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF9DEB9),
              ),
              onPressed: () async {
                _addModal(context: context, title: '고정지출 추가', histId: -1);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 7, horizontal: 26),
                child: Text(
                  "+ 추가",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3B2304),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FixedDataRow extends StatelessWidget {
  const FixedDataRow({
    required this.dividerColor,
    required this.addProvider,
    required this.fixedProvider,
    super.key,
  });
  final Color dividerColor;
  final FixedProvider fixedProvider;
  final AddProvider addProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(0),
      itemCount: fixedProvider.fixedList.length,
      itemBuilder: (context, index) {
        final hist = fixedProvider.fixedList[index];
        return _listRow(
            context: context,
            fixedProvider: fixedProvider,
            hist: hist,
            provider: addProvider);
      },
      separatorBuilder: (context, index) {
        return Divider(color: dividerColor, thickness: 0.3, height: 0);
      },
    );
  }

  Widget _listRow(
      {required BuildContext context,
      required FixedModel hist,
      required FixedProvider fixedProvider,
      required AddProvider provider}) {
    const textColor = Color(0xFF3B2304);
    String formatNumberWithComma(int number) {
      final formatter = NumberFormat('#,###');
      return formatter.format(number);
    }

    return TextButton(
      onPressed: () {
        provider.setFixedInfo(
            date: hist.startDate,
            amount: '${hist.amount}',
            cardName: hist.card,
            categoryName: hist.categoryName,
            receiver: hist.receiver);
        _addModal(context: context, title: '상세 내역', histId: hist.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                hist.receiver,
                style: const TextStyle(
                  fontSize: 15,
                  color: textColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              "${formatNumberWithComma(hist.amount)} 원",
              style: const TextStyle(
                fontSize: 15,
                color: textColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _addModal(
    {required BuildContext context,
    required String title,
    required int histId}) {
  Future<void> saveData(BuildContext context, AddProvider addProvider) async {
    final authProvider = context.read<AuthProvider>();
    bool isTokenValid = await authProvider.checkAndRefreshToken();

    if (isTokenValid) {
      final accessToken = authProvider.accessToken;
      try {
        final fields = addProvider.getFieldValues();

        final addConsumeHist = AddConsumeHist(
          amount: fields['amount'],
          categoryName: fields['category'],
          installment: '0',
          repeat: true,
          content: fields['content'],
          card: fields['card'],
          date: fields['date'].toString().replaceAll(" ", ""),
        );

        final updatedData =
            await FixedConsumeApi.addFixed(addConsumeHist, accessToken);
        if (context.mounted) {
          context.read<FixedProvider>().setFixedList(updatedData);
        }

        addProvider.resetFields();

        if (context.mounted) {
          showCustomSnackBar(context, '저장 완료');
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
        }
      }
    } else {
      if (context.mounted) {
        MyAlert.failShow(context, '다시 로그인 해주세요', null);
      }
    }
  }

  Future<void> removeData(BuildContext context, AddProvider addProvider) async {
    final fixedProvider = context.read<FixedProvider>();
    final authProvider = context.read<AuthProvider>();
    bool isTokenValid = await authProvider.checkAndRefreshToken();

    if (isTokenValid) {
      final accessToken = authProvider.accessToken;
      try {
        final removed = await FixedConsumeApi.removeFixed(histId, accessToken);

        if (removed && context.mounted) {
          fixedProvider.removeFixedConsume(histId);
          showCustomSnackBar(context, '삭제 완료');
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          MyAlert.failShow(context, '요청 실패. 다시 시도 해주세요', null);
        }
      }
    } else {
      if (context.mounted) {
        MyAlert.failShow(context, '다시 로그인 해주세요', null);
      }
    }
  }

  const textStyle = TextStyle(color: Color(0xFF3B2304), fontSize: 17);
  const dividerColor = Color(0xFFE1E1E1);
  const maxWidth = 400.0; //MediaQuery.of(context).size.width - 46;
  const maxHeight = 600.0;
  showDialog(
    context: context,
    barrierDismissible: true, // 다이얼로그 외부 클릭 시 닫힘 여부
    builder: (BuildContext context) {
      final addProvider = context.watch<AddProvider>();
      return GestureDetector(
        behavior: HitTestBehavior.opaque, // 빈 공간도 감지
        child: AlertDialog(
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
                  padding:
                      const EdgeInsets.only(top: 18.0, bottom: 16, left: 16),
                  child: Text(title, style: textStyle),
                ),
                const Divider(color: dividerColor, thickness: 1, height: 0),
                histId == -1
                    ? const ModalItem(textStyle: textStyle, subTitle: '날짜')
                    : ModalItemDetail(
                        textStyle: textStyle,
                        subTitle: '날짜',
                        content: addProvider.dateController.text,
                      ),
                // 항목
                histId == -1
                    ? const ModalItem(textStyle: textStyle, subTitle: '항목')
                    : ModalItemDetail(
                        textStyle: textStyle,
                        subTitle: '항목',
                        content: addProvider.contentController.text,
                      ),
                // 분류
                histId == -1
                    ? const ModalItem(textStyle: textStyle, subTitle: '분류')
                    : ModalItemDetail(
                        textStyle: textStyle,
                        subTitle: '분류',
                        content: addProvider.categorySelected,
                      ),
                // 카드
                histId == -1
                    ? const ModalItem(textStyle: textStyle, subTitle: '카드')
                    : ModalItemDetail(
                        textStyle: textStyle,
                        subTitle: '카드',
                        content: addProvider.cardSelected == 'none'
                            ? '없음'
                            : addProvider.cardSelected,
                      ),
                // 금액
                histId == -1
                    ? const ModalItem(textStyle: textStyle, subTitle: '금액')
                    : ModalItemDetail(
                        textStyle: textStyle,
                        subTitle: '금액',
                        content: addProvider.amountController.text,
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          addProvider.resetFields();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDBCDCF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 40.0),
                        ),
                        child: Text(
                          title == '상세 내역' ? '닫기' : '취소',
                          style: const TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: title == '상세 내역'
                            ? () async {
                                await removeData(context, addProvider);
                              }
                            : () async {
                                final valid =
                                    addProvider.validateFields(isRepeat: true);

                                if (valid) {
                                  await saveData(context, addProvider);
                                } else {
                                  if (addProvider.installmentError != null) {
                                    if (context.mounted) {
                                      MyAlert.failShow(context,
                                          addProvider.installmentError!, null);
                                    }
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: title == '상세 내역'
                              ? const Color(0xFFE2344D)
                              : const Color(0xFF5366DF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7.0, horizontal: 40.0),
                        ),
                        child: Text(
                          title == '상세 내역' ? '삭제' : '저장',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

class ModalItemDetail extends StatelessWidget {
  const ModalItemDetail({
    super.key,
    required this.textStyle,
    required this.subTitle,
    required this.content,
  });

  final String subTitle;
  final TextStyle textStyle;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 27.0 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subTitle, style: textStyle),
          const SizedBox(width: 42),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF707070)),
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                content.isNotEmpty ? content : '없음',
                style: const TextStyle(fontSize: 15, color: Color(0xFF3B2304)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
