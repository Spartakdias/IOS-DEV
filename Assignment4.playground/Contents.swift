// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case engine
    case medbay
    
    var evacuationPriority: Int{
        switch self {
        case .bridge: return 1
        case .medbay: return 2
        case .lab: return 3
        case .engine: return 4
        case .cargo: return 5
        }
    }
}
print(Deck.bridge.rawValue)
print(Deck.allCases.count)
print(Deck.medbay.evacuationPriority)

// 1.2
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red
    
    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let rawLevel = min(mass/500, 3)
        if let level = AlarmLevel(rawValue: rawLevel) {
            return level
        }
        return .red
    }
}
print(AlarmLevel.level(forTotalMass: 0))
print(AlarmLevel.level(forTotalMass: 940))
print(AlarmLevel.level(forTotalMass: 4000))


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}
// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    
    if parts.count == 3 && parts[0] == "crate" {
        if let id = Int(parts[1]),
           let mass = Int(parts[2]) {
            return .crate(id: id, massKg: mass)
        }
    }
    
    if parts.count == 3 && parts[0] == "container" {
        if let mass = Int(parts[2]) {
            return .container(code: parts[1], massKg: mass)
        }
    }
    
    if parts.count == 4 && parts[0] == "livestock" {
        if let count = Int(parts[2]),
           let perUnit = Int(parts[3]) {
            return .livestock(species: parts[1], count: count, massPerUnitKg: perUnit)
        }
    }
    return .unknown(raw: line)
}
for line in rawManifest{
    print(parseEntry(line))
}

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry{
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}
var totalMass = 0
var unknownCount = 0
for line in rawManifest{
    let entry = parseEntry(line)
    totalMass += mass(of: entry)
    
    switch entry{
    case .unknown:
        unknownCount += 1
    default:
        break
    }
}

let A = totalMass
print("Total Mass:", A)
print("Total Unknown:", unknownCount)
// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(amount: Int) {
        oxygen = max(oxygen - amount, 0)
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(
            name: name,
            deck: .medbay,
            oxygen: 100
        )
    }

    static func rookie(named name: String) -> CrewSnapshot {
        return CrewSnapshot(
            name: name,
            deck: .bridge,
            oxygen: 100
        )
    }
}
var crew = CrewSnapshot.rookie(named: "Timur")
print(crew)

crew.breathe(amount: 30)
print(crew)

crew.move(to: .cargo)
print(crew)

crew.reviveInMedbay()
print(crew)

// 3.2
var roster: [CrewSnapshot] = []

for data in crewData {
    if let deck = Deck(rawValue: data.deck) {
        let crewMember = CrewSnapshot(
            name: data.name,
            deck: deck,
            oxygen: data.oxygen
        )

        roster.append(crewMember)
    } else {
        print("Warning: unknown deck \(data.deck) for \(data.name)")
    }
}

print(roster)
// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)
// 1. Modify a copy — original stays unchanged

var original = CrewSnapshot.rookie(named: "Timur")
var copy = original

print("1. Original before:", original)
print("1. Copy before:", copy)

copy.breathe(amount: 30)

print("1. Original after:", original)
print("1. Copy after:", copy)


// 2. Pass into a normal function — original stays unchanged

func changeSnapshot(_ snapshot: CrewSnapshot) {
    var changed = snapshot
    changed.breathe(amount: 40)

    print("2. Inside function:", changed)
}

print("2. Original before:", original)
changeSnapshot(original)
print("2. Original after:", original)


// 3. Pass using inout — original changes

func changeSnapshotInout(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(amount: 20)
}

print("3. Original before:", original)
changeSnapshotInout(&original)
print("3. Original after:", original)

// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        if occupant != nil || chargeLevel < 20 {
            return false
        }

        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        if let crew = occupant {
            chargeLevel -= 20
            occupant = nil
            return crew
        }

        return nil
    }
}

// 4.2 · Charge ledger: load+fire three times, then fire an empty pod
let pod = TeleportPod(id: "P-1", chargeLevel: 100)

let timur = CrewSnapshot.rookie(named: "Timur")
let dana = CrewSnapshot.rookie(named: "Dana")
let nurlan = CrewSnapshot.rookie(named: "Nurlan")

pod.load(timur)
print("Charge after loading Timur:", pod.chargeLevel)

pod.fire()
print("Charge after firing Timur:", pod.chargeLevel)

pod.load(dana)
print("Charge after loading Dana:", pod.chargeLevel)

pod.fire()
print("Charge after firing Dana:", pod.chargeLevel)

pod.load(nurlan)
print("Charge after loading Nurlan:", pod.chargeLevel)

pod.fire()
print("Charge after firing Nurlan:", pod.chargeLevel)

pod.fire()
print("Charge after empty fire:", pod.chargeLevel)

let C = pod.chargeLevel

print("C =", C)
// 4.3 · Reference-semantics demonstration

let podReference = pod

print("Pod before:", pod.chargeLevel)
print("Reference before:", podReference.chargeLevel)

podReference.chargeLevel = 90

print("Pod after:", pod.chargeLevel)
print("Reference after:", podReference.chargeLevel)



var crewOriginal = CrewSnapshot.rookie(named: "Aruzhan")
var crewCopy = crewOriginal

print("Crew original before:", crewOriginal.oxygen)
print("Crew copy before:", crewCopy.oxygen)

