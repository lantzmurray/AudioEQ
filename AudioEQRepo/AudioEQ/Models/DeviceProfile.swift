import Foundation

struct DeviceProfile: Identifiable, Codable {
    let id: UUID
    let name: String
    let manufacturer: String
    let model: String
    let deviceType: DeviceType
    let frequencyResponse: [FrequencyPoint]
    let recommendedEQ: EQSettings
    let dataSource: DataSource
    let dateAdded: Date

    enum DeviceType: String, CaseIterable, Codable {
        case headphone = "Headphone"
        case inEar = "In-Ear Monitor"
        case studioMonitor = "Studio Monitor"
        case speaker = "Speaker"
        case earbud = "Earbud"
    }

    enum DataSource: String, CaseIterable, Codable {
        case local = "Local"
        case oratory1990 = "Oratory1990"
        case crinacle = "Crinacle"
        case custom = "Custom"
    }

    init(
        name: String,
        manufacturer: String,
        model: String,
        deviceType: DeviceType,
        frequencyResponse: [FrequencyPoint] = [],
        recommendedEQ: EQSettings = .flat,
        dataSource: DataSource = .local
    ) {
        self.id = UUID()
        self.name = name
        self.manufacturer = manufacturer
        self.model = model
        self.deviceType = deviceType
        self.frequencyResponse = frequencyResponse
        self.recommendedEQ = recommendedEQ
        self.dataSource = dataSource
        self.dateAdded = Date()
    }
}

