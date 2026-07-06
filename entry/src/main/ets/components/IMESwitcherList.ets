import { inputMethod } from '@kit.IMEKit';
import { IMEModel, PreviewType } from '../model/IMEModel';
import { IMEPreviewCard } from './IMEPreviewCard';
import { IMEManagerService } from '../services/IMEManagerService';

@Component
export struct IMESwitcherList {
  @State imeModels: IMEModel[] = [];
  private imeService: IMEManagerService = IMEManagerService.getInstance();
  private originalIMEs: inputMethod.InputMethodProperty[] = [];

  aboutToAppear(): void {
    this.loadIMEs();
  }

  async loadIMEs(): Promise<void> {
    try {
      this.originalIMEs = await inputMethod.getSetting().getInputMethods(true);
      const models: IMEModel[] = [];
      for (let i = 0; i < this.originalIMEs.length; i++) {
        const ime: inputMethod.InputMethodProperty = this.originalIMEs[i];
        models.push({
          imeName: ime.name,
          label: this.getShortLabel(ime.label ?? `IME ${i + 1}`),
          previewType: this.getPreviewTypeFromName(ime.name),
          isCurrent: ime.name === (this.imeService.getCurrentIME() as inputMethod.InputMethodProperty)?.name
        });
      }
      this.imeModels = models;
    } catch (error) {
      console.error(`[IMEKit] Load IMEs error: ${JSON.stringify(error)}`);
      this.imeModels = this.imeService.getDemoIMEs();
    }
  }

  private getShortLabel(label: string): string {
    if (label.toLowerCase().includes('keyboard')) {return 'KB';}
    if (label.toLowerCase().includes('handwriting')) {return 'Hand';}
    if (label.toLowerCase().includes('voice')) {return 'Voice';}
    if (label.toLowerCase().includes('t9')) {return 'T9';}
    return label.substring(0, 6);
  }

  private getPreviewTypeFromName(name: string): PreviewType {
    const lowerName: string = name.toLowerCase();
    if (lowerName.includes('handwriting')) {return PreviewType.HANDWRITING;}
    if (lowerName.includes('voice')) {return PreviewType.VOICE;}
    if (lowerName.includes('t9') || lowerName.includes('keypad')) {return PreviewType.T9;}
    return PreviewType.QWERTY;
  }

  build() {
    List() {
      ForEach(this.imeModels, (ime: IMEModel) => {
        ListItem() {
          IMEPreviewCard({
            ime: ime,
            onSelect: (): void => { this.onIMESelect(ime.imeName); }
          })
        }
        .margin($r('app.float.card_margin'))
      }, (ime: IMEModel): string => ime.imeName)
    }
    .padding($r('app.float.screen_padding'))
    .alignListItem(ListItemAlign.Center)
  }

  async onIMESelect(imeName: string): Promise<void> {
    const targetIME: inputMethod.InputMethodProperty | undefined =
      this.originalIMEs.find((ime: inputMethod.InputMethodProperty) => ime.name === imeName);
    if (targetIME) {
      const success: boolean = await this.imeService.switchIME(targetIME);
      if (success) {
        await this.loadIMEs();
      }
    }
  }
}