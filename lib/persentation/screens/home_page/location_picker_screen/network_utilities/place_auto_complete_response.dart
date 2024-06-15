import 'dart:convert';

class PlaceAutoCompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutoCompleteResponse({this.status, this.predictions});

  factory PlaceAutoCompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutoCompleteResponse(
        status: json['status'] as String?,
        // ignore: prefer_null_aware_operators
        predictions: json['predictions'] != null
            ? json['predictions']
                .map<AutocompletePrediction>(
                    (json) => AutocompletePrediction.fromJson(json))
                .toList()
            : null);
  }
  static PlaceAutoCompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutoCompleteResponse.fromJson(parsed);
  }
}

class AutocompletePrediction {
  final String? description;
  final StructuredFormatting? structuredFormatting;
  final String? placeId;
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
  });
  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;
  StructuredFormatting({this.mainText, this.secondaryText});
  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['seconday_text'] as String?,
    );
  }
}
