// --- Day 14: Docking Data ---
// https://adventofcode.com/2020/day/14

import Foundation

let input =
"""
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""

let input2 =
"""
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
"""

class Program {
    struct Block {
        let mask: String
        let instructions: [(Int, String)]
        
        init(blockString: String) {
            let lines = blockString.componentsByLine
            self.mask = lines[0].components(separatedBy: " = ")[1]
            self.instructions = lines[1...].map { line in
                let instruction = line.components(separatedBy: " = ")
                var address = instruction[0]
                address = address.replacingOccurrences(of: "]", with: "")
                return (
                    Int(address.components(separatedBy: "[")[1])!,
                    instruction[1].binaryValueString()
                )
            }
        }
        
        func applyMaskToValue() -> [(Int, String)] {
            instructions.map { mem, num in
                let firstOneIndex = num.firstIndex(of: "1")?.utf16Offset(in: num) ?? 0
                var binaryNum = num
                
                for index in firstOneIndex..<num.count {
                    let strIndex = num.index(num.startIndex, offsetBy: index)
                    guard mask[strIndex] != "X" else { continue }
                    
                    binaryNum.remove(at: strIndex)
                    binaryNum.insert(mask[strIndex], at: strIndex)
                }
                
                return (mem, binaryNum)
            }
        }
        
        func applyMaskToMemoryAddress() -> [(Int, String)] {
            let numbers: [[(Int, String)]] = instructions.map { mem, num in
                var binaryAddress = String(mem).binaryValueString()

                for index in 0..<binaryAddress.count {
                    let strIndex = binaryAddress.index(binaryAddress.startIndex, offsetBy: index)
                    switch mask[strIndex] {
                    case "X", "1":
                        binaryAddress.remove(at: strIndex)
                        binaryAddress.insert(mask[strIndex], at: strIndex)
                    default:
                        continue
                    }
                }
                
                return listAllValidAddress(binaryAddress).map { ($0, num) }
            }
            
            return numbers.flatMap { $0 }
        }
        
        private func listAllValidAddress(_ floatingAddress: String) -> [Int] {
            let floatingDigitsCount = floatingAddress.filter { $0 == "X" }.count
            
            guard floatingDigitsCount > 0 else { return [String(floatingAddress).decimalValue] }
            
            let validAddressCount = NSDecimalNumber(decimal: pow(2, floatingDigitsCount)).intValue
        
            var addresses: [Int] = []
            for index in 0..<validAddressCount {
                var mutatingAddress = Array(floatingAddress)
                var digits = Array(String(index).binaryValueString(digitCount: floatingDigitsCount))
                
                while !digits.isEmpty {
                    let digit = digits.remove(at: 0)
                    guard let XIndex = mutatingAddress.firstIndex(of: "X") else { continue }
                    mutatingAddress[XIndex] = digit
                }
                
                addresses.append(String(mutatingAddress).decimalValue)
            }
            
            return addresses
        }
    }
    
    let blocks: [Block]
    var memory: [Int: String] = [:]
    
    var sum: Int {
        memory.values.reduceCount { $0.decimalValue }
    }
    
    init(blockStrings: [String]) {
        self.blocks = blockStrings.map { Block(blockString: $0) }
    }
    
    func run(ignoreX: Bool) {
        if ignoreX {
            blocks.forEach { block in
                block.applyMaskToValue().forEach { memory[$0] = $1 }
            }
        } else {
            blocks.forEach { block in
                block.applyMaskToMemoryAddress().forEach { memory[$0] = $1 }
            }
        }
    }
}

extension String {
    fileprivate var decimalValue: Int { Int(self, radix: 2) ?? 0 }
    fileprivate var binaryValueString: String { String(Int(self) ?? 0, radix: 2) }
    
    fileprivate func binaryValueString(digitCount: Int = 36) -> String {
        if binaryValueString.count < digitCount {
            return String(repeating: "0", count: digitCount - binaryValueString.count) + binaryValueString
        }
        return binaryValueString
    }
}

// Part 1
let program = Program(blockStrings: input.components(separatedBy: "\nmask"))
program.run(ignoreX: true)
print(program.sum)

// Part 2 - Not the right answer
let program2 = Program(blockStrings: input2.components(separatedBy: "\nmask"))
program2.run(ignoreX: false)
print(program2.sum)
