open Belt

module XmlHttpRequest = {
  @bs.new external make: unit => {..} = "XMLHttpRequest"
}

type picture = {
  large: string,
  medium: string,
  small: string,
}
type name = {
  first: string,
  last: string,
}
type t = {
  picture: option<picture>,
  email: string,
  name: name,
}

let query = () => {
  Future.make(resolve => {
    let request = XmlHttpRequest.make()
    let () = request["open"]("GET", "https://randomuser.me/api/", true)
    request["responseType"] = "json"
    let () = request["addEventListener"]("load", () => {
      let value = if request["status"] == 200 {
        let result: array<t> = request["response"]["results"]
        Ok(result[0])
      } else {
        Error(request["status"])
      }
      resolve(value)
    })
    let () = request["addEventListener"]("error", () => {
      resolve(Error(0))
    })
    request["send"]()
  })->Future.flatMapOk(value => {
    let random = Js.Math.random()
    Future.value(
      if random > 0.66 {
        Ok(value)
      } else if random > 0.33 {
        Ok(None)
      } else {
        Error(404)
      },
    )
  })
}
