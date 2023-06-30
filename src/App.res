/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
open ReactNative

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

@react.component
let app = () => {
  let (time, setTime) = React.useState(_ => Js.Date.make()->Js.Date.getTime)
  <SafeAreaView
    style={
      open Style
      Style.style(~backgroundColor="#102030", ~height=pct(100.), ())
    }>
    <TouchableOpacity>
      <Text
        style={
          open Style
          style(~marginTop=8.->dp, ~fontSize=18., ~fontWeight=#400, ~color=Color.white, ())
        }>
        {"Settings noop"->React.string}
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
        style={Style.style(~color=Color.white, ())}
        value={Belt.Float.toString(time)}
      />
    </View>
  </SafeAreaView>
}