crewCopy.breathe(amount: 30)

print("Crew original after:", crewOriginal.oxygen)
print("Crew copy after:", crewCopy.oxygen)


// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    let callSign: String

    var hullIntegrity: Int {
        willSet {
            print("Hull integrity: \(hullIntegrity) -> \(newValue)")
        }

        didSet {
            hullIntegrity = min(max(hullIntegrity, 0), 100)
        }
    }

    var oxygenByDeck: [Deck: Int]

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "Station \(callSign): hull \(hullIntegrity), total oxygen \(totalOxygen)"
    }()

    var totalOxygen: Int {
        var total = 0

        for oxygen in oxygenByDeck.values {
            total += oxygen
        }

        return total
    }

    var averageOxygen: Int {
        get {
            if oxygenByDeck.isEmpty {
                return 0
            }

            return totalOxygen / oxygenByDeck.count
        }

        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, hullIntegrity: Int) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity
        self.oxygenByDeck = [:]

        for reading in deckReadings {
            if let deck = Deck(rawValue: reading.deck) {
                self.oxygenByDeck[deck] = reading.oxygen
            }
        }
    }
}

let station = Station(
    callSign: "ALMA-7",
    hullIntegrity: 100
)
let B = station.averageOxygen

print("Total oxygen:", station.totalOxygen)
print("Average oxygen:", station.averageOxygen)
print("B =", B)

print("First diagnostics:", station.fullDiagnostics)
print("Second diagnostics:", station.fullDiagnostics)

// 5.2 · The clamp trap: 130, then -40, then 55
station.hullIntegrity = 130
print("Hull integrity after 130:", station.hullIntegrity)

station.hullIntegrity = -40
print("Hull integrity after -40:", station.hullIntegrity)

station.hullIntegrity = 55
print("Hull integrity after 55:", station.hullIntegrity)


// MARK: Level 6 · Incident Reports

// Report 1
// Expected: oxygen goes down by 10.
// Actual: roster does not change.
// Rule: structs are value types.
// Fix:
for index in roster.indices {
    roster[index].oxygen -= 10
}

print(roster[0].oxygen)


// Report 2
// Expected: podA stays at 100.
// Actual: podA also changes to 0.
// Rule: classes are reference types.
// Fix:
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: "B", chargeLevel: 100)

podB.chargeLevel = 0

print(podA.chargeLevel)
print(podB.chargeLevel)


// Report 3
// Expected: a new entry is added.
// Actual: the original code does not compile.
// Rule: a struct method must be mutating to change its properties.
// Fix:
struct Logbook {
    var entries: [String] = []

    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var logbook = Logbook()
logbook.add("Teleport incident")

print(logbook.entries)


// Report 4
// Expected: both values can be changed.
// Actual: snapshot cannot be changed, but pod can.
// Rule: with a struct, let means the value cannot be changed.
// With a class, let means the reference cannot be changed,
// but its var properties can change.
// Fix:
var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let reportPod = TeleportPod(id: "B", chargeLevel: 50)
reportPod.chargeLevel = 10

print(snapshot.oxygen)
print(reportPod.chargeLevel)

// MARK: Level 7 · Sealing the Black Box

class FlightRecorder {
    
    // private blocks direct access to entries from outside this type.
    private var entries: [String] = []
    
    // private(set) blocks changing isSealed from outside the type.
    private(set) var isSealed = false
    
    // public allows this property to be read from outside the type.
    public var entryCount: Int {
        return entries.count
    }
    
    // public allows the transcript to be read from outside the type.
    public var transcript: String {
        return entries.joined(separator: "\n")
    }
    
    // public allows entries to be added from outside the type.
    public func add(_ entry: String) {
        if !isSealed {
            entries.append(entry)
        }
    }
    
    // public allows the recorder to be sealed from outside the type.
    public func seal() {
        isSealed = true
    }
    
    // fileprivate blocks access from other files but allows access in this file.
    fileprivate func lastEntry() -> String? {
        return entries.last
    }
}


// fileprivate allows this free function to use lastEntry().
func printLastEntry(of recorder: FlightRecorder) {
    if let entry = recorder.lastEntry() {
        print(entry)
    }
}


let recorder = FlightRecorder()

recorder.add("Teleport started")
recorder.add("Crew transferred")

print(recorder.entryCount)
print(recorder.transcript)

printLastEntry(of: recorder)

recorder.seal()
print(recorder.isSealed)

recorder.add("This should not be added")
print(recorder.entryCount)


// Failed attempt:
// recorder.entries.removeAll()
// Error: 'entries' is inaccessible due to 'private' protection level

// Failed attempt:
// recorder.isSealed = false
// Error: Cannot assign to property: 'isSealed' setter is inaccessible


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")

// MARK: Bonus

// deinit in TeleportPod, a do-block lifetime experiment, and === identity


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?

 2. What does `mutating` do to self, and why do classes never need it?

 3. In Report 4 both values are `let`. What exactly does `let` freeze for a
    struct, and what does it freeze for a class?

 4. Why must a lazy property be var? When does lazy change behaviour, not
    just performance?

 5. private vs fileprivate: where in your FlightRecorder would private be
    too strict?

 Bonus. On which line does deinit fire, and why can't === be used on
 CrewSnapshot?

*/

