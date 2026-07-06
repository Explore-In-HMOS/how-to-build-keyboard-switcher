import { inputMethod } from '@kit.IMEKit';
import { IMEModel, PreviewType } from '../model/IMEModel';
import { promptAction } from '@kit.ArkUI';

export class IMEManagerService {
  private static instance: IMEManagerService;

  static getInstance(): IMEManagerService {
    if (!IMEManagerService.instance) {
      IMEManagerService.instance = new IMEManagerService();
    }
    return IMEManagerService.instance;
  }

  async getAvailableIMEs(): Promise<IMEModel[]> {
    try {
      const imeList: inputMethod.InputMethodProperty[] = await inputMethod.getSetting().getInputMethods(true);
      const models: IMEModel[] = [];
      for (let i = 0; i < imeList.length; i++) {
        const ime: inputMethod.InputMethodProperty = imeList[i];
        models.push({
          imeName: ime.name,      
          label: ime.label ?? this.getDefaultLabel(i),
          previewType: this.mapToPreviewType(i),
          isCurrent: ime.name === this.getCurrentIME()?.name
        });
      }
      return models;
    } catch (error) {
      console.error(`[IMEKit] Get IMEs error: ${JSON.stringify(error)}`);
      return this.getDemoIMEs();
    }
  }

  async switchIME(targetIME: inputMethod.InputMethodProperty): Promise<boolean> {
    try {
      await inputMethod.switchInputMethod(targetIME);
      await this.showToast($r('app.string.switch_success'));
      return true;
    } catch (error) {
      console.error(`[IMEKit] Switch error: ${JSON.stringify(error)}`);
      await this.showToast($r('app.string.switch_failed'));
      return false;
    }
  }

  getCurrentIME(): inputMethod.InputMethodProperty | null {
    try {
      return inputMethod.getCurrentInputMethod();
    } catch (error) {
      console.error(`[IMEKit] Get current IME error: ${JSON.stringify(error)}`);
      return null;
    }
  }

  private async showToast(resource: Resource): Promise<void> {
    await promptAction.showToast({ message: resource, duration: 1500 });
  }

  private getDefaultLabel(index: number): string {
    const labels: string[] = ['QWERTY Keyboard', 'Handwriting Input', 'Voice Input', 'T9 Keypad'];
    return labels[index % labels.length];
  }

  private mapToPreviewType(index: number): PreviewType {
    const types: PreviewType[] = [PreviewType.QWERTY, PreviewType.HANDWRITING, PreviewType.VOICE, PreviewType.T9];
    return types[index % types.length];
  }

  getDemoIMEs(): IMEModel[] {
    return [
      { imeName: 'com.huawei.hmos.qwerty', label: 'QWERTY Keyboard', previewType: PreviewType.QWERTY, isCurrent: true },
      { imeName: 'com.huawei.hmos.handwriting', label: 'Handwriting Input', previewType: PreviewType.HANDWRITING, isCurrent: false },
      { imeName: 'com.huawei.hmos.voice', label: 'Voice Input', previewType: PreviewType.VOICE, isCurrent: false },
      { imeName: 'com.huawei.hmos.t9', label: 'T9 Keypad', previewType: PreviewType.T9, isCurrent: false }
    ];
  }
}