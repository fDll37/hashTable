final class ElementHashTable {

    let key: String
    var value: String
    var tail: ElementHashTable?
    
    init(key: String, value: String, tail: ElementHashTable? = nil) {
        self.key = key
        self.value = value
        self.tail = tail
    }
    
    func getHashCode() -> Int {
        key.hashValue
    }
}

final class HashTable {
    
    private var countElement: Int = 0 {
        didSet {
            if countElement > tableSize / 2 {
                tableSize *= 2
                rehash()
            }
        }
    }
    private var tableSize: Int = 10
    private var storage: [ElementHashTable?] = []
    
    init() {
        self.storage = Array(repeating: nil, count: tableSize)
    }
    
    subscript(key: String) -> String? {
        get {
            return get(key: key)
        }
        
        set(newValue) {
            if let value = newValue {
                add(key: key, value: value)
            } else {
                delete(key: key)
            }
        }
    }
    
    private func rehash() {
        print(#function)
        let oldStorage = storage
        storage = Array(repeating: nil, count: tableSize)
        
        for element in oldStorage {
            var current = element
            
            while let node = current {
                let index = abs(node.getHashCode()) % tableSize
                
                let newNode = ElementHashTable(key: node.key, value: node.value)
                
                if storage[index] == nil {
                    storage[index] = newNode
                } else {
                    var tailElement = storage[index]
                    
                    while tailElement?.tail != nil {
                        tailElement = tailElement?.tail
                    }
                    tailElement?.tail = newNode
                }
                current = node.tail
            }
        }
    }

    
    private func get(key: String) -> String? {
        let index = abs(key.hashValue) % tableSize
        var current = storage[index]
        
        while let node = current {
            if node.key == key {
                return node.value
            }
            current = node.tail
        }
        return nil
    }

    
    private func add(key: String, value: String) {
        let index = abs(key.hashValue) % tableSize
        var current = storage[index]
        
        while let node = current {
            if node.key == key {
                node.value = value // Обновляем значение, если ключ уже существует
                return
            }
            current = node.tail
        }
        
        let newElement = ElementHashTable(key: key, value: value, tail: storage[index])
        storage[index] = newElement
        countElement += 1
    }

    
    private func delete(key: String) {
        let index = abs(key.hashValue) % tableSize
        
        var currentElement = storage[index]
        var previousElement: ElementHashTable? = nil
        
        while let node = currentElement {
            if node.key == key {
                if let previous = previousElement {
                    previous.tail = node.tail
                } else {
                    storage[index] = node.tail
                }
                countElement -= 1
                return
            }
            previousElement = currentElement
            currentElement = node.tail
        }
    }
}
