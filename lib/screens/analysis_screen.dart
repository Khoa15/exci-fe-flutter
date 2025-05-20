import 'package:exci_flutter/models/user.dart';
import 'package:exci_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class AnalysisScreen extends StatefulWidget{
  const AnalysisScreen({super.key});

  @override
  State<StatefulWidget> createState() => AnalysisScreenState();
}
class AnalysisScreenState extends State<AnalysisScreen> {
  bool _isLoading = true;
  late User? _user;
  // late List<UserRank>? _listUserRank;
  @override
  void initState(){
    super.initState();

    _loadListRankUsers();
  }
  Future<void> _loadUser() async {
    User? user = await getUser();
    setState(() {
      _user = user;
    });
  }
  void _loadListRankUsers()async{
    try{
      await _loadUser();
      var result = await _user?.GetListRank();
      setState(() {
        // _listUserRank = result;
        _isLoading = false;
      });
    }catch(error){
        print(error);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Memory Analysis'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading ? Center(child: CircularProgressIndicator())
        : Column(
          children: [
            // Line Chart
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 20),
                        FlSpot(1, 35),
                        FlSpot(2, 55),
                        FlSpot(3, 65),
                        FlSpot(4, 90),
                        FlSpot(5, 75),
                        FlSpot(6, 85),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Bar Chart
            // Expanded(
            //   child: BarChart(
            //     BarChartData(
            //       alignment: BarChartAlignment.spaceAround,
            //       maxY: 100,
            //       barTouchData: BarTouchData(enabled: false),
            //       titlesData: FlTitlesData(
            //         show: true,
            //         bottomTitles: AxisTitles(
            //           sideTitles: SideTitles(
            //             showTitles: true,
            //             getTitlesWidget: (value, meta) {
            //               switch (value.toInt()) {
            //                 case 0:
            //                   return Text('Week 1');
            //                 case 1:
            //                   return Text('Week 2');
            //                 case 2:
            //                   return Text('Week 3');
            //                 case 3:
            //                   return Text('Week 4');
            //                 case 4:
            //                   return Text('Week 5');
            //                 default:
            //                   return Container();
            //               }
            //             },
            //           ),
            //         ),
            //       ),
            //       gridData: FlGridData(show: false),
            //       borderData: FlBorderData(show: false),
            //       barGroups: [
            //         BarChartGroupData(
            //           x: 0,
            //           barRods: [
            //             BarChartRodData(
            //               toY: 70,
            //               color: Colors.green,
            //               width: 20,
            //             ),
            //           ],
            //         ),
            //         BarChartGroupData(
            //           x: 1,
            //           barRods: [
            //             BarChartRodData(
            //               toY: 80,
            //               color: Colors.green,
            //               width: 20,
            //             ),
            //           ],
            //         ),
            //         BarChartGroupData(
            //           x: 2,
            //           barRods: [
            //             BarChartRodData(
            //               toY: 60,
            //               color: Colors.green,
            //               width: 20,
            //             ),
            //           ],
            //         ),
            //         BarChartGroupData(
            //           x: 3,
            //           barRods: [
            //             BarChartRodData(
            //               toY: 90,
            //               color: Colors.green,
            //               width: 20,
            //             ),
            //           ],
            //         ),
            //         BarChartGroupData(
            //           x: 4,
            //           barRods: [
            //             BarChartRodData(
            //               toY: 100,
            //               color: Colors.green,
            //               width: 20,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 20),
            // // Pie Chart
            // Expanded(
            //   child: PieChart(
            //     PieChartData(
            //       sections: [
            //         PieChartSectionData(
            //           color: Colors.blue,
            //           value: 50,
            //           title: 'Retained',
            //           radius: 50,
            //         ),
            //         PieChartSectionData(
            //           color: Colors.red,
            //           value: 20,
            //           title: 'Forgotten',
            //           radius: 50,
            //         ),
            //         PieChartSectionData(
            //           color: Colors.green,
            //           value: 30,
            //           title: 'Revised',
            //           radius: 50,
            //         ),
            //       ],
            //       sectionsSpace: 4,
            //       centerSpaceRadius: 40,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
