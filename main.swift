import TaskManagerLib
import PetriKit


// *** Réseau de Petri donné dans l'énoncé ***
let taskManager = createTaskManager()

// On charge les places et les transitions
let taskPool = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress = taskManager.places.first { $0.name == "inProgress" }!

let create = taskManager.transitions.first { $0.name == "create" }!
let spawn = taskManager.transitions.first { $0.name == "spawn" }!
let exec = taskManager.transitions.first { $0.name == "exec" }!
let success = taskManager.transitions.first { $0.name == "success" }!

// On exécute une séquence qui pose problème
var m : PTMarking = [taskPool: 0, processPool: 0, inProgress: 0]
for t in [create, spawn, spawn, exec, exec, success] {
  m = t.fire(from : m)!
}

print("RdP incorrect, marquage problématique : \n",m,"\nLe processus en cours ne peut pas réussir\n")
// On obtient le marquage suivant :
// [inProgress: 1, taskPool: 0, processPool: 0]
// On voit que l'on a un processus en cours mais il ne peut pas réussir car il
// n'y a plus de jetons dans taskPool.
// Le problème est que l'on peut déclencher un nouveau processus avec une tâche
// qui en cours d'éxécution.

// *** Réseau de Petri modifié pour corriger le problème ***
let correctTaskManager = createCorrectTaskManager()

// On charge les places et les transitions
let correctTaskPool = correctTaskManager.places.first { $0.name == "taskPool" }!
let correctProcessPool = correctTaskManager.places.first { $0.name == "processPool" }!
let correctInProgress = correctTaskManager.places.first { $0.name == "inProgress" }!

let correctCreate = correctTaskManager.transitions.first { $0.name == "create" }!
let correctSpawn = correctTaskManager.transitions.first { $0.name == "spawn" }!
let correctExec = correctTaskManager.transitions.first { $0.name == "exec" }!
let correctSuccess = correctTaskManager.transitions.first { $0.name == "success" }!

// On réexécute en partie la séquence qui posait problème
var correctM : PTMarking = [correctTaskPool: 0, correctProcessPool: 0, correctInProgress: 0]
for t in [correctCreate, correctSpawn, correctSpawn, correctExec] {
  correctM = t.fire(from : correctM)!
}

print("RdP corrigé :\n",correctM,"\nIl faut d'abord finir le processus en cours en avant d'utiliser l'autre\n")
// On voit qu'à ce stade, on ne pourrait pas tirer exec.
// On pourrait soit tirer success ou fail, soit créer de nouvelles tâches et/ou
// de nouveaux processus pour tirer de nouveau exec.
// Les modifications sur le réseau permettent de s'assurer qu'une tâche ne puisse
// pas lancer plusieurs processus alors qu'elle est en cours d'exécution
