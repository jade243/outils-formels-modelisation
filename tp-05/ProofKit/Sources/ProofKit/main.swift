import ProofKitLib

do {
  let a: Formula = "a"
  let b: Formula = "b"
  let c: Formula = "c"
  let d: Formula = "d"
  let e: Formula = "e"
  let f: Formula = "f"
  var formula : Formula

  // proposition
  print("Proposition")
  formula = a
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // negation
  print("\nNegation")
  formula = !a
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // disjunction : a proposition
  print("\nDisjunction where a is a proposition")
  formula = a || b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a || !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a || (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a || (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // disjunction : a negation
  print("\nDisjunction where a is a negation")
  formula = !a || b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a || !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a || (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a || (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // disjunction : a disjunction
  print("\nDisjunction where a is a disjunction")
  formula = (c || d) || b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) || !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) || (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) || (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // disjunction : a conjunction
  print("\nDisjunction where a is a conjunction")
  formula = (c && d) || b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) || !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) || (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) || (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // conjunction : a proposition
  print("\nConjunction where a is a proposition")
  formula = a && b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a && !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a && (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = a && (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")


  // conjunction : a negation
  print("\nConjunction where a is a negation")
  formula = !a && b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a && !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a && (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = !a && (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // conjunction : a disjunction
  print("\nConjunction where a is a disjunction")
  formula = (c || d) && b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) && !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) && (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c || d) && (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  // conjunction : a conjunction
  print("\nConjunction where a is a conjunction")
  formula = (c && d) && b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) && !b
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) && (e || f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")

  formula = (c && d) && (e && f)
  print("cnf: \(formula.cnf)\ndnf: \(formula.dnf)\n")
}

do {
  print("\n\nSome examples\n\n")
  let a: Formula = "a"
  let b: Formula = "b"
  let c: Formula = "c"
  let d: Formula = "d"

  let ex1 = (a && !(!b)) || !(!c || d)
  let ex2 = (a => b) && (b || !a)
  let ex3 = !(a && (b || c))
  let ex4 = (a => b) || !(a && b)
  let ex5 = (!a || b && c) && c

  print("Formula : \(ex1)")
  print("cnf : \(ex1.cnf)")
  print("dnf : \(ex1.dnf)\n")
  print("")

  print("Formula : \(ex2)")
  print("cnf : \(ex2.cnf)")
  print("dnf : \(ex2.dnf)\n")
  print("")

  print("Exercise 2 Serie 9\n")

  print("Formula : \(ex3)")
  print("cnf : \(ex3.cnf)")
  print("dnf : \(ex3.dnf)\n")
  print("")

  print("Formula : \(ex4)")
  print("cnf : \(ex4.cnf)")
  print("dnf : \(ex4.dnf)\n")
  print("")

  print("Formula : \(ex5)")
  print("cnf : \(ex5.cnf)")
  print("dnf : \(ex5.dnf)\n")
  print("")
}
