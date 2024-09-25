//
//  File.swift
//  
//
//  Created by Nexus on 8/6/24.
//

import Foundation
import Vapor
import Fluent

struct URLMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(URLModel.schema)
            .id()
            .field(.originalURL, .string)
            .field(.shortURL, .string)
            .field(.customURL, .string)
            .field(.URLStatus, .string)
            .field(.createdAt, .date)
            .field(.updatedAt, .date)
            .field(.deletedAt, .date)
//            .field(.availableTill, .double)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(URLModel.schema).delete()
    }
}
