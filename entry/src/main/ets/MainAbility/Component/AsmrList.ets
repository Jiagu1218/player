import { ASMRData } from '../../entity/ASMRData';
import { logInfo } from '../../Util/LogUtil'
import {AsmrCard} from '../Component/AsmrCard'


@Preview
@Component
export struct AsmrList{
  //列表数据
  @State @Watch('dataChange') data:Array<ASMRData>
    = new Array<ASMRData>(
    new ASMRData(0,0
      ,'[RJ398341] 【背徳交尾】一緒にお仕事、サボりませんか?～優等生JKの誘惑に負けて快感を貪る～'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ395660.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/07/rj398341_img_main.jpg'
      ,24000,0,0)
    ,
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0),
    new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0)
  )

  //列表是否在加载
  @State loading:boolean = false
  @State pageIndex:number=1
  private itemClick:(item:ASMRData)=>void
  private scroller: Scroller = new Scroller()

  private imgLongPressCallback = (event: GestureEvent)=>{
    logInfo(event.repeat.toString())
    //todo 长按保存图片
    if(event.repeat){
      console.log(event.repeat.toString())
    }
  }

  /**监听列表变化,更新列表长度和是否在加载
   * */
  dataChange(){
    this.loading = false
  }

  aboutToAppear(){
    //this.page()
  }
  build(){
    Stack({alignContent:Alignment.BottomEnd}){
      Scroll(this.scroller){
        List({space:5}){
          ForEach(this.data,(data:ASMRData)=>{
            ListItem(){
              AsmrCard({
                data:data,
                imgLongPressCallback:this.imgLongPressCallback
              })
            }
            .width('100%')
            .height('20%')
            .onClick(event=>{
              //todo 列表点击事件
              this.itemClick(data)
            })
          })
        }

      }
      .scrollBarColor('red')
      .onScrollEdge((event) => {
        console.log(event.toFixed())
        if(Edge.Center==event){
          console.log("Center")
          //todo 请求新数据
          this.pageIndex = this.pageIndex+1
        }else if(Edge.Top==event){
          console.log("Top")
        }else if(Edge.Bottom==event){
          console.log("Bottom")
        }else if(Edge.Start==event){
          console.log("Start")
        }else if(Edge.End==event){
          console.log("End")
        }else if(Edge.Middle==event){
          console.log("Middle")
        }else if(Edge.Baseline==event) {
          console.log("Baseline")
        }
      })

      Button('top')
      .type(ButtonType.Circle).margin({bottom:'50px',right:'50px'})
      .onClick(()=>{
        this.scroller.scrollEdge(Edge.Top)
      })
    }
  }
}
