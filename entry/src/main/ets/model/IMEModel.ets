// model/IMEModel.ets
export enum PreviewType {
  QWERTY = 'qwerty',
  HANDWRITING = 'handwriting',
  VOICE = 'voice',
  T9 = 't9'
}

export interface IMEModel {
  imeName: string;
  label: string;
  previewType: PreviewType;
  isCurrent: boolean;
}