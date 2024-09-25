import Vapor
import Fluent

struct AnalyticsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let analytics = routes.grouped("analytics")
        analytics.get("info", use: getAllInfo)
        
    }

    
    func getAllInfo(req: Request) async throws -> Response {
        
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
        
        return Response(body: .init(string: "\(analyticsData)"))
        
    }
}
