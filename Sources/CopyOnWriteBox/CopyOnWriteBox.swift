
@propertyWrapper
public struct CopyOnWriteBox<Value> {
    
    private var ref: Ref<Value>
    
    public init(_ value: Value) {
        ref = Ref(value)
    }
    
    public init(projectedValue: CopyOnWriteBox<Value>) {
        self = projectedValue
    }
    
    public var projectedValue: CopyOnWriteBox<Value> {
        get {
            self
        }
        set {
            self = newValue
        }
    }
    
    public var wrappedValue: Value {
        get {
            ref.value
        }
        set {
            if !isKnownUniquelyReferenced(&ref) {
              ref = Ref(newValue)
            } else {
                ref.value = newValue
            }
        }
    }
    
}


extension CopyOnWriteBox: Equatable where Value: Equatable {
    
    public static func == (lhs: CopyOnWriteBox<Value>, rhs: CopyOnWriteBox<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
}

extension CopyOnWriteBox: Hashable where Value: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ref.value)
    }
    
}

extension CopyOnWriteBox: Comparable where Value: Comparable {
    
    public static func < (lhs: CopyOnWriteBox<Value>, rhs: CopyOnWriteBox<Value>) -> Bool {
        lhs.wrappedValue < rhs.wrappedValue
    }

}


extension CopyOnWriteBox: Sequence where Value: Sequence {

    public typealias Element = Value.Element
    
    public typealias Iterator = Value.Iterator
    
    public func makeIterator() -> Value.Iterator {
        ref.value.makeIterator()
    }
    
}


final fileprivate class Ref<T> {
    
    fileprivate var value: T
    
    fileprivate init(_ v: T) {
        value = v
    }
    
}

