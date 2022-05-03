import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/course_unit_sheet.dart';

import '../../../model/app_state.dart';
import '../request_dependent_widget_builder.dart';
import 'course_unit_sheet_card.dart';

class CourseUnitsSheetsView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CourseUnitsSheetsViewState();
}

class _CourseUnitsSheetsViewState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,
            Tuple2<List<CourseUnitSheet>, RequestStatus>>(
        builder: (context, courseUnitsSheetsData) {
          final courseUnitsSheets = courseUnitsSheetsData.item1;
          final courseUnitsSheetsStatus = courseUnitsSheetsData.item2;
          return RequestDependentWidgetBuilder(
            context: context,
            onNullContent: Center(child: Text('A carregar...')),
            status: courseUnitsSheetsStatus,
            content: courseUnitsSheets,
            contentChecker: courseUnitsSheets?.isNotEmpty ?? false,
            contentGenerator: (dynamic courseUnitSheets, BuildContext context) {
              final List<Widget> activeCourseCards = [];
              final List<Widget> pastCourseCards = [];
              courseUnitsSheets.forEach((courseUnitSheet) {
                if (courseUnitSheet.active) {
                  activeCourseCards.add(CourseUnitSheetCard(courseUnitSheet));
                } else {
                  pastCourseCards.add(CourseUnitSheetCard(courseUnitSheet));
                }
              });
              return ListView(
                  children: [
                Container(
                    padding: EdgeInsets.fromLTRB(30, 20, 0, 5),
                    child: Text(
                      'Por concluir',
                      textScaleFactor: 0.8,
                    )),
              ]
                    ..addAll(activeCourseCards)
                    ..addAll([
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 20, 0, 5),
                          child: Text(
                            'Concluídas',
                            textScaleFactor: 0.8,
                          )),
                    ])
                    ..addAll(pastCourseCards));
            },
          );
        },
        converter: (store) => Tuple2(store.state.content['ucsSheets'],
            store.state.content['ucsSheetsStatus']));
  }
}
