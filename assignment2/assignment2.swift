//easy tasks
var fruits = ["apple", "Ananas", "banana", "kiwi", "orange"]
print(fruits[2])

var numbers: Set<Int> = [24,10,7]
numbers.insert(9)
print(numbers)

var proglanguages: [String: Int] = [
  "C++": 1978,
  "Python": 2000,
  "Swift": 2014
]
print(proglanguages)

var colors = ["red", "white", "green", "blue"]
colors[1] = "brown"
print(colors)

//middle tasks
let numbers1: Set<Int> = [1,2,3,4]
let numbers2: Set<Int> = [3,4,5,6]
let intersection = numbers1.intersection(numbers2)
print(intersection)


var students: [String: Int] = [
  "Dias": 10,
  "Madi": 9,
  "Beks": 8
]
students["Madi"] = 10
print(students)


let fr1 = ["apple", "banana"]
let fr2 = ["cherry", "date"]
let allfr = fr1+fr2 
print(allfr)

//hard tasks
var population: [String: Double] = [
  "Russia": 147.7,
  "Kazakhstan": 20.5,
  "USA": 340
]
population["France"] = 68.1
print(population)

let animal1: Set<String> = ["dog", "cat"]
let animal2: Set<String> = ["dog", "mouse"]
let unionAnimal = animal1.union(animal2)
let finalAnimal = unionAnimal.subtracting(animal2)
print(finalAnimal)

let grades: [String: [String: Int] ] = [
  "Didka": [
    "Math": 85,
    "PE": 100,
    "ICT": 90
  ],
  "Anchik":[
    "Math": 80,
    "PE": 90,
    "ICT": 100
  ],
  "Diasik":[
    "Math": 100,
    "PE": 100,
    "ICT": 100
  ]
]
print(grades)


