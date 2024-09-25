

import Vapor
import Fluent

final class Analytics: Model, Content {
    static let schema = "analytics"

    @ID(key: .id)
    var id: UUID?

    @Field(key: .ip_address)
    var ipAddress: String?

    @Field(key: .user_agent)
    var userAgent: String?

    @Field(key: .app_language)
    var appLanguage: String?

    @Field(key: .device_name)
    var deviceName: String?

    @Field(key: .platforma)
    var platform: String?

    @Field(key: .app_version)
    var appVersion: String?

    @Field(key: .device_id)
    var deviceId: String?

    @Field(key: .api_key)
    var apiKey: String?

    init() {}

    init(ipAddress: String?, userAgent: String?, appLanguage: String?, deviceName: String?, platform: String?, appVersion: String?, deviceId: String?, apiKey: String?) {
        self.ipAddress = ipAddress
        self.userAgent = userAgent
        self.appLanguage = appLanguage
        self.deviceName = deviceName
        self.platform = platform
        self.appVersion = appVersion
        self.deviceId = deviceId
        self.apiKey = apiKey
    }
}

extension FieldKey {
    static var ip_address: Self { "ip_address" }
    static var user_agent: Self { "user_agent" }
    static var app_language: Self { "app_language" }
    static var device_name: Self { "device_name" }
    static var platforma: Self { "platforma" }
    static var device_id: Self { "device_id" }
    static var app_version: Self { "app_version" }
    static var api_key: Self { "api_key" }
}
