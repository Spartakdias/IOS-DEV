// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3,     module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          !parts.0.isEmpty,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP"
    else {
        return nil
    }
    return (sensor: parts.0, value: value)
}
print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)

// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0
    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }
    return (valid, invalidCount)
}

print(parseLog(["O2:87", "TEMP:-12"]))
print(parseLog(["O2:9x", ":55"]))
let parsedLog = parseLog(rawLog)
let A = parsedLog.invalidCount
print("A =", A)

// MARK: Level 2 · Analysis

// 2.1
func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
    var selected: [Reading] = []
    for reading in readings {
        if isIncluded(reading){
            selected.append(reading)
        }
    }
    return selected
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []
    for reading in readings {
        result.append(reading.value)
    }
    return result
}

let o2Readings = select(parsedLog.valid) {
    $0.sensor == "O2"
}
let o2Values = values(of: o2Readings)

print(select(parsedLog.valid) { $0.sensor == "O2" })
print(select(parsedLog.valid) { $0.sensor == "TEMP" })

print(values(of: o2Readings))
print(values(of: []))

print("O2 readings:", o2Readings)
print("O2 values:", o2Values)

// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)?{
    if values == []{
        return nil
    }else {
        var minValue = values[0]
        var maxValue = values[0]
        var sum = 0
        for value in values{
            if value < minValue{
                minValue = value
            }
            if value > maxValue{
                maxValue = value
            }
            sum += value
        }
        let average = Double(sum) / Double(values.count)
        
        return (minValue, maxValue, average)
    }
}
print(stats(of: [87, 64, 71, 90]) as Any)
print(stats(of: []) as Any)

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print(stats(10, 20, 30) as Any)
print(stats(5) as Any)

let o2Stats = stats(of: o2Values)
let B = Int(o2Stats?.average ?? 0)
print("B =", B)

// 2.3 · The Closure Ladder (5 sorts, then compare results in code)
let sorted1 = parsedLog.valid.sorted(by: {
    (a: Reading, b: Reading) -> Bool in
    return a.value > b.value
})
print("FirstSort:", sorted1)

let sorted2 = parsedLog.valid.sorted(by: { a , b in
    return a.value > b.value
})
print("Secondsort:", sorted2)

let sorted3 = parsedLog.valid.sorted(by: { a, b in
    a.value > b.value
})
print("Thirdsort:", sorted3)

let sorted4 = parsedLog.valid.sorted(by: {
    $0.value > $1.value
})
print("Fourthsort:", sorted4)

let sorted5 = parsedLog.valid.sorted {
    $0.value > $1.value
}
print("Fifthsort:", sorted5)
let allSortsMatch =
    values(of: sorted1) == values(of: sorted2) &&
    values(of: sorted2) == values(of: sorted3) &&
    values(of: sorted3) == values(of: sorted4) &&
    values(of: sorted4) == values(of: sorted5)

print("All sorts match:", allSortsMatch)

// MARK: Level 3 · Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    t+5
}
func coolDown(_ t: Int) -> Int {
    t-3
}
func hold(_ t: Int) -> Int {
    t
}
func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    }
    if temp > 24{
        return coolDown
    }
    else{
        return hold
    }
}
print(chooseProtocol(for: 10)(10))
print (chooseProtocol(for: 25)(25))
// 3.2
func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temp = start
    var steps = 0
    while (temp < 18 || temp > 24) && steps < maxSteps {
        temp = chooseProtocol(for: temp)(temp)
        steps += 1
    }
    return (temp, steps, temp >= 18 && temp <= 24)
}
print(runUntilStable(from: -10))
print(runUntilStable(from: 40))

let tempReading = select(parsedLog.valid){
    $0.sensor == "TEMP"
}
let tempValues = values(of: tempReading)
let tempStats = stats(of: tempValues)
let tempMin = tempStats?.min ?? 0
let result = runUntilStable(from: tempMin)
let C = result.steps
print("C =", C)


// MARK: Level 4 · The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

// 4.2
func status(of member: CrewMember) -> String {
    guard let level = oxygenLevel(of: member)else{
        let place = member.module?.name ?? "open space"
        return "\(member.name): no data \(place)"
    }
    if level < 20 {
        return "\(member.name): \(level)% CRITICAL"
    }else{
        return "\(member.name): \(level)% OK"
    }
}
for member in crew{
    print(status(of: member))
}

// 4.3
// @discardableResult
func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
    if amount < 0 {
        return 0
    }
    let actual = min(amount, min(source, 100 - target))
    source -= actual
    target += actual
    return actual
}

var source1 = 50
var target1 = 20
print(transferOxygen(from: &source1, to: &target1, amount: 30))
print("source:", source1)
print("target:", target1)

var source2 = 50
var target2 = 90

print(transferOxygen(from: &source2, to: &target2, amount: 50))
print("source:", source2)
print("target:", target2)


if let labTank = lab.oxygenTank,
   let habTank = hab.oxygenTank {
    transferOxygen(
        from: &labTank.level,
        to: &habTank.level,
        amount: 30
    )
}
let D = hab.oxygenTank?.level ?? 0
print("D =", D)

// 4.4
func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
    var found: [CrewMember] = []
    for name in names{
        guard let member = roster[name] else{
            print("Unknown crewmember:", name)
            continue
        }
        found.append(member)
    }
    found.sort{
        $0.priority < $1.priority
    }
    var result: [String] = []
    for member in found{
        result.append(member.name)
    }
    return result
}

print(evacuationOrder(
    "Timur", "Aigerim", "Nurlan",
    roster: roster
))

print(evacuationOrder(
    "Dana", "Dias", "Aigerim",
    roster: roster
))

// MARK: Level 5 · The Saboteur's Logbook
// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.


func reportOxygen(for member: CrewMember) -> String {
//    let tank = member.module!.oxygenTank! ! requires extracting the value , nevertheless Nurlan has a nil , so this line would broke the func
    guard let tank = oxygenLevel(of: member) else{
        return "\(member.name): no data"
    }
    return "\(member.name): \(tank)%"
}

func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
//        if oxygenLevel(of: member)! < 20  снова используется ! который запрещен правилами в начале, так же когда дойдет до нурлана функция ломается
//        result = member.name будет продолжать работать даже после найденного Critical, когда нам нужен return сразу как найдется первый такой человек
        guard let level = oxygenLevel(of: member) else {
            continue
        }
        if level < 20 {
            return member.name
                }
        }
        return nil
}
print(reportOxygen(for: crew[0]))
print(reportOxygen(for: crew[3]))

let testModule1 = Module(name: "Test1", oxygenTank: Tank(level: 10))
let testModule2 = Module(name: "Test2", oxygenTank: Tank(level: 15))
let testCrew = [
    CrewMember(name: "First", role: "Test", priority: 1, module: testModule1),
    CrewMember(name: "Second", role: "Test", priority: 2, module: testModule2)
]

print(firstCritical(in: testCrew) as Any)
// MARK: Finale · Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

// func makeAlarm(threshold: Int) -> (Int) -> Bool { }


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 2. Why can't you pass [Int] to stats(_ values: Int...)?

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

 5. Full type of chooseProtocol and how to read it:

 Bonus. Where does the alarm counter live after makeAlarm returns?

*/

