import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
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


// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

//Toutes les fonctions nécessaires sont dans PTNet+Extensions.swift
if let markingGraph = model.markingGraph(from: initialMarking) {
  //Affichage du graphe de marquage
  //model.display(markingGraph: markingGraph)

  //Question 1 :
  let nbNodes = model.countNodes(markingGraph: markingGraph)
  print("\n1. Combien d’états différents votre réseau peut-il avoir?")
  print("Il y a ",nbNodes," noeuds dans le graphe de marquage")

  //Question 2 :
  let testSmokers = model.smokers(markingGraph: markingGraph)
  print("\n2. Est-il possible que deux fumeurs différents fument en même temps?")
  if (testSmokers == true) {
    print("Il peut y avoir 2 fumeurs en même temps")
  }
  else {
    print("Il ne peut pas y avoir 2 fumeurs en même temps")
  }

  //Question 3 :
  let testItems = model.sameItems(markingGraph: markingGraph)
  print("\n3. Est-il possible d’avoir deux fois le même ingrédient sur la table?")
  if (testItems == true) {
    print("Il peut y avoir 2 même ingrédients sur la table")
  }
  else {
    print("Il ne peut pas y avoir 2 même ingrédients sur la table")
  }
}
