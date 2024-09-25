import Foundation
import Vapor
import Fluent

struct ShortURLController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let shortURL = routes.grouped("shortURL")
        
        shortURL.post() { req async throws -> String in
            let urls = try req.content.decode(Link.self)
            let origURL = urls.originalURL
            
            var shURL = randUrl(from: chars, length: 8)
            while true {
                let exists = try await URLModel.query(on: req.db)
                    .filter(\.$shortURL == shURL)
                    .filter(\.$deletedAt == nil)
                    .first()
                
                if exists == nil {
                    break
                }
                
                shURL = randUrl(from: chars, length: 8)
            }
            
            if let customURL = urls.customURL {
                let someURL = URLModel(originalURL: origURL, shortURL: shURL, customURL: customURL)
                try await someURL.save(on: req.db)
            } else {
                let someURL = URLModel(originalURL: origURL, shortURL: shURL)
                try await someURL.save(on: req.db)
            }
            
            return "Succes!"
        }
        
        shortURL.get(":shortURL") { req async throws -> urlResponse in
            let usersURL = req.parameters.get("shortURL")!
            var url = try await URLModel.query(on: req.db)
                .filter(\.$shortURL == usersURL)
                .filter(\.$deletedAt == nil)
                .first()
            
            if url == nil {
                url = try await URLModel.query(on: req.db)
                    .filter(\.$customURL == usersURL)
                    .filter(\.$deletedAt == nil)
                    .first()
                if url == nil {
                    return .init(resp: "No such shortURL")
                }
            }
            
//            if url!.availableTill != nil {
//                if url!.availableTill! < Date().timeIntervalSince1970 {
//                    try await url!.delete(on: req.db)
//                    return .init(resp: "Short URL is not available")
//                }
//            }
            
            
            let ip = req.remoteAddress?.ipAddress
            
            let userAgent = req.headers["User-Agent"].first ?? "Unknown User Agent"
            let parts = userAgent.components(separatedBy: " ")
            let agent = req.headers["User-Agent"].first!.split(separator: "/").dropLast().last!
            var os = ""

            for part in parts {
                if part.contains("Windows") {
                    os = "Windows"
                } else if part.contains("Android") {
                    os = "Android"
                } else if part.contains("iOS") {
                    os = "iOS"
                } else if part.contains("Macintosh") {
                    os = "Macintosh"
                }
            }
            
            let appLanguage = "\(Locale.current.language.languageCode ?? "eng")"
            let deviceName = ""
            let appVersion = "\(agent)"
            let deviceId = UUID().uuidString
            let apiKey = req.headers["API-Key"].first
            
            
            let analyticsData = Analytics(ipAddress: ip, userAgent: userAgent, appLanguage: appLanguage, deviceName: deviceName, platform: os, appVersion: appVersion, deviceId: deviceId, apiKey: apiKey)
            
            try await analyticsData.save(on: req.db)
            
            return .init(resp: url!.originalURL)
            
        }
        
        
        
        
        
        shortURL.delete(":shortURL") { req async throws -> String in
            let shortURL = req.parameters.get("shortURL")!
            
            if let url = try await URLModel.query(on: req.db)
                .filter(\.$shortURL == shortURL)
                .filter(\.$deletedAt == nil)
                .first() {
                try await url.delete(force: true, on: req.db)
                return "Deleted"
            } else {
                return "Not Found"
            }
        }
        
        shortURL.post("restore", ":shortURL") { req async throws -> String in
            guard let shortURL = req.parameters.get("shortURL") else {
                throw Abort(.badRequest, reason: "Missing shortURL parameter")
            }
            
            if let url = try await URLModel.query(on: req.db)
                .filter(\.$shortURL == shortURL)
                .first() {
                print("Found URL: \(shortURL) - Restoring")
                try await url.restore(on: req.db)
                return "Restored"
            } else {
                return "Not found"
            }
        }
        
    }
}

struct Link: Content {
    var originalURL: String
    var customURL: String?
}

struct urlResponse: Content {
    var resp: String
}
