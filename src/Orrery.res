open ReactNativeSvg

module Planet = {
  open! ReactNative.Style
  open! Js.Math
  @react.component
  let make = (~radius: float, ~theta: float, ~id: string) => {
    Js.Console.log3(radius, theta, id)
    let (pressed, setPressed) = React.useState(_ => false)
    <>
      {if radius > 0. {
        <RadialGradient
          id cx={pct(50. *. (1. +. cos(theta)))} cy={pct(50. *. (1. -. sin(theta)))} r={pct(44.)}>
          <Stop offset={pct(0.)} stopColor="#FFF" />
          <Stop offset={pct(100.)} stopColor="#FFF" stopOpacity="0.05" />
        </RadialGradient>
      } else {
        <> </>
      }}
      <Circle
        cx={dp(0.)}
        cy={dp(0.)}
        r={dp(radius)}
        stroke={`url(#${id})`}
        strokeWidth={dp(1.)}
        strokeDasharray={[dp(5.), dp(5.)]}
        fill="#FFF"
        fillOpacity={pressed ? "0.03" : "0"}
      />
      <Circle
        cx={dp(radius *. cos(theta))}
        cy={dp(-.radius *. sin(theta))}
        r={dp(5.0)}
        fill="#FFF"
        onPressIn={_ => setPressed(_ => true)}
        onPressOut={_ => setPressed(_ => false)}
      />
    </>
  }
}

let earthXAngle = ((ex: float, ey: float), (px: float, py: float)): float => {
  atan2(py -. ey, px -. ex)
}
let angles = (time: Js.Date.t) => {
  open! KeplerOrbit
  open! PlanetData.PlanetMotions
  let (ex, ey, _) = truePosition(earth, time)
  let (sx, sy, _) = (0., 0., 0.)
  let (mx, my, _) = truePosition(mars, time)
  let (vx, vy, _) = truePosition(venus, time)
  let (mex, mey, _) = truePosition(mercury, time)

  [
    earthXAngle((ex, ey), (mx, my)),
    earthXAngle((ex, ey), (vx, vy)),
    earthXAngle((ex, ey), (mex, mey)),
    earthXAngle((ex, ey), (sx, sy)),
  ]
}

module Earth = {
  open! ReactNative.Style
  open! Js.Math
  @react.component
  let make = (~radius: float, ~theta: float, ~id: string, ~angles: array<float>) => {
    let (pressed, setPressed) = React.useState(_ => false)
    <>
      {if radius > 0. {
        <RadialGradient
          id cx={pct(50. *. (1. +. cos(theta)))} cy={pct(50. *. (1. -. sin(theta)))} r={pct(44.)}>
          <Stop offset={pct(0.)} stopColor="#FFF" />
          <Stop offset={pct(100.)} stopColor="#FFF" stopOpacity="0.05" />
        </RadialGradient>
      } else {
        <> </>
      }}
      <Circle
        cx={dp(0.)}
        cy={dp(0.)}
        r={dp(radius)}
        stroke={`url(#${id})`}
        strokeWidth={dp(1.)}
        strokeDasharray={[dp(5.), dp(5.)]}
        fill="#FFF"
        fillOpacity={pressed ? "0.03" : "0"}
      />
      <Circle
        cx={dp(radius *. cos(theta))}
        cy={dp(-.radius *. sin(theta))}
        r={dp(5.0)}
        fill="#FFF"
        onPressIn={_ => setPressed(_ => true)}
        onPressOut={_ => setPressed(_ => false)}
      />
      {React.array(
        Belt.Array.map(angles, theta2 =>
          <Line
            key={`${Belt.Float.toString(theta2)}`}
            x1={dp(radius *. cos(theta))}
            y1={dp(-.radius *. sin(theta))}
            x2={dp(radius *. cos(theta) +. 500. *. cos(theta2))}
            y2={dp(-.radius *. sin(theta) -. 500. *. sin(theta2))}
            strokeWidth={dp(1.)}
            stroke="#5FF"
          />
        ),
      )}
    </>
  }
}

module SolarSystem = {
  open ReactNative.Style

  @react.component
  let make = (~time: Js.Date.t) => {
    let earthAngle = KeplerOrbit.projectedPositionPolar(PlanetData.PlanetMotions.earth, time)

    let planetsToRender = [#pluto, #uranus, #neptune, #saturn, #jupiter, #mars, #venus, #mercury]
    let planetSvgs = Array.mapi((i, planet) => {
      open! KeplerOrbit
      let motion = PlanetData.planetMotion(planet)
      let trueProjectedPosition = projectedPositionPolar(motion, time)
      let renderedPosition = LocalConformal.locallyConformalMap(
        earthAngle,
        {r: 45.0, theta: earthAngle.theta},
        trueProjectedPosition,
        Belt.Int.toFloat(100 - 10 * i),
      )
      <Planet
        radius={renderedPosition.r}
        theta={renderedPosition.theta}
        key={(planet :> string)}
        id={(planet :> string)}
      />
    }, planetsToRender)

    <Svg width={pct(100.)} height={pct(100.)} viewBox={"-130 -130 260 260"}>
      <Earth radius={45.0} theta={earthAngle.theta} id="earth" angles={angles(time)} />
      {React.array(planetSvgs)}
      <Planet radius={0.} theta={0.} id="sol" />
    </Svg>
  }
}
