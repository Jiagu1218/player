import { ASMRData } from '../../entity/ASMRData'

@Preview
@Component
export struct AsmrCard{
//  title: string
//  duration :string
//  heart:number
//  views:number
//  url:string
  data:ASMRData
  //图片长按事件
  private imgLongPressCallback:(event: GestureEvent)=>void


  build(){
    Flex(){
      Flex(){
        Image(this.data.imgUrl).priorityGesture(
          LongPressGesture({duration:1000}).onAction(this.imgLongPressCallback)
        )
      }
      .width('40%')
      Flex({direction:FlexDirection.Column}){
        Text(`标题: ${this.data.title}`).fontSize('24').maxLines(2).textOverflow({overflow: TextOverflow.Ellipsis})
        Text(`时长: ${this.data.duration}`).fontSize('20')
        Text(`喜爱: ${this.data.heart}`).fontSize('20')
        Text(`观看 ${this.data.views}`).fontSize('20')
      }
      .width('60%')
    }
  }
}