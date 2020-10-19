
class Weight{
  final String weight;
  final DateTime timestamp;

  Weight(this.weight, this.timestamp);

  Weight.fromMap(Map<String, dynamic> map)
  :     assert(map['weight']!=null),
        assert(map['timestamp']!=null),
  weight = map['weight'],
  timestamp = map['timestamp'].toDate();

  @override
  String toString() => "Record<$weight: $timestamp>";
}