import Swinjection

let container = ServiceLocator.shared

class A {
    let x: Int
    let b: B
    
    init(x: Int, b: B) {
        self.x = x
        self.b = b
    }
}

class B {
    let y: Int
    
    init(y: Int) {
        self.y = y
    }
}

class C {
    let b: B
    
    init(b: B) {
        self.b = b
    }
}

container.register(service: B.self, scope: ObjectScope.singleton) { _ in
    return B(y: 1)
}
container.register(service: A.self, scope: ObjectScope.singleton) { r in
    return A(x: 0, b: r.resolve()!)
}


guard let a: A = container.resolve() else { fatalError() }
print(a.b.y)

