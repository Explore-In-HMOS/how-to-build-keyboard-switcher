import { IMEModel } from '../model/IMEModel';

@Component
export struct IMEPreviewCard {
  @Prop ime: IMEModel;
  onSelect: () => void = () => {};

  build() {
    Column() {
      Image($r(`app.media.preview_${this.ime.previewType}`))
        .width($r('app.float.preview_image_height'))
        .height($r('app.float.preview_image_height'))
        .objectFit(ImageFit.Contain)

      Text(this.ime.label)
        .fontSize($r('app.float.text_small'))
        .fontColor($r('app.color.text_primary'))
        .margin({ top: 4 })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      if (this.ime.isCurrent) {
        Text('✓')
          .fontSize($r('app.float.text_small'))
          .fontColor($r('app.color.accent'))
          .margin({ top: 2 })
      }
    }
    .width($r('app.float.card_width'))
    .height($r('app.float.card_height'))
    .padding($r('app.float.card_padding'))
    .backgroundColor($r('app.color.card_bg'))
    .borderRadius($r('app.float.card_radius'))
    .onClick(() => this.onSelect())
    .justifyContent(FlexAlign.Center)
  }
}