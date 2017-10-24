import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}


public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
      // Fonction qui renvoie le graphe de marquage à partir du marquage initial

      let g = MarkingGraph(marking: marking) //markingGraph initial
      var graph = [g] //markingGraph déjà vus
      var toVisit = [g] //markingGraph à voir

      while let current = toVisit.popLast() { //On prend un marquage
        for transition in self.transitions {
          if (transition.isFireable(from: current.marking)) { //Pour ses transitions tirables..
            let m = transition.fire(from: current.marking)!
            if (egMark(actual: m, graph: graph)) { //.. on teste si on arrive à un nouveau marquage
              let g1 = MarkingGraph(marking: m) //On crée un nouveau markingGraph
              //On l'ajoute ..
              current.successors[transition] = g1 //.. aux successeurs
              graph.append(g1) //.. aux markingGraph déjà vus
              toVisit.append(g1) //.. aux markingGraph à visiter
            }
            if (m == current.marking) {
              current.successors[transition] = current
            }
          }
        }
      }
      return graph[0];
    }

    private func egMark(actual: PTMarking, graph: [MarkingGraph]) -> Bool {
      //Fonction qui dit si un marquage a déjà été vu ou pas

      for marking in graph {
        if (marking.marking == actual) {
          return false //Si le marquage a déjà été vu
        }
      }
      return true //Si le marquage n'a pas déjà été vu
    }

    public func display(markingGraph: MarkingGraph) {
      //Fonction qui affiche tous les marquages possibles

      var seen = [markingGraph]
      var toVisit = [markingGraph]
      print(markingGraph.marking)

      while let current = toVisit.popLast() {
        for (transition, markingG) in current.successors {
          if !(seen.contains(where: { $0 === markingG })) {
            seen.append(markingG)
            toVisit.append(markingG)
            print(transition,"\n",markingG.marking)
          }
        }
      }
    }

    public func countNodes(markingGraph: MarkingGraph) -> Int {
      //Fonction qui compte le nombre de noeuds dans le graphe de marquage

      var seen = [markingGraph] //Marquages explorés
      var toVisit = [markingGraph] //Marquages à explorer

      while let current = toVisit.popLast() { //On prend un marquage
        for (_, markingG) in current.successors {
          if !(seen.contains(where: { $0 === markingG })) { //Si on ne l'a pas encore vu
            seen.append(markingG) //On l'ajoute
            toVisit.append(markingG)
          }
        }
      }

      return seen.count //On compte le nombre de marquages vus
    }

    public func smokers(markingGraph: MarkingGraph) -> Bool {
      //Fonction qui dit si 2 personnes peuvent fumer en même temps

      var seen = [markingGraph]
      var toVisit = [markingGraph]

      while let current = toVisit.popLast() {
        for (_, markingG) in current.successors {
          if !(seen.contains(where: { $0 === markingG })) {
            seen.append(markingG)
            toVisit.append(markingG)
            let s1 = self.places.first(where: { $0.name == "s1" })! //On récupère les places liées aux fumeurs
            let s2 = self.places.first(where: { $0.name == "s2" })!
            let s3 = self.places.first(where: { $0.name == "s3" })!
            if ((markingG.marking[s1] == 1 && markingG.marking[s2] == 1) //S'il y a deux fumeurs en même temps
                  || (markingG.marking[s1] == 1 && markingG.marking[s3] == 1)
                  || (markingG.marking[s2] == 1 && markingG.marking[s3] == 1)) {
              return true
            }
          }
        }
      }
      return false
    }

    public func sameItems(markingGraph: MarkingGraph) -> Bool {
      // Fonction qui dit si un ingrédient peut apparaître 2 fois sur la table

      var seen = [markingGraph]
      var toVisit = [markingGraph]

      while let current = toVisit.popLast() {
        for (_, markingG) in current.successors {
          if !(seen.contains(where: { $0 === markingG })) {
            seen.append(markingG)
            toVisit.append(markingG)
            let p = self.places.first(where: { $0.name == "p" })! //On récupère les places liées aux ingrédients
            let m = self.places.first(where: { $0.name == "m" })!
            let t = self.places.first(where: { $0.name == "t" })!
            if (markingG.marking[p] == 2 || markingG.marking[m] == 2 || markingG.marking[t] == 2) { //S'il y en a 2 sur la table
              print(markingG.marking)
              return true
            }
          }
        }
      }
      return false
    }


}
