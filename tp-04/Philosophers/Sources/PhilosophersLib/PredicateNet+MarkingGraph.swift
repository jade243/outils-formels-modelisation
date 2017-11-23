extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
      // Fonction qui renvoie le graphe de marquage à partir du marquage initial

      let g = PredicateMarkingNode(marking: marking) //PredicateMarkingNode initial
      var graph = [g] //PredicateMarkingNode déjà vus
      var toVisit = [g] //PredicateMarkingNode à voir

      while let current = toVisit.popLast() {
          for transition in self.transitions {
            //Bindings accessibles pour une certaine transition et un certain marquage
            let bindings = transition.fireableBingings(from: current.marking)
            for binding in bindings {
              if (transition.fire(from: current.marking, with: binding) != nil) {
                let m = transition.fire(from: current.marking, with: binding)! //Marquage tiré
                if (GreaterThanAll(marking: m, graph: graph)) { //Si on a un marquage plus grand que tous les autres, ...
                  print("Unbounded graph\n");
                  return nil //On renvoie que le graph n'est pas fini
                }
                else if (AlreadySeen(marking: m, graph: graph)){ //Si on n'a déjà vu le marquage, ...
                  let g1 = FindAlreadySeen(marking: m, graph: graph)! //on cherche ce marquage.
                  if (current.successors[transition] != nil) { //on regarde s'il a des successeurs..
                    var old = current.successors[transition]! //si oui, on les récupère et on ajoute le nouveau
                    old[binding] = g1
                    current.successors[transition] = old
                  }
                  else { //si non, on en crée un nouveau
                    let map = PredicateBindingMap(dictionaryLiteral: (binding, g1))
                    current.successors[transition] = map
                  }
                }
                else { //Si on n'avait jamais vu le marquage
                  let g1 = PredicateMarkingNode(marking: m) //on crée un nouveau PredicateMarkingNode
                  if (current.successors[transition] != nil) { //on regarde si current a déjà des succeseurs, ..
                    var old = current.successors[transition]! //si oui, on ajoute le nouveau
                    old[binding] = g1
                    current.successors[transition] = old
                  }
                  else { //si non, on en crée un nouveau
                    let map = PredicateBindingMap(dictionaryLiteral: (binding, g1))
                    current.successors[transition] = map
                  }

                  //On ajoute ..
                  graph.append(g1)    //.. aux PredicateMarkingNode déjà vus
                  toVisit.append(g1)  //.. aux PredicateMarkingNode à voir
                }
              }
            }

          }

      }

      return graph[0] //On renvoie le PredicateMarkingNode du marquage initial

    }

    // MARK: Internals

    //Fonction qui permet de parcourir le tableau des noeuds déjà visités et dit
    //si on a déjà vu le marquage en entrée
    private func AlreadySeen(marking: MarkingType, graph: [PredicateMarkingNode<T>]) -> Bool {
      for m in graph {
        if (self.equals(m.marking, marking)) {
          return true
        }
      }
      return false
    }

    //Fonction qui renvoie le marquage que l'on a déjà vu sinon nil
    private func FindAlreadySeen(marking: MarkingType, graph: [PredicateMarkingNode<T>]) -> PredicateMarkingNode<T>? {
      for m in graph {
        if (self.equals(m.marking, marking)) {
          return m
        }
      }
      return nil
    }

    //Fonction qui permet de parcourir le tableau des noeuds déjà visités et dit
    //si le marquage en entrée est strict. plus grand
    private func GreaterThanAll(marking: MarkingType, graph: [PredicateMarkingNode<T>]) -> Bool {
      for m in graph {
        if (self.greater(marking, m.marking)) {
          return true
        }
      }
      return false
    }

    private func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
       guard lhs.keys == rhs.keys else { return false }
       for (place, tokens) in lhs {
           guard tokens.count == rhs[place]!.count else { return false }
           for t in tokens {
               guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                   else {
                       return false
               }
           }
       }
       return true
   }

   private func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
       guard lhs.keys == rhs.keys else { return false }

       var hasGreater = false
       for (place, tokens) in lhs {
           guard tokens.count >= rhs[place]!.count else { return false }
           hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
           for t in rhs[place]! {
               guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                   else {
                       return false
               }
           }
       }
       return hasGreater
     }
    //
    // private func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
    //     guard lhs.keys == rhs.keys else { return false }
    //     for (place, tokens) in lhs {
    //         guard tokens.count == rhs[place]!.count else { return false }
    //         for t in tokens {
    //             guard rhs[place]!.contains(t) else { return false }
    //         }
    //     }
    //     return true
    // }
    //
    // private func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
    //     guard lhs.keys == rhs.keys else { return false }
    //
    //     var hasGreater = false
    //     for (place, tokens) in lhs {
    //         guard tokens.count >= rhs[place]!.count else { return false }
    //         hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
    //         for t in rhs[place]! {
    //             guard tokens.contains(t) else { return false }
    //         }
    //     }
    //     return hasGreater
    // }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
