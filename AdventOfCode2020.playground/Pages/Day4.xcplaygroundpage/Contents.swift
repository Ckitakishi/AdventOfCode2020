// --- Day 4: Passport Processing ---
// https://adventofcode.com/2020/day/4

import Foundation

let batchFile =
"""
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""

struct Passport {
    /*
     byr (Birth Year) - four digits; at least 1920 and at most 2002.
     iyr (Issue Year) - four digits; at least 2010 and at most 2020.
     eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
     hgt (Height) - a number followed by either cm or in:
         If cm, the number must be at least 150 and at most 193.
         If in, the number must be at least 59 and at most 76.
     hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
     ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
     pid (Passport ID) - a nine-digit number, including leading zeroes.
     cid (Country ID) - ignored, missing or not.
     */
    
    enum PassportError: Error {
        case unknow
    }
    
    enum HeightType: Decodable {
        case cm(Int)
        case inch(Int)
        
        init(from decoder: Decoder) throws {
            func dropUnit() {
                heightString = String(heightString.dropLast(2))
            }
            
            let container = try decoder.singleValueContainer()
            var heightString = try container.decode(String.self)
        
            if heightString.hasSuffix("cm") {
                dropUnit()
                self = .cm(Int(heightString) ?? 0)
            } else if heightString.hasSuffix("in") {
                dropUnit()
                self = .inch(Int(heightString) ?? 0)
            } else {
                throw PassportError.unknow
            }
        }
        
        var isValid: Bool {
            switch self {
            case .cm(let height):
                return 150...193 ~= height
            case .inch(let height):
                return 59...76 ~= height
            }
        }
    }

    enum EyeColor: String, Decodable {
        case amb, blu, brn, gry, grn, hzl, oth
    }
    
    let byr: Int
    let iyr: Int
    let eyr: Int
    let hgt: HeightType
    let hcl: String
    let ecl: EyeColor
    let pid: String
//    let cid: String?
}

extension Passport: Decodable {
    enum CodingKeys: CodingKey {
        case byr, iyr, eyr, hgt, hcl, ecl, pid
    }
    
    init(from decoder: Decoder) throws {
        func itemValue(_ key: CodingKeys) throws -> Int {
            guard let value = Int(try values.decode(String.self, forKey: key)) else {
                throw PassportError.unknow
            }
            return value
        }
        
        let values = try decoder.container(keyedBy: CodingKeys.self)

        byr = try itemValue(.byr)
        iyr = try itemValue(.iyr)
        eyr = try itemValue(.eyr)
        hgt = try values.decode(HeightType.self, forKey: .hgt)
        hcl = try values.decode(String.self, forKey: .hcl)
        ecl = try values.decode(EyeColor.self, forKey: .ecl)
        pid = try values.decode(String.self, forKey: .pid)
    }
    
    init?(reservedDic: [String: String]) {
        guard let passport = try? JSONDecoder().decode(
            Passport.self,
            from: JSONSerialization.data(withJSONObject: reservedDic)
        ) else { return nil }
        
        self = passport
    }
}

struct PassportProcessor {
    let requiredItems = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    let passportDics: [[String: String]]
    
    let passports: [Passport]
    
    // "aa:bb xx: yy..." without newline
    init(list: [String]) {
        self.passportDics = list.map { passport in
            var passportDic: [String: String] = [:]
            
             passport.components(separatedBy: .whitespaces)
                .forEach {
                    let item = $0.components(separatedBy: ":")
                    passportDic[item[0]] = item[1]
                }
            
            return passportDic
        }
        
        self.passports = passportDics.compactMap { Passport(reservedDic: $0) }
    }
    
    // Part 1
    func numberOfValidPassports() -> Int {
        passportDics.reduce(0) { total, passportDic in
            for item in requiredItems where passportDic[item] == nil {
                return total
            }
            return total + 1
        }
    }
    
    // Part 2
    func numberOfValidPassports2() -> Int {
        passports.reduce(0) { total, passport in
            guard 1920...2002 ~= passport.byr,
                  2010...2020 ~= passport.iyr,
                  2020...2030 ~= passport.eyr,
                  passport.hgt.isValid,
                  passport.hcl.range(
                    of: "#[a-z0-9]",
                    options: .regularExpression
                  ) != nil,
                  passport.pid.count == 9
            else {
                return total
            }
            
            return total + 1
        }
    }
}

let passportList: [String] = batchFile
    .components(separatedBy: "\n\n")
    .map { $0.replacingOccurrences(of: "\n", with: " ") }

let processor = PassportProcessor(list: passportList)

// Part 1
print(processor.numberOfValidPassports())

// Part 2
print(processor.numberOfValidPassports2())
