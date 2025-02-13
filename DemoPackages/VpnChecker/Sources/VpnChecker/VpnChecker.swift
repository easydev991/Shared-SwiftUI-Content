import Foundation

// MARK: - Протокол для получения прокси-настроек
/// Определяет контракт для поставщика прокси-настроек, позволяя внедрять различные реализации для тестирования и кастомизации
///
/// Это решение улучшает тестируемость и соблюдает `Dependency Inversion Principle`
public protocol ProxySettingsProvider {
    /// Возвращает ключи прокси-настроек для всех сетевых интерфейсов
    /// - Note: Возвращаемые ключи обычно соответствуют именам сетевых интерфейсов (например: utun0, en0)
    var scopedProxyKeys: [String]? { get }
}

// MARK: - Системная реализация поставщика настроек
/// Реализация, использующая `CFNetwork API` для доступа к системным прокси-настройкам
/// - Important: `CFNetworkCopySystemProxySettings` возвращает глобальные прокси-настройки,
/// которые включают как VPN-интерфейсы, так и другие типы прокси-соединений
public struct SystemProxySettingsProvider: ProxySettingsProvider {
    public init() {}
    
    public var scopedProxyKeys: [String]? {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return nil }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        
        // Секция __SCOPED__ содержит настройки для конкретных сетевых интерфейсов
        guard let scopedKeys = nsDict["__SCOPED__"] as? NSDictionary else { return nil }
        
        return scopedKeys.allKeys.compactMap { $0 as? String }
    }
}

// MARK: - VpnChecker
/// Основной инструмент для проверки активности VPN-соединения
///
/// Проверяет наличие известных префиксов VPN-интерфейсов в системных прокси-настройках
public struct VpnChecker {
    private let vpnProtocols: [String]
    private let proxySettingsProvider: ProxySettingsProvider
    
    /// Инициализатор
    ///
    /// - Important: VPN-протоколы выбраны на основе общепринятых имен VPN-интерфейсов:
    /// tap/tun (OpenVPN), ppp (PPTP), ipsec (IPSec), utun (WireGuard, IKEv2)
    /// - Parameters:
    ///   - vpnProtocols: Список проверяемых протоколов VPN
    ///   - proxySettingsProvider: Поставщик прокси-настроек
    public init(
        vpnProtocols: [String] = ["tap", "tun", "ppp", "ipsec", "utun"],
        proxySettingsProvider: ProxySettingsProvider = SystemProxySettingsProvider()
    ) {
        self.vpnProtocols = vpnProtocols
        self.proxySettingsProvider = proxySettingsProvider
    }
    
    /// Флаг активности VPN-соединения
    /// - Note: Проверяет наличие хотя бы одного ключа прокси,
    /// начинающегося с известного префикса VPN-протокола
    public var isVpnActive: Bool {
        guard let keys = proxySettingsProvider.scopedProxyKeys else { return false }
        return keys.contains { key in
            vpnProtocols.contains { key.starts(with: $0) }
        }
    }
}
