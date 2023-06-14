open KeplerOrbit
open Test

let closeTo = (delta, a, b) => {
  Js.Math.abs_float(a -. b) < delta
}
// Iteration helper
// It should converge

// Earth's orbit (un-inclined)
test("Earth's orbit", () => {
  let earthSpec = PlanetData.PlanetMotions.earth
  let perihelionRadius = radiusAtPerihelion(earthSpec)
  assertion(
    ~message="Perihelion distance should match",
    ~operator="closeTo(+/- 1e-4)",
    closeTo(0.0001),
    perihelionRadius,
    0.9832,
  )
  let perihelionTime = perihelionTime(earthSpec)
  assertion(
    ~message="Perihelion time should match",
    ~operator="closeTo(+/- 1 day)",
    closeTo(24. *. 60. *. 60. *. 1000.),
    perihelionTime->Js.Date.getTime,
    Js.Date.utcWithYMD(~year=2000., ~month=0., ~date=4., ()),
  )

  let aphelionRadius = radiusAtAphelion(earthSpec)
  assertion(
    ~message="Aphelion distance should match",
    ~operator="closeTo(+/- 1e-4)",
    closeTo(0.0001),
    aphelionRadius,
    1.0167,
  )

  let yearLength = orbitPeriod(earthSpec)
  assertion(
    ~message="Year length should match",
    ~operator="closeTo(+/- 30min)",
    closeTo(60. *. 30.),
    yearLength,
    365.2425 *. 24. *. 60. *. 60.,
  )

  // it should have the right perihelion and aphelion times
})

test("Pluto's orbit", () => {
  open! PlanetData
  let plutoSpec = PlanetData.PlanetMotions.pluto

  let yearLength = orbitPeriod(plutoSpec)
  let perihelionRadius = radiusAtPerihelion(plutoSpec)
  assertion(
    ~message="Perihelion distance should match",
    ~operator="closeTo(+/- 1e-3)",
    closeTo(0.001),
    perihelionRadius,
    29.658,
  )

  let plutoRadiusDuringLastPerihelion = trueRadius(
    plutoSpec,
    Js.Date.makeWithYMD(~year=1989., ~month=8., ~date=5., ()),
  )
  assertion(
    ~message="radius during last perihelion should be correct",
    ~operator="closeTo(+/- 1e-3)",
    closeTo(0.001),
    plutoRadiusDuringLastPerihelion,
    perihelionRadius,
  )

  let perihelionTime = perihelionTime(plutoSpec)
  assertion(
    ~message="Perihelion time should match",
    ~operator="closeTo(+/- 100 days)",
    closeTo(100. *. 24. *. 60. *. 60. *. 1000.),
    perihelionTime->Js.Date.getTime,
    Js.Date.utcWithYMD(~year=1989., ~month=8., ~date=5., ()),
  )

  let aphelionRadius = radiusAtAphelion(plutoSpec)
  assertion(
    ~message="Aphelion distance should match",
    ~operator="closeTo(+/- 1e-4)",
    closeTo(0.001),
    aphelionRadius,
    49.305,
  )

  let aphelionTime = aphelionTime(plutoSpec)
  assertion(
    ~message="Aphelion time should match",
    ~operator="closeTo(+/- 200 days)",
    closeTo(200. *. 24. *. 60. *. 60. *. 1000.),
    aphelionTime->Js.Date.getTime,
    Js.Date.utcWithYM(~year=2114., ~month=1., ()),
  )

  assertion(
    ~message="Year length should match",
    ~operator="closeTo(+/- 100 day)",
    closeTo(100. *. 24. *. 60. *. 60.),
    yearLength,
    247.94 *. 365.2425 *. 24. *. 60. *. 60.,
  )
})
