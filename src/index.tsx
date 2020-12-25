import { NativeModules } from 'react-native';

type AirscanType = {
  startScanning(): void;
};

const { Airscan } = NativeModules;

export default Airscan as AirscanType;
