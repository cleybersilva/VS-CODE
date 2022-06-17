import React from 'react';
import {View, StyleSheet, image} from 'react-native';
import imagex from './assets/icons/eco-light-off.png';

const App = () => {
  const toggle = true; //false

  // if toggle retorn light
  return (
     <View style={toggle ? style.containerLight : style.container}>
    <Image source={imagex} />
    </view>
  );
};

export default App;

const style = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'black',
        alignItems: 'center',
        justifyContent: 'center',
    },
    containerLights: {
        flex: 1,
        backgroundColor: 'white',
        alignItems: 'center',
        justifyContent: 'center',
    },
});