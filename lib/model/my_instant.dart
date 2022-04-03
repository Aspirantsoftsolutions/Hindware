import 'package:SomanyHIL/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_instant.g.dart';

@JsonSerializable()
class MyInstant {
  int epochSecond;
  int nano;

  MyInstant({
    this.epochSecond,
    this.nano,
  });

  factory MyInstant.fromJson(Map<String, dynamic> json) {
    return _$MyInstantFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MyInstantToJson(this);

  String stringDate() {
    String date = '';
    try {
      if (epochSecond != null) {
        date = DateTime.fromMillisecondsSinceEpoch(epochSecond * 1000)
            .toUtc()
            .toIso8601String();
      }
    } catch (e) {}
    return date;
  }

  String formatedDateForHistory({String formateTo = 'hh:mm a yyyy-MM-dd'}) {
    String date = '';
    try {
      if (epochSecond != null) {
        date =
            DateTime.fromMillisecondsSinceEpoch(epochSecond).toUtc().toString();
        date = Utils.formateDate(date: date, formateTo: formateTo);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return date;
  }
}
