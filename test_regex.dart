void main() async {
  // Simulación de los regex
  final genericRegex = RegExp(
    r'^MHWilds-(.+?)_Icon_([A-Za-z]+(?:_[A-Za-z]+)?)_',
    caseSensitive: false,
  );
  
  String filename = 'MHWilds-Herb_Icon_Light_Green_13078b3e74.png';
  final match = genericRegex.firstMatch(filename);
  if (match != null) {
    print('Match for $filename:');
    print('Group 1: ${match.group(1)}');
    print('Group 2: ${match.group(2)}');
  } else {
    print('No match for $filename');
  }

  String filename2 = 'MHWilds-Herb-Cooking_Icon_Moss_a599921545.png';
  final match2 = genericRegex.firstMatch(filename2);
  if (match2 != null) {
    print('Match for $filename2:');
    print('Group 1: ${match2.group(1)}');
    print('Group 2: ${match2.group(2)}');
  } else {
    print('No match for $filename2');
  }
}
