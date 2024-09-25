//
//  File.swift
//  
//
//  Created by Nexus on 8/6/24.
//


import Foundation
import Fluent
//
//struct CreateAnalytics: Migration {
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema(AnalyticsModel.schema)
//            .id()
//            .field(.urlID, .uuid, .required, .references(URLModel.schema, .id, onDelete: .cascade))
//            .field(.userIP, .string, .required)
//            .field(.userAgent, .string, .required)
//            .field(.browser, .string, .required)
//            .field(.browserVersion, .string, .required)
//            .field(.created_At, .datetime, .required)
//            .create()
//    }
//    
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema(AnalyticsModel.schema).delete()
//    }
//}


struct CreateAnalytics: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("analytics")
            .id()
            .field(.ip_address, .string)
            .field(.user_agent, .string)
            .field(.app_language, .string)
            .field(.device_name, .string)
            .field(.platforma, .string)
            .field(.app_version, .string)
            .field(.device_id, .string)
            .field(.api_key, .string)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("analytics").delete()
    }
}

