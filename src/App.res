/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
open ReactNative

include ReactNativeHelloWorldUtils

//  Here is StyleSheet that is using Style module to define styles for your components
//  The main different with JavaScript components you may encounter in React Native
//  is the fact that they **must** be defined before being referenced
//  (so before actual component definitions)
//  More at https://rescript-react-native.github.io/docs/style

let styles = {
  open Style
  StyleSheet.create({
    "sectionContainer": viewStyle(~marginTop=32.->dp, ~paddingHorizontal=24.->dp, ()),
    "sectionTitle": textStyle(~fontSize=24., ~fontWeight=#600, ()),
    "sectionDescription": textStyle(~marginTop=8.->dp, ~fontSize=18., ~fontWeight=#400, ()),
    "highlight": textStyle(~fontWeight=#700, ()),
  })
}

let useIsDarkMode = () => {
  Appearance.useColorScheme()
  ->Belt.Option.map(scheme => scheme === #dark)
  ->Belt.Option.getWithDefault(false)
}

// You can notice here the difference when you write a component that is not exported
// We wrap this into a module and use a "make" function
// So we can use <Section /> in JSX like if it was a "const Section = ..." in JavaScript.
module Section = {
  @react.component
  let make = (~title: string, ~children) => {
    let isDarkMode = useIsDarkMode()
    <View style={styles["sectionContainer"]}>
      <Text
        style={
          open Style
          array([
            styles["sectionTitle"],
            textStyle(~color=isDarkMode ? colors.white : colors.black, ()),
          ])
        }>
        {title->React.string}
      </Text>
      <Text
        style={
          open Style
          array([
            styles["sectionDescription"],
            textStyle(~color=isDarkMode ? colors.white : colors.black, ()),
          ])
        }>
        {children}
      </Text>
    </View>
  }
}

type appMode = [#helloworld | #orrery]
@react.component
let app = () => {
  let isDarkMode = useIsDarkMode()
  let (appMode: appMode, setAppMode) = React.useState(_ => #helloworld)
  let (time, setTime) = React.useState(_ => Js.Date.make()->Js.Date.getTime)
  appMode == #orrery
    ? <SafeAreaView
        style={
          open Style
          Style.style(~backgroundColor="#102030", ~height=pct(100.), ())
        }>
        <TouchableOpacity onPress={_ => setAppMode(_ => #helloworld)}>
          <Text
            style={
              open Style
              style(~marginTop=8.->dp, ~fontSize=18., ~fontWeight=#400, ~color=colors.primary, ())
            }>
            {"Go back"->React.string}
          </Text>
        </TouchableOpacity>
        <View
          style={
            open Style
            style(~aspectRatio=1.0, ())
          }
          pointerEvents={#"box-none"}>
          {
            open Orrery
            <SolarSystem time={Js.Date.fromFloat(time)} /> //*. 1000. *. 60. *. 60. *. 24.
          }
          <TextInput
            onChangeText={v => {
              setTime(_ => {
                switch Belt.Float.fromString(v) {
                | None => 0.
                | Some(x) => x
                }
              })
            }}
            value={Belt.Float.toString(time)}
          />
        </View>
      </SafeAreaView>
    : <SafeAreaView>
        <StatusBar barStyle={isDarkMode ? #"dark-content" : #"light-content"} />
        <ScrollView
          contentInsetAdjustmentBehavior=#automatic
          style={
            open Style
            viewStyle(~backgroundColor=isDarkMode ? colors.darker : colors.lighter, ())
          }>
          <Header />
          <Section title={"This app"}>
            <TouchableOpacity onPress={_ => setAppMode(_ => #orrery)}>
              <Text
                style={
                  open Style
                  style(
                    ~marginTop=8.->dp,
                    ~fontSize=18.,
                    ~fontWeight=#400,
                    ~color=colors.primary,
                    (),
                  )
                }>
                {"Open orrery"->React.string}
              </Text>
            </TouchableOpacity>
          </Section>
          <Section title={"Hello world"}>
            {
              open ReactNativeSvg
              open Style

              <Svg height={dp(50.)} width={dp(50.)} viewBox="0 0 100 100">
                <Circle
                  cx={dp(50.)}
                  cy={dp(50.)}
                  r={dp(45.)}
                  stroke="blue"
                  strokeWidth={dp(2.5)}
                  fill="green"
                />
                <Rect
                  x={dp(15.)}
                  y={dp(15.)}
                  width={dp(70.)}
                  height={dp(70.)}
                  stroke="red"
                  strokeWidth={dp(2.)}
                  fill="yellow"
                />
              </Svg>
            }
          </Section>
          <Section title={"See Your Changes"}>
            <ReloadInstructions />
          </Section>
          <Section title={"Debug"}>
            <DebugInstructions />
          </Section>
          <Section title={"ReScript React Native"}>
            {
              let rrnUrl = "https://rescript-react-native.github.io/"
              <TouchableOpacity onPress={_ => openURLInBrowser(rrnUrl)}>
                <Text
                  style={
                    open Style
                    style(
                      ~marginTop=8.->dp,
                      ~fontSize=18.,
                      ~fontWeight=#400,
                      ~color=colors.primary,
                      (),
                    )
                  }>
                  {rrnUrl->React.string}
                </Text>
              </TouchableOpacity>
            }
          </Section>
          <LearnMoreLinks />
        </ScrollView>
      </SafeAreaView>
}
