open ReactNativeSvg

module Planet = {
  open ReactNative.Style
  open Js.Math
  @react.component
  let make = (~radius: float, ~theta: float, ~id: string) => {
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

module SolarSystem = {
  open ReactNative.Style

  @react.component
  let make = () => {
    <Svg width={pct(100.)} height={pct(100.)} viewBox={"-130 -130 260 260"}>
      <Planet radius={120.} theta={Js.Math._PI *. 2. /. 3.} id="mars" />
      <Planet radius={100.} theta={0.} id="earth" />
      <Planet radius={80.} theta={-.Js.Math._PI /. 2.} id="venus" />
      <Planet radius={40.} theta={Js.Math._PI} id="mercury" />
      <Planet radius={0.} theta={0.} id="sol" />
    </Svg>
  }
}
