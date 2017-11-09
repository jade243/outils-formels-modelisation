import PetriKit

public class CoverabilityGraph {

    public init(
        marking: CoverabilityMarking, successors: [PTTransition: CoverabilityGraph] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public let marking   : CoverabilityMarking
    public var successors: [PTTransition: CoverabilityGraph]

    /// The number of nodes in the graph.
    public var count: Int {
        var seen = [self]
        var toCheck = [self]

        while let node = toCheck.popLast() {
            for (_, successor) in node.successors {
                if !IsSameMarking(current: successor.marking, graph: seen) {
                    toCheck.append(successor)
                    seen.append(successor)
                }
            }
        }

        return seen.count

    }

}

//*** Fonctions pour la gestion des CoverabilityMarking et CoverabilityGraph ***

//Fonction qui dit si le marquage est dans le tableau de marquages donné
//On vérifie si les marquages sont exactement les mêmes
public func IsSameMarking(current: CoverabilityMarking, graph: [CoverabilityGraph]) -> Bool {
  for markingGraph in graph {
    if (markingGraph.marking == current) {
      return true //Le marquage a déjà été vu
    }
  }
  return false //Le marquage n'a pas déjà été vu
}

//Fonction qui renvoie le CoverabilityGraph qui correspond au CoverabilityMarking donné
public func SameMarking(current: CoverabilityMarking, graph: [CoverabilityGraph]) -> CoverabilityGraph? {
  for markingGraph in graph {
    if (markingGraph.marking == current) {
      return markingGraph //correspond au marquage
    }
  }
  return nil //On n'a pas trouvé le même marquage
}

//Fonction qui dit si un marquage est inclus dans le tableau de marquage donné
public func IncludeMarking(current: CoverabilityMarking, graph: [CoverabilityGraph]) -> Bool {
  for markingGraph in graph {
    if (current > markingGraph.marking) {
      return true
    }
  }
  return false
}

//Fonction qui prend un marquage, trouve le marquage dans lequel il est inclus et
//remplace par omega toutes les places où le marquage est strict. plus grand
public func OmegaMarking(current: CoverabilityMarking, graph: [CoverabilityGraph]) -> CoverabilityMarking? {
  var result = current
  for markingGraph in graph {
    if (current > markingGraph.marking) { //Si current est un marquage strict. plus grand..
      for (place, _) in current { //Pour chaque place ..
        if (current[place]! > markingGraph.marking[place]!) { //.. s'il y en a plus, on remplace par omega
          result[place]! = Token.omega
        }
      }
      return result //On renvoie le nouveau marquage
    }
  }
  return nil
}

//Fonction qui affiche "proprement" un CoverabilityMarking
public func display(marking: CoverabilityMarking) {
  print("")
  for (place, token) in marking {
    switch(token) {
    case let(.some(x)) :
      print(place, ":", x, terminator: "  ")
    case (.omega) :
      print(place, ": ω", terminator: "  ")
    }
  }
  print("")
}


extension CoverabilityGraph: Sequence {

    public func makeIterator() -> AnyIterator<CoverabilityGraph> {
        var seen: [CoverabilityGraph] = []
        var toCheck = [self]

        return AnyIterator {
            guard let node = toCheck.popLast() else {
                return nil
            }

            let unvisited = node.successors.values.flatMap { successor in
                return seen.contains(where: { $0 === successor })
                    ? nil
                    : successor
            }

            seen.append(contentsOf: unvisited)
            toCheck.append(contentsOf: unvisited)

            return node
        }
    }

}


public extension PTTransition { //Nouvelles fonctions pour les PTTransitions pour gérer les graphes de couverture

  //Fonction qui renvoie vrai si on peut tirer la transition
  public func isFireableCoverability(from marking: CoverabilityMarking) -> Bool {
    for arc in self.preconditions {
      if marking[arc.place]! < arc.tokens {
        return false
      }
    }
    return true
  }

  //Fonction qui renvoie le marquage si la transition est tirable
  public func fireCoverability(from marking: CoverabilityMarking) -> CoverabilityMarking? {
    guard self.isFireableCoverability(from: marking) else {
        return nil
    }

    var result = marking
    for arc in self.preconditions {
        result[arc.place]! = result[arc.place]! - arc.tokens
    }
    for arc in self.postconditions {
        result[arc.place]! = result[arc.place]! + arc.tokens
    }

    return result
  }

}
