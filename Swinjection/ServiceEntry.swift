//
// Created by IlyaCool on 21.06.22.
//

import Foundation

class ServiceEntry {
    let service: Any?
    let factory: ((Resolver) -> Any)?
    let scope: ObjectScope

    init(
            service: Any?,
            scope: ObjectScope,
            _ factory: ((Resolver) -> Any)?
    ) {
        self.service = service
        self.scope = scope
        self.factory = factory
    }
}
