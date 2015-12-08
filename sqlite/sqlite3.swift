import Foundation
import Sqlite3

var connection:COpaquePointer = nil

let error = sqlite3_open(":memory:", &connection)
if error != SQLITE_OK {
    // Open failed, close DB and fail
    print("SQLiteDB - failed to open DB!")
    sqlite3_close(connection)
}

var sql:String = "SELECT datetime('now') || ' -- formatted: ' || strftime('%Y-%m-%d %H:%M:%S')"

var stmt:COpaquePointer = nil

var result = sqlite3_prepare_v2(connection, sql, -1, &stmt, nil)
if result != SQLITE_OK {
    sqlite3_finalize(stmt)
    if let error = String.fromCString(sqlite3_errmsg(connection)) {
        let msg = "SQLiteDB - failed to prepare SQL: \(sql), Error: \(error)"
        print(msg)
    }
}

while (sqlite3_step(stmt) == SQLITE_ROW) {
    let buf = UnsafePointer<Int8>(sqlite3_column_text(stmt, 0))
    let val = String.fromCString(buf)
    print("\(val!)")
}

sqlite3_finalize(stmt)
sqlite3_close(connection)

