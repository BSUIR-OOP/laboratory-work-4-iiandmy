//
//  ServiceLocator.swift
//  Swinjection
//
//  Created by IlyaCool on 7.06.22.
//

protocol ServiceLocatorProtocol {
    func register<T>(
            service: T,
            scope: ObjectScope,
            _ factory: (Resolver) -> T
    )
}

protocol Resolver {
    func resolve<T>() throws -> T
}

enum ResolveError: Error {
    case noSuchServiceRegistered
    case unexpectedBehaviour
}

class ServiceLocator: ServiceLocatorProtocol {
    static let shared = ServiceLocator()
    
    private lazy var services = [String: ServiceEntry]()
    
    private init() {}
    
    func register<T>(
            service: T,
            scope: ObjectScope,
            _ factory: (Resolver) -> T
    ) {
        let serviceType = typeName(service)
        if (services.keys.contains(serviceType)) {
            return
        }
        switch (scope) {
        case .Singleton:
            let service = ServiceEntry(
                service: factory(self),
                scope: scope
            )
            services[serviceType] = service
        case .Transient:
            let service = ServiceEntry(
                service: nil,
                scope: scope,
                factory
            )
            services[serviceType] = service
        default:
            return
        }
    }
    
    private func typeName(
            _ any: Any
    ) -> String {
        (any is Any.Type) ? "\(any)" : "\(type(of: any))"
    }
}

extension ServiceLocator: Resolver {
    func resolve<T>() throws -> T {
        guard let let serviceEntry = services[serviceName] else {
            throw ResolveError.noSuchServiceRegistered
        }
        switch (serviceEntry.scope) {
        case .Singleton: return serviceEntry.service
        case .Transient: return serviceEntry.factory(self)
        default: throw ResolveError.unexpectedBehaviour
        }
    }
}
