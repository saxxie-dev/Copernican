type planetDatum = {
  symbol: string,
  name: string,
  period: float,
  radius: float,
  offset: float,
}

let planetData = [
  {
    symbol: "☉",
    name: "Sol",
    period: 27.0,
    radius: 0.0,
    offset: 0.0,
  },
  {
    symbol: "☿",
    name: "Mercury",
    period: 88.0,
    radius: 41.78,
    offset: 0.7,
  },
  {
    symbol: "♀",
    name: "Venus",
    period: 225.0,
    radius: 67.02,
    offset: 4.1,
  },
  {
    symbol: "🜨︎",
    name: "Earth",
    period: 365.26,
    radius: 94.16,
    offset: 0.0,
  },
  {
    symbol: "♂",
    name: "Mars",
    period: 687.0,
    radius: 155.77,
    offset: 3.14,
  },
]

let findRealPlanetPosition = (n: int, t: float): (float, float) => {
  open Js.Math
  let p = planetData[n]
  let theta = p.offset +. t /. p.period
  (p.radius *. cos(theta), p.radius *. sin(theta))
}
