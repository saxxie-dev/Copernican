open! Js.Math

type orbitSpec = {
  // Ellipse shape
  semiMajor: float,
  eccentricity: float,
  // Elliptic plane + orientation
  inclination: float, // 0..PI/2
  ascendingNodeLongitude: float, // -PI..PI
  periapsisAngle: float, // 0..2*PI
  // Orbit initial angle
  epochAngle: float,
}

let _GM = 1.98847e30 *. 6.6743015e-11 /. 3.347927e+33

let astroEpoch = Js.Date.utcWithYM(~year=2000., ~month=0., ())
let astroTime = (date: Js.Date.t): float => {
  (date->Js.Date.getTime -. astroEpoch) /. 1000.
}
let astroDate = (t: float) => {
  Js.Date.fromFloat(astroEpoch +. 1000. *. t)
}

let orbitPeriod = (orbit: orbitSpec): float => {
  let {semiMajor} = orbit
  2.0 *. _PI *. sqrt(pow_float(~base=semiMajor, ~exp=3.) /. _GM)
}

let meanMotion = (orbit: orbitSpec): float => {
  2.0 *. _PI /. orbitPeriod(orbit)
}

let perihelionTime = (orbit: orbitSpec): Js.Date.t => {
  let {epochAngle, periapsisAngle, ascendingNodeLongitude} = orbit
  astroDate(
    (periapsisAngle +. ascendingNodeLongitude -. epochAngle) /. (2. *. _PI) *. orbitPeriod(orbit),
  )
}
let aphelionTime = (orbit: orbitSpec): Js.Date.t => {
  let {epochAngle, periapsisAngle, ascendingNodeLongitude} = orbit
  astroDate(
    ((periapsisAngle +. ascendingNodeLongitude -. epochAngle) /. (2. *. _PI) +. 1. /. 2.) *.
      orbitPeriod(orbit),
  )
}

let meanAnomaly = (orbit: orbitSpec, time: Js.Date.t) => {
  meanMotion(orbit) *. (time->astroTime -. perihelionTime(orbit)->astroTime)
}

let radiusAtTrueAnomaly = (orbit: orbitSpec, trueAnomaly: float): float => {
  let {semiMajor, eccentricity} = orbit
  semiMajor *. (1. -. eccentricity *. eccentricity) /. (1. +. eccentricity *. cos(trueAnomaly))
}

let sweepRate = (orbit: orbitSpec): float => {
  let {eccentricity, semiMajor} = orbit
  sqrt(1. -. eccentricity *. eccentricity) *. meanMotion(orbit) *. semiMajor *. semiMajor
}

let radiusAtPerihelion = (orbit: orbitSpec) => radiusAtTrueAnomaly(orbit, 0.)
let radiusAtAphelion = (orbit: orbitSpec) => radiusAtTrueAnomaly(orbit, _PI)

// Tries converging to an attractive fixed point.
// Do not run on function with , obviously
let rec approximateFixedPoint = (f: float => float, x: float): float => {
  let y = f(x)
  if y -. x < 1e-8 {
    y
  } else {
    approximateFixedPoint(f, y)
  }
}

let eccentricAnomaly = (orbit: orbitSpec, time: Js.Date.t): float => {
  let {eccentricity} = orbit
  let _M = meanAnomaly(orbit, time)
  approximateFixedPoint(_E => _M +. eccentricity *. sin(_E), 0.)
}

let eccentricRadius = (orbit: orbitSpec) => {
  radiusAtPerihelion(orbit) /. (1. -. orbit.eccentricity)
}

let trueRadius = (orbit: orbitSpec, time: Js.Date.t) => {
  eccentricRadius(orbit) *. (1. -. orbit.eccentricity *. cos(eccentricAnomaly(orbit, time)))
}

let trueAngle = (orbit: orbitSpec, time: Js.Date.t) => {
  let {eccentricity} = orbit
  2. *.
  atan(
    tan(eccentricAnomaly(orbit, time) /. 2.) *. sqrt((1. +. eccentricity) /. (1. -. eccentricity)),
  )
}

let truePostion = (orbit: orbitSpec, time: Js.Date.t): (float, float, float) => {
  let r = trueRadius(orbit, time)
  let theta = trueAngle(orbit, time)
  let {inclination, ascendingNodeLongitude, periapsisAngle, epochAngle} = orbit
  let omega_ = ascendingNodeLongitude +. periapsisAngle
  (
    r *. cos(theta +. omega_),
    r *. sin(theta +. omega_),
    r *. sin(periapsisAngle +. theta) *. inclination,
  )
}
