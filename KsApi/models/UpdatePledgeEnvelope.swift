import Argo
import Curry
import Runes

public struct UpdatePledgeEnvelope {
  public private(set) var newCheckoutUrl: String?
  public private(set) var status: Int
}

extension UpdatePledgeEnvelope: Argo.Decodable {
  public static func decode(_ json: JSON) -> Decoded<UpdatePledgeEnvelope> {
    return curry(UpdatePledgeEnvelope.init)
      <^> json <|? ["data", "new_checkout_url"]
      <*> ((json <| "status" >>- stringToIntOrZero) <|> (json <| "status"))
  }
}

private func stringToIntOrZero(_ string: String) -> Decoded<Int> {
  return
    Double(string).flatMap(Int.init).map(Decoded.success)
      ?? Int(string).map(Decoded.success)
      ?? .success(0)
}
