import PetriKit

public enum Token: Comparable, ExpressibleByIntegerLiteral {

    //On déclare soit Token.omega soit Token(integerLiteral: UInt)
    case some(UInt)
    case omega

    public init(integerLiteral value: UInt) {
        self = .some(value)
    }

    //Tests de comparaison entre Token et UInt

    //Soit on a lhs.some(x) == rhs.some(x) soit un des deux vaut omega => vrai
    public static func ==(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x), .some(y)):
            return x == y
        default:
            return true
        }
    }

    public static func ==(lhs: Token, rhs: UInt) -> Bool {
        return lhs == Token.some(rhs)
    }

    public static func ==(lhs: UInt, rhs: Token) -> Bool {
        return Token.some(lhs) == rhs
    }

    //Soit on a lhs.some(x) < rhs.some(y), soit on a lhs.some(x) < .omega => vrai
    public static func <(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x), .some(y)):
            return x < y
        case (_, .omega):
            return true
        default:
            return false
        }
    }

    public static func <(lhs: Token, rhs: UInt) -> Bool {
        return lhs < Token.some(rhs)
    }

    public static func >(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x), .some(y)):
            return x > y
        case (.omega, _):
            return true
        default:
            return false
        }
    }

    //Fonction qui réalise la soustraction : soit lhs.some(x)-rhs soit .omega-rhs = omega
    public static func -(lhs: Token, rhs: UInt) -> Token {
        switch (lhs) {
        case let (.some(x)):
            return Token.some(x-rhs)
        case (.omega):
            return Token.omega
        }
    }

    //Fonction qui réalise l'addition : soit lhs.some(x)+rhs soit .omega+rhs = omega
    public static func +(lhs: Token, rhs: UInt) -> Token {
        switch (lhs) {
        case let (.some(x)):
            return Token.some(x+rhs)
        case (.omega):
            return Token.omega
        }
    }


}

extension Dictionary where Key == PTPlace, Value == Token {

    //Fonction qui renvoie vrai si un CoverabilityMarking est < qu'un autre
    public static func >(lhs: Dictionary, rhs: Dictionary) -> Bool {
        guard lhs.keys == rhs.keys else {
            return false
        }

        var hasGreater = false
        for place in lhs.keys { //Pour toutes les places..
            //S'il existe une place pour laquelle il y a moins de jetons, => faux
            guard lhs[place]! >= rhs[place]! else { return false }
            if lhs[place]! > rhs[place]! { //Il faut au moins une pièce pour laquelle il y en a plus
                hasGreater = true
            }
        }

        return hasGreater
    }

    //Fonction qui renvoie vrai si un CoverabilityMarking est == à un autre
    public static func ==(lhs: Dictionary, rhs: Dictionary) -> Bool {
        guard lhs.keys == rhs.keys else { //on vérifie qu'on a les mêmes clés
            return false
        }

        for place in lhs.keys { //Pour toutes les places ..
          if (!StrictlyEqual(lhs: lhs[place]!, rhs: rhs[place]!)) {
            return false
          }
        }

        return true
    }

    //Fonction qui dit si les marquages sont "vraiment" les mêmes
    // --> il faut soit omega == omega soit x == y
    //Si on a omega == UInt --> false
    public static func StrictlyEqual(lhs: Token, rhs: Token) -> Bool {
      switch (lhs, rhs) {
      case let (.some(x), .some(y)):
          return x == y
      case (.omega, .omega) :
          return true
      default:
          return false
      }
    }



}

public typealias CoverabilityMarking = [PTPlace: Token]
