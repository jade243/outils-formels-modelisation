import PetriKit
import CoverabilityLib

//Quelques tests avec différents graphes et des marquages initiaux.
//D'autres tests sont présents dans CoverabilityLibTests.

//unboundedModel
let model = createUnboundedModel()
let s0 = model.places.first { $0.name == "s0" }!
let s1 = model.places.first { $0.name == "s1" }!
let s2 = model.places.first { $0.name == "s2" }!
let s3 = model.places.first { $0.name == "s3" }!
let s4 = model.places.first { $0.name == "s4" }!
let b =  model.places.first { $0.name == "b" }!

// Avec ce marquage initial, on obtient un graphe de couverture avec 9 noeuds
let initialMarking = [s0: Token(integerLiteral: 1),
                      s1: Token(integerLiteral: 0),
                      s2: Token(integerLiteral: 1),
                      s3: Token(integerLiteral: 0),
                      s4: Token(integerLiteral: 2),
                      b:  Token(integerLiteral: 0)]

let CoverabilityMarkingGraph = model.coverabilityGraph(from: initialMarking)
print("Pour le réseau infini : on trouve ",CoverabilityMarkingGraph.count," noeuds")


//boundedModed
let model1 = createBoundedModel()
let r = model1.places.first { $0.name == "r" }!
let p = model1.places.first { $0.name == "p" }!
let t = model1.places.first { $0.name == "t" }!
let m = model1.places.first { $0.name == "m" }!
let w1 = model1.places.first { $0.name == "w1" }!
let t1 = model1.places.first { $0.name == "s1" }!
let w2 = model1.places.first { $0.name == "w2" }!
let t2 = model1.places.first { $0.name == "s2" }!
let w3 = model1.places.first { $0.name == "w3" }!
let t3 = model1.places.first { $0.name == "s3" }!

//Même réseau que pour le TP2, on a donc un graphe avec 32 noeuds
let initialMarking1 = [r:  Token(integerLiteral: 1),
                      p:  Token(integerLiteral: 0),
                      t:  Token(integerLiteral: 0),
                      m:  Token(integerLiteral: 0),
                      w1: Token(integerLiteral: 1),
                      t1: Token(integerLiteral: 0),
                      w2: Token(integerLiteral: 1),
                      t2: Token(integerLiteral: 0),
                      w3: Token(integerLiteral: 1),
                      t3: Token(integerLiteral: 0)]

let CoverabilityMarkingGraph1 = model1.coverabilityGraph(from: initialMarking1)
print("Pour le réseau fini : on trouve ",CoverabilityMarkingGraph1.count," noeuds")

//RdP vu en cours pour illustrer l'algorithme des graphes de couverture
//On avait trouvé 8 noeuds
let P1 = PTPlace(named: "P1")
let P2 = PTPlace(named: "P2")
let P3 = PTPlace(named: "P3")

let model2 = PTNet (
    places: [P1, P2, P3],
    transitions: [
      PTTransition(
        named         : "t1",
        preconditions : [PTArc(place: P1)],
        postconditions: [PTArc(place: P2), PTArc(place: P3)]
      ),
      PTTransition(
        named         : "t2",
        preconditions : [PTArc(place: P2), PTArc(place: P3)],
        postconditions: [PTArc(place: P1)]
      ),
      PTTransition(
        named         : "t3",
        preconditions : [PTArc(place: P2)],
        postconditions: [PTArc(place: P1)]
      )
    ]
)

let initialMarking2 : CoverabilityMarking = [P1: 2, P2: 1, P3: 0]
let CoverabilityMarkingGraph2 = model2.coverabilityGraph(from: initialMarking2)
print("Pour le réseau vu en cours : on trouve ",CoverabilityMarkingGraph2.count," noeuds")
