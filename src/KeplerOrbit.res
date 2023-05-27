// For finding actual x,y,z positions of objects in space
// using Keplerian orbits.
open Js.Math

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
  epochTime: Js.Date.t,
}

let meanAngularMotion = (orbit: orbitSpec): float => {0.0}

let meanAnomaly = (orbit: orbitSpec, time: Js.Date.t) => {
  open Js.Date
  let {epochTime} = orbit
  meanAngularMotion(orbit) *. (time->valueOf -. epochTime->valueOf)
}

let eccentricAnomaly = (orbit: orbitSpec, time: Js.Date.t) => {
  let tolerance = 1e-8
  let {eccentricity} = orbit
  let eccentricAnomaly = ref(meanAnomaly(orbit, time))
  let _M = meanAnomaly(orbit, time)
  let break = ref(false)

  while !break.contents {
    let _E = eccentricAnomaly.contents
    let error = eccentricAnomaly.contents -. eccentricity *. sin(eccentricAnomaly.contents) -. _M
    if abs_float(error) < tolerance {
      break := true
    }
    let derivative = 1. -. eccentricity *. cos(_E)
    eccentricAnomaly := _E -. error /. derivative
  }

  eccentricAnomaly
}

let trueAnomaly = (orbit: orbitSpec, time: Js.Date.t) => {0.0}
