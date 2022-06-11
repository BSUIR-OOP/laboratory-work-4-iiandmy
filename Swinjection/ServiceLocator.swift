//
//  ServiceLocator.swift
//  Swinjection
//
//  Created by IlyaCool on 7.06.22.
//

enum Scope {
    case Transient, Singleton
}

protocol ServiceLocatorProtocol {
    func register<T>(service: T, scope: Scope)
    func resolve<T>() -> T?
}

class ServiceLocator: ServiceLocatorProtocol {
    static let shared = ServiceLocator()
    
    private lazy var services = [String: Any]()
    
    private init() {}
    
    func register<T>(
        service: T,
        scope: Scope
    ) {
        let key = typeName(service)
        services[key] = service
    }
    
    func resolve<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }
    
    private func typeName(
            _ any: Any
    ) -> String {
        (any is Any.Type) ? "\(any)" : "\(type(of: any))"
    }
    
}
