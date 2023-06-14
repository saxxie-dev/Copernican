type planetMotion =
  | TruePlanet(KeplerOrbit.orbitSpec)
  | Moon(KeplerOrbit.orbitSpec)
  | Earth(KeplerOrbit.orbitSpec)
  | Sun

type planetSpec = {
  name: string,
  motion: planetMotion,
}

let degrees = (x: float): float => {
  x /. 180. *. Js.Math._PI
}
module PlanetMotions = {
  open! KeplerOrbit

  let mercury = {
    semiMajor: 0.38709893,
    eccentricity: 0.20563069,
    inclination: degrees(7.00487),
    ascendingNodeLongitude: degrees(48.33167),
    periapsisAngle: degrees(77.45645 -. 48.33167),
    epochAngle: degrees(252.25084),
  }
  let venus = {
    semiMajor: 0.7233,
    eccentricity: 0.00676,
    inclination: degrees(3.398),
    ascendingNodeLongitude: degrees(76.67),
    periapsisAngle: degrees(131.77 -. 76.67),
    epochAngle: degrees(181.98),
  }
  let earth = {
    semiMajor: 1.00000011,
    eccentricity: 0.01671022,
    inclination: degrees(0.00005),
    ascendingNodeLongitude: degrees(-11.26064),
    periapsisAngle: degrees(102.94719 +. 11.26064),
    epochAngle: degrees(100.46435),
  }
  let mars = {
    semiMajor: 1.52366231,
    eccentricity: 0.09341233,
    inclination: degrees(1.85061),
    ascendingNodeLongitude: degrees(49.57854),
    periapsisAngle: degrees(336.04084 -. 49.57854),
    epochAngle: degrees(355.45332),
  }
  let jupiter = {
    semiMajor: 5.2025,
    eccentricity: 0.04839266,
    inclination: degrees(1.30530),
    ascendingNodeLongitude: degrees(100.55615),
    periapsisAngle: degrees(14.75385 -. 100.55615),
    epochAngle: degrees(34.40438),
  }
  let saturn = {
    semiMajor: 9.53707032,
    eccentricity: 0.05415060,
    inclination: degrees(2.48446),
    ascendingNodeLongitude: degrees(113.71504),
    periapsisAngle: degrees(92.43194 -. 113.71504),
    epochAngle: degrees(49.94432),
  }
  let uranus = {
    semiMajor: 19.19126393,
    eccentricity: 0.04716771,
    inclination: degrees(0.76986),
    ascendingNodeLongitude: degrees(74.22988),
    periapsisAngle: degrees(170.96424 -. 74.22988),
    epochAngle: degrees(313.23218),
  }
  let neptune = {
    semiMajor: 30.06896348,
    eccentricity: 0.00858587,
    inclination: degrees(1.76917),
    ascendingNodeLongitude: degrees(131.72169),
    periapsisAngle: degrees(44.97135 -. 131.72169),
    epochAngle: degrees(304.88003),
  }
  let pluto = {
    semiMajor: 39.48168677,
    eccentricity: 0.24880766,
    inclination: degrees(17.14175),
    ascendingNodeLongitude: degrees(110.30347),
    periapsisAngle: degrees(113.76329),
    epochAngle: degrees(238.92881),
  }
}

let planets: array<planetSpec> = [
  {
    name: "Sun",
    motion: Sun,
  },
  {
    name: "Mercury",
    motion: TruePlanet(PlanetMotions.mercury),
  },
  {
    name: "Venus",
    motion: TruePlanet(PlanetMotions.venus),
  },
  {
    name: "Earth",
    motion: Earth(PlanetMotions.earth),
  },
  // {
  //   name: "Moon",
  //   motion: Moon({
  //     semiMajor: 0.00256898042,
  //     eccentricity: 0.0549006,
  //     inclination: degrees(0.0),
  //     ascendingNodeLongitude: degrees(0.0),
  //     periapsisAngle: degrees(0.0),
  //     epochAngle: degrees(0.0),
  //   }),
  // },
  {
    name: "Mars",
    motion: TruePlanet(PlanetMotions.mars),
  },
  {
    name: "Jupiter",
    motion: TruePlanet(PlanetMotions.jupiter),
  },
  {
    name: "Saturn",
    motion: TruePlanet(PlanetMotions.saturn),
  },
  {
    name: "Uranus",
    motion: TruePlanet(PlanetMotions.uranus),
  },
  {
    name: "Neptune",
    motion: TruePlanet(PlanetMotions.neptune),
  },
  {
    name: "Pluto",
    motion: TruePlanet(PlanetMotions.pluto),
  },
]
