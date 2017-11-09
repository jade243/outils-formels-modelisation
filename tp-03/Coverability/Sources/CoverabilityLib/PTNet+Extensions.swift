import PetriKit


public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
      let g = CoverabilityGraph(marking: marking) //CoverabilityMarking initial
      var graph = [g] //CoverabilityGraph déjà vus
      var toVisit = [g] //CoverabilityGraph à voir

      while let current = toVisit.popLast() { //On prend un marquage
        for transition in self.transitions {
          if (transition.isFireableCoverability(from: current.marking)) { //Pour ses transitions tirables..
            var m = transition.fireCoverability(from: current.marking)!
            if (IsSameMarking(current: m, graph: graph)) { //Si on a déjà vu le marquage ..
              let g1 = SameMarking(current: m, graph: graph)! //On associe le CoverabilityGraph aux successeurs
              current.successors[transition] = g1
            }
            else { //Si on n'a pas déjà vu le marquage
              if (IncludeMarking(current: m, graph: graph)) { //S'il est inclus dans un autre déjà vu
                //On remplace les places où le nombre de jetons est strict. plus grand par omega
                m = OmegaMarking(current: m, graph: graph)!
              }

              //Dans tous les cas, on crée un nouveau CoverabilityGraph :
              let g1 = CoverabilityGraph(marking: m)
              //On ajoute le CoverabilityGraph :
              current.successors[transition] = g1 //aux successeurs
              graph.append(g1) //aux CoverabilityGraph déjà vus
              toVisit.append(g1) //aux CoverabilityGraph à voir
            }
          }
        }
      }
      return graph[0];
    }

}
