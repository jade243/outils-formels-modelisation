import PetriKit
import CoverabilityLib
import XCTest

class CoverabilityLibTests: XCTestCase {

    static let allTests = [
        ("testBoundedGraph"  , testBoundedGraph  ),
        ("testUnboundedGraph", testUnboundedGraph),
        ("testSimpleUnboundedGraph", testSimpleUnboundedGraph),
        ("testOmega", testOmega)
    ]

    func testBoundedGraph() {
        let model = createBoundedModel()
        guard let r  = model.places.first(where: { $0.name == "r" }),
              let p  = model.places.first(where: { $0.name == "p" }),
              let t  = model.places.first(where: { $0.name == "t" }),
              let m  = model.places.first(where: { $0.name == "m" }),
              let w1 = model.places.first(where: { $0.name == "w1" }),
              let s1 = model.places.first(where: { $0.name == "s1" }),
              let w2 = model.places.first(where: { $0.name == "w2" }),
              let s2 = model.places.first(where: { $0.name == "s2" }),
              let w3 = model.places.first(where: { $0.name == "w3" }),
              let s3 = model.places.first(where: { $0.name == "s3" })
            else {
                fatalError("invalid model")
        }

        let initialMarking: CoverabilityMarking =
            [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 32)
    }

    func testUnboundedGraph() {
        let model = createUnboundedModel()
        guard let s0 = model.places.first(where: { $0.name == "s0" }),
              let s1 = model.places.first(where: { $0.name == "s1" }),
              let s2 = model.places.first(where: { $0.name == "s2" }),
              let s3 = model.places.first(where: { $0.name == "s3" }),
              let s4 = model.places.first(where: { $0.name == "s4" }),
              let b  = model.places.first(where: { $0.name == "b"  })
            else {
                fatalError("invalid model")
        }

        let initialMarking: CoverabilityMarking =
            [s0: 1, s1: 0, s2: 1, s3: 0, s4: 1, b: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        //Après vérification sur papier, on obtient 5 noeuds pour ce réseau
        //avec ce marquage initial.
        XCTAssertEqual(coverabilityGraph.count, 5)
    }

    //Test avec un graphe très simple
    // t --> p avec (0) pour initialMarking
    // (0) --> (w)
    //Le graphe de couverture a donc 2 noeuds
    func testSimpleUnboundedGraph() {
      let p  = PTPlace(named: "p" )
      let model = PTNet (
          places : [p],
          transitions : [
            PTTransition(
                named         : "t",
                preconditions : [],
                postconditions: [PTArc(place: p)])
          ]
      )

      let initialMarking : CoverabilityMarking = [p: 0]
      let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
      XCTAssertEqual(coverabilityGraph.count, 2)
    }

    //Tests pour vérifier les comparaisons avec w
    //2 < w = true
    //2 < 3 = true
    //w < 3 = false
    func testOmega() {
      let t0 = Token.omega
      let t1 = Token.some(2)
      let t2 = Token.some(3)
      XCTAssertEqual(t1 < t0, true)
      XCTAssertEqual(t1 < t2, true)
      XCTAssertEqual(t0 < t2, false)
    }

}
