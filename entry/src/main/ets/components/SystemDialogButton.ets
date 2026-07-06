import { InputMethodListDialog } from '@kit.IMEKit';

@CustomDialog
struct InputMethodDialog {
  controller: CustomDialogController;

  build() {
    Column() {
      InputMethodListDialog({ controller: this.controller })
    }
  }
}

@Component
export struct SystemDialogButton {
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: InputMethodDialog({}),
    customStyle: true,
    maskColor: '#00000000'
  });

  build() {
    Button($r('app.string.open_dialog'))
      .height($r('app.float.button_height'))
      .width($r('app.float.button_width'))
      .backgroundColor($r('app.color.accent'))
      .fontColor($r('app.color.text_primary'))
      .fontSize($r('app.float.text_medium'))
      .borderRadius($r('app.float.button_radius'))
      .onClick((): void => {
        this.dialogController.open();
      })
  }
}