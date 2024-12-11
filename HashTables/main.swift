let hashTable = HashTable()

print("start")

for digit in 0...100 {
    hashTable["\(digit)"] = "value for \(digit)"
}
print("final")

let value = hashTable["50"]
print(value ?? "Empty value")
