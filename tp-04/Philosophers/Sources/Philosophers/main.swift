import PetriKit
import PhilosophersLib


//Combien y a-t-il de marquages possibles dans le modèle des philosophes
//non bloquable à 5 philosophes?
do {
  let n = lockFreePhilosophers(n: 5)
  let g = n.markingGraph(from: n.initialMarking!)!
  print("Il y a ",g.count, "marquages possibles pour les philosophes non bloquables à 5 philosophes")
}

//Combien y a-t-il de marquages possibles dans le modèle des philosophes
//bloquable à 5 philosophes?
do {
  let n = lockablePhilosophers(n: 5)
  let g = n.markingGraph(from: n.initialMarking!)!
  print("Il y a ",g.count, "marquages possibles pour les philosophes bloquables à 5 philosophes")
}

//Donnez un exemple d’état où le réseau est bloqué dans le modèle des
//philosophes bloquable à 5 philosophes?
do {
  let n = lockablePhilosophers(n: 5)
  let g = n.markingGraph(from: n.initialMarking!)!
  let i = g.makeIterator()
  while let marking = i.next() {
      if (marking.successors.isEmpty) {
        print("On a trouvé un marquage bloquable :")
        print(marking.marking)
      }
  }

  //On voit que le marquage bloquant est celui où tous les philosophes ont tirés
  //la fourchette à gauche et attendent la fourchette à droite indifiniment...
}
