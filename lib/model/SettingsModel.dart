class Setting {
  final int id;
  final String Lkey;
  final String EndTime;
  final String BufferTime;
  final String BookingSlot;



  Setting({
    this.id,
    this.Lkey,
    this.EndTime,
    this.BufferTime,
    this.BookingSlot,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Lkey': Lkey,
      'EndTime': EndTime,
      'BufferTime': BufferTime,
      'BookingSlot': BookingSlot,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'LocationKey{id: $id, Lkey : $Lkey, EndTime: $EndTime, BufferTime: $BufferTime, BookingSlot: $BookingSlot';
  }
}