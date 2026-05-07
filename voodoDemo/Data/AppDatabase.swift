import Foundation
import GRDB
import os.log

/// The type that provides access to the application database.
///
/// For example:
///
/// ```swift
/// // Create an empty, in-memory, AppDatabase
/// let config = AppDatabase.makeConfiguration()
/// let dbQueue = try DatabaseQueue(configuration: config)
/// let appDatabase = try AppDatabase(dbQueue)
/// ```
final class AppDatabase: Sendable {
  /// Access to the database.
  ///
  /// See <https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/databaseconnections>
  private let dbWriter: any DatabaseWriter
  
  /// Creates a `AppDatabase`, and makes sure the database schema
  /// is ready.
  ///
  /// - important: Create the `DatabaseWriter` with a configuration
  ///   returned by ``makeConfiguration(_:)``.
  init(_ dbWriter: any GRDB.DatabaseWriter) throws {
    self.dbWriter = dbWriter
    try migrator.migrate(dbWriter)
  }
  
  /// The DatabaseMigrator that defines the database schema.
  ///
  /// See <https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/migrations>
  private var migrator: DatabaseMigrator {
    var migrator = DatabaseMigrator()
    
#if DEBUG
    // Speed up development by nuking the database when migrations change
    // See <https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/migrations#The-eraseDatabaseOnSchemaChange-Option>
    migrator.eraseDatabaseOnSchemaChange = true
#endif
    
    migrator.registerMigration("v1") { db in
      try db.create(table: ExampleModel.databaseTableName) { t in
        t.autoIncrementedPrimaryKey("id")
        // Required columns
        t.column("id", .text).primaryKey()
        
        // Other columns
        t.column("propertyName", .text).defaults(to: "")
      }
    }
    
    // Migrations for future application versions will be inserted here:
    // migrator.registerMigration(...) { db in
    //     ...
    // }
    
    return migrator
  }
}

// MARK: - Database Configuration

extension AppDatabase {
  // Uncomment for enabling SQL logging
  // private static let sqlLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")
  
  /// Returns a database configuration suited for `AppDatabase`.
  static func makeConfiguration(_ config: Configuration = Configuration()) -> Configuration {
    return config
  }
}

// MARK: - Database Access: Writes

extension AppDatabase {
  func saveOwner(_ word: inout ExampleModel) throws {
    try dbWriter.write { db in
      try word.save(db)
    }
  }
  func deleteAllOwners() throws {
    try dbWriter.write { db in
      _ = try ExampleModel.deleteAll(db)
    }
  }
}

// MARK: - Database Access: Reads

extension AppDatabase {
  /// Provides a read-only access to the database.
  var reader: any GRDB.DatabaseReader {
    dbWriter
  }
}


//MARK: Persistence

extension AppDatabase {
  /// The database for the application
  static let shared = makeShared()
  
  private static func makeShared() -> AppDatabase {
    do {
      // Apply recommendations from
      // <https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/databaseconnections>
      
      // Create the "Application Support/Database" directory if needed
      let fileManager = FileManager.default
      let appSupportURL = try fileManager.url(
        for: .applicationSupportDirectory, in: .userDomainMask,
        appropriateFor: nil, create: true)
      let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
      try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
      
      // Open or create the database
      let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
      let config = AppDatabase.makeConfiguration()
      let dbPool = try DatabasePool(path: databaseURL.path, configuration: config)
      
      // Create the AppDatabase
      let appDatabase = try AppDatabase(dbPool)
      return appDatabase
      
    } catch {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate.
      //
      // Typical reasons for an error here include:
      // * The parent directory cannot be created, or disallows writing.
      // * The database is not accessible, due to permissions or data protection when the device is locked.
      // * The device is out of space.
      // * The database could not be migrated to its latest schema version.
      // Check the error message to determine what the actual problem was.
      fatalError("Unresolved error \(error)")
    }
  }
}

//MARK: Previews

extension AppDatabase {
  // Creates an empty database for SwiftUI previews
  static func empty() -> AppDatabase {
    // See https://swiftpackageindex.com/groue/GRDB.swift/documentation/grdb/databaseconnections
    let dbQueue = try! DatabaseQueue(configuration: AppDatabase.makeConfiguration())
    return try! AppDatabase(dbQueue)
  }
}

