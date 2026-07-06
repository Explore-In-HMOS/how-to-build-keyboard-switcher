import { SystemDialogButton } from '../components/SystemDialogButton';
import { IMESwitcherList } from '../components/IMESwitcherList';
import { inputMethod } from '@kit.IMEKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  private currentTab: number = 0;
  private tabBarTitles: string[] = ['Sys', 'IME', 'Panel'];
  private inputController: inputMethod.InputMethodController = inputMethod.getController();

  private async showKeyboard(): Promise<void> {
    try {
      await this.inputController.showTextInput();
      promptAction.showToast({ message: 'Keyboard opened', duration: 1000 });
    } catch (error) {
      console.error(`Show keyboard error: ${JSON.stringify(error)}`);
      promptAction.showToast({ message: 'Cannot open keyboard - permission required', duration: 2000 });
    }
  }

  private async hideKeyboard(): Promise<void> {
    try {
      await this.inputController.hideTextInput();
      promptAction.showToast({ message: 'Keyboard closed', duration: 1000 });
    } catch (error) {
      console.error(`Hide keyboard error: ${JSON.stringify(error)}`);
      promptAction.showToast({ message: 'Cannot close keyboard', duration: 2000 });
    }
  }

  build() {
    Tabs({ index: this.currentTab, barPosition: BarPosition.Start }) {
      TabContent() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          SystemDialogButton()

          Text('System IME')
            .fontSize('10fp')
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 8 })
            .opacity(0.7)
        }
        .width('100%')
        .height('100%')
        .padding('8vp')
      }
      .tabBar(this.tabBarTitles[0])

      TabContent() {
        IMESwitcherList()
      }
      .tabBar(this.tabBarTitles[1])

      TabContent() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text('Keyboard Control')
            .fontSize('12fp')
            .fontColor($r('app.color.text_primary'))
            .fontWeight(FontWeight.Medium)

          TextInput()
            .width('1vp')
            .height('1vp')
            .opacity(0)
            .id('hiddenInput')
            .defaultFocus(false)

          Button('Show Keyboard')
            .height('36vp')
            .width('120vp')
            .fontSize('10fp')
            .backgroundColor($r('app.color.card_bg'))
            .borderRadius('18vp')
            .onClick((): void => {
              this.showKeyboard();
            })

          Button('Hide Keyboard')
            .height('36vp')
            .width('120vp')
            .fontSize('10fp')
            .backgroundColor($r('app.color.accent_dark'))
            .borderRadius('18vp')
            .onClick((): void => {
              this.hideKeyboard();
            })
        }
        .width('100%')
        .height('100%')
        .padding('8vp')
      }
      .tabBar(this.tabBarTitles[2])
    }
    .vertical(false)
    .barHeight('32vp')
    .backgroundColor($r('app.color.bg_primary'))
    .scrollable(true)
  }
}