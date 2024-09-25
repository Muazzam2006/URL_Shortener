

import Foundation
import Vapor
import Fluent

final class URLModel: Model {
    static let schema = "urls"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .originalURL)
    var originalURL: String
    
    @Field(key: .shortURL)
    var shortURL: String
    
    @OptionalField(key: .customURL)
    var customURL: String?
    
    @Field(key: .URLStatus)
    var URLStatus: String
    
//    @Field(key: .availableTill)
//    var availableTill: Double?
    
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(originalURL: String, shortURL: String, customURL: String? = nil){
        self.originalURL = originalURL
        self.shortURL = shortURL
        self.customURL = customURL
        self.createdAt = Date()
        self.URLStatus = "available"
//        self.availableTill = availableTill
    }
    
//    func softDelete(on database: Database) async throws {
//        self.deletedAt = Date()
//        try await self.update(on: database)
//    }
//    
//    func restore(on database: Database) async throws {
//        self.deletedAt = nil
//        try await self.update(on: database)
//    }
}

extension FieldKey {
    static var originalURL: Self {"original_url"}
    static var shortURL: Self {"short_url"}
    static var customURL: Self {"custom_url"}
    static var createdAt: Self {"created_at"}
    static var updatedAt: Self {"updated_at"}
    static var deletedAt: Self {"deleted_at"}
    static var URLStatus: Self {"url_status"}
    static var availableTill: Self{"available_till"}
}
