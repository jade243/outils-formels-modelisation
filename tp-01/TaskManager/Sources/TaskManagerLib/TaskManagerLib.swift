import PetriKit

public func createTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress],
        transitions: [create, spawn, success, exec, fail])
}


public func createCorrectTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")
    // On rajoute une place
    let counter = PTPlace(named: "counter")
    // Cette place permet de compter le nombre de tâches et de s'assurer qu'une
    // tâche ne puisse pas être lancée par 2 processus différents

    // Quand on crée une tâche, on met un jeton dans "counter"
    // Si on exécute cette tâche avec un processus, on enlève le jeton de "counter"
    // (Si on a plusieurs tâches et plusieurs processus, on peut tirer "exec" plusieurs fois)
    // La tâche se termine :
    //  - si elle réussit, on l'enlève de "taskPool" et de "inProgress"
    //  - si elle échoue, on l'enlève de "inProgress", on la laisse dans "taskPool" et
    //    on remet un jeton dans "counter" pour qu'elle puisse être exécutée de nouveau

    // Transitions

    // On modifie create
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool), PTArc(place: counter)])
        //Le fait de créer une tâche ajoute un jeton dans "counter"

    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])

    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])

    //On modifie exec
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool), PTArc(place: counter)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
        //Lorsqu'on lance une tâche avec un processus, on enlève un jeton à "counter"

    //On modifie fail
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: counter)])
        //Si la tâche échoue, on remet un jeton dans "counter"

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress, counter],
        transitions: [create, spawn, success, exec, fail])
}
