// --- Day 21: Allergen Assessment ---
// https://adventofcode.com/2020/day/21

let foodList =
"""
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
"""

struct Food {
    let ingredients: Set<String>
    let allergens: Set<String>

    init(input: String) {
        let components = input.components(separatedBy: " (")
        self.ingredients = Set(components[0].components(separatedBy: .whitespaces))
        self.allergens = Set(
            components[1].dropLast()
                .replacingOccurrences(of: "contains ", with: "")
                .components(separatedBy: ", ")
        )
    }
}

struct AllergenChekcer {
    var foodAllergyDic: [String: String] = [:] // [allergen: ingredient]
    let foods: [Food]
    
    var allergensAppearCount: Int {
        let normalIngredients = Set(foods.flatMap { $0.ingredients }).subtracting(foodAllergyDic.values)
        return foods.reduceCount { Set($0.ingredients).intersection(normalIngredients).count }
    }
    
    var sortedDangerousIngredients: String {
        foodAllergyDic.keys.sorted(by: <)
            .compactMap { foodAllergyDic[$0] }
            .joined(separator: ",")
    }

    init(input: String) {
        var allergens: Set<String> = []

        self.foods = input.componentsByLine.map { Food(input: $0) }
        self.foods.forEach { allergens.formUnion($0.allergens) }

        self.foodAllergyDic = self.makeFoodAllergyDic(by: allergens)
    }
    
    private func makeFoodAllergyDic(by allergens: Set<String>) -> [String: String] {
        var newfoodAllergyDic: [String: String] = [:]
        var undecidedAllergens: [String: Set<String>] = [:]
        
        allergens.forEach { allergen in
            var curIngredients: [Set<String>] = []
            for food in foods where food.allergens.contains(allergen) {
                curIngredients.append(food.ingredients)
            }

            var uniqueAllergens: Set<String> = curIngredients[0]
            curIngredients[1...].forEach { uniqueAllergens.formIntersection($0) }
            undecidedAllergens[allergen] = uniqueAllergens
        }
        
        while !undecidedAllergens.isEmpty {
            undecidedAllergens.forEach { curAllergen, curIngredients in
                var mutatingIngredients = curIngredients
                mutatingIngredients.subtract(newfoodAllergyDic.values)
                
                if mutatingIngredients.count == 1, let curIngredient = mutatingIngredients.first {
                    newfoodAllergyDic[curAllergen] = curIngredient
                    undecidedAllergens[curAllergen] = nil
                } else {
                    undecidedAllergens[curAllergen] = mutatingIngredients
                }
            }
        }
        
        return newfoodAllergyDic
    }
}

let chekcer = AllergenChekcer(input: foodList)

// Part 1
print(chekcer.allergensAppearCount)

// Part 2
print(chekcer.sortedDangerousIngredients)
