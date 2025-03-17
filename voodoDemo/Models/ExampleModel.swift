import GRDB

// MARK: Example setup of a model that could be used it data storage

final class ExampleModel {
  
  static let databaseTableName = "example_model" /// used specifically for GRDB

  var id: Int?
  let propertyName: String
}

extension ExampleModel: Codable, FetchableRecord, MutablePersistableRecord {
  enum Columns {
    static let id = Column(CodingKeys.id)
    static let propertyName = Column(CodingKeys.propertyName)
  }
  
  func didInsert(_ inserted: InsertionSuccess) {
    id = Int(inserted.rowID)
  }
}

extension DerivableRequest<ExampleModel> {
  func orderedByName() -> Self {
    order(ExampleModel.Columns.propertyName.collating(.localizedCaseInsensitiveCompare))
  }
}
