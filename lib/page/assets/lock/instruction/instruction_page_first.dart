import 'package:flutter/material.dart';
import 'package:polka_wallet/page/assets/lock/instruction/instruction_title.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:polka_wallet/utils/i18n/index.dart';

class LinearData {
  final int a;
  final double b;

  LinearData(this.a, this.b);
}

class InstructionPageFirst extends StatelessWidget {
  getSeriesList() {
    return [
      charts.Series<LinearData, int>(
        id: 'MXC',
        colorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (LinearData data, _) => data.a,
        measureFn: (LinearData data, _) => data.b,
        strokeWidthPxFn: (_, __) => 3,
        data: [
          LinearData(3, 1.03),
          LinearData(36, 1.2),
        ],
      ),
      charts.Series<LinearData, int>(
        id: 'DOT, IOTA',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearData data, _) => data.a,
        measureFn: (LinearData data, _) => data.b,
        strokeWidthPxFn: (_, __) => 3,
        data: [
          LinearData(3, 1.01),
          LinearData(36, 1.1),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bodyText = TextStyle(
      color: Colors.white,
      fontSize: 14,
    );
    var dic = I18n.of(context).instructions;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          InstructionTitle(1, dic['lock.pick_token']),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color(0xFF6B84EE),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Text(
              dic['lock.bridged_tokens'],
              style: bodyText,
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                width: 40,
                height: 40,
                child: Image.asset('assets/images/assets/MXC.png'),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                width: 40,
                height: 40,
                child: Image.asset('assets/images/assets/currencies/IOTA.png'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            dic['lock.signal_fee'],
            style: bodyText,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 50),
          InstructionTitle(2, 'MSB'),
          SizedBox(height: 8),
          Text(
            dic['lock.msb'],
            style: bodyText,
          ),
          SizedBox(height: 35),
          Container(
            height: 270,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: charts.LineChart(
                    getSeriesList(),
                    animate: false,
                    behaviors: [
                      charts.SeriesLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        entryTextStyle: charts.TextStyleSpec(
                          color: charts.Color.white,
                        ),
                        cellPadding: EdgeInsets.only(
                          top: 5,
                          right: 10,
                        ),
                      ),
                    ],
                    primaryMeasureAxis: charts.AxisSpec<num>(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          color: charts.Color.white,
                        ),
                      ),
                      tickProviderSpec: charts.StaticNumericTickProviderSpec([
                        charts.TickSpec(1),
                        charts.TickSpec(1.05),
                        charts.TickSpec(1.1),
                        charts.TickSpec(1.15),
                        charts.TickSpec(1.2),
                      ]),
                    ),
                    domainAxis: charts.AxisSpec<num>(
                      renderSpec: charts.GridlineRendererSpec(
                        labelStyle: charts.TextStyleSpec(
                          color: charts.Color.white,
                        ),
                        axisLineStyle: charts.LineStyleSpec(
                          color: charts.Color.black,
                        ),
                        lineStyle: charts.LineStyleSpec(
                          color: charts.Color.transparent,
                          thickness: 0,
                        ),
                      ),
                      tickProviderSpec: charts.StaticNumericTickProviderSpec([
                        charts.TickSpec(3),
                        charts.TickSpec(6),
                        charts.TickSpec(9),
                        charts.TickSpec(12),
                        charts.TickSpec(24),
                        charts.TickSpec(36),
                      ]),
                    ),
                  ),
                ),
                Positioned(
                  left: 35,
                  top: 5,
                  child: Text(
                    'MSB',
                    style: bodyText.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 2,
                  child: Text(
                    dic['lock.months'],
                    style: bodyText.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
