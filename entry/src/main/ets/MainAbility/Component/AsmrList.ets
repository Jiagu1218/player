import { ASMRData } from '../../entity/ASMRData';
import { logInfo } from '../../Util/LogUtil'
import {AsmrCard} from '../Component/AsmrCard'
import { getInfo , subHtml} from '../../Util/HttpUtil'
import featureAbility from '@ohos.ability.featureAbility'
import rpc from "@ohos.rpc"
//import dataAbility from '@ohos.data.dataAbility'
//import {DATA_HElPER,COLUMNS,BASE_URI} from '../../constant/ColletcitonDataHelperConstant'

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
      ,135,0,0)
  )

  //列表是否在加载
  @State loading:boolean = false
  @State pageIndex:number=1
  private remote:rpc.IRemoteObject = null
  private itemClick:(item:ASMRData)=>void
  private scroller: Scroller = new Scroller()

  private imgLongPressCallback = (event: GestureEvent)=>{
    logInfo(event.repeat.toString())
    //todo 长按保存图片
    if(event.repeat){
      console.log(event.repeat.toString())
    }
  }
  aboutToAppear(){
    featureAbility.connectAbility(
      {
        bundleName: "com.xjg.player",
        abilityName: "com.example.entry.ASMRServiceAbility"
      },
      {
        onConnect:(element, remote)=>{
          //todo 通讯
          this.remote = remote
          logInfo("Connect")
          //加载第一页列表
          this.getPage()
        },
        onDisconnect:(elementName)=>{
          logInfo("onDisconnect")
          this.remote = null
        },
        onFailed:(code)=>{logInfo("onFailed")}

      }
    )
  }
  /**监听列表变化,更新列表长度和是否在加载
   * */
  dataChange(){
    this.loading = false
  }
  //获取列表
  async getPage(){
    if(this.remote != null && !this.remote.isObjectDead() && !this.loading){
      this.loading = true
      let url = 'https://www.hentaiasmr.moe/page/'+this.pageIndex+'/?filter=latest'
      let html = await getInfo(url,{'pageIndex':0},'')

      let data = rpc.MessageParcel.create()
      //设置大小避免超出存储容量报错
      data.setCapacity((html.length+100)*8)
      let htmlArray:string[] = subHtml(html)
      data.writeInt(htmlArray.length)
      data.writeStringArray(htmlArray)
      let reply = new rpc.MessageParcel()
      let options = new rpc.MessageOption()
      // @ts-ignore
      this.remote.sendRequest(2, data, reply, options).then((result:rpc.SendRequestResult)=>{
        if(result.errCode == 0){
          //对称式序列化否者会报错
          try{
            let dataLength = result.reply.readInt()
            if(dataLength>0){
              let ret = new Array<ASMRData>()
              for(let i=0;i<dataLength;i++){
                ret.push(new ASMRData(0,0,'','','','',0,0,0))
              }
              result.reply.readSequenceableArray(ret)
              this.data.push(...ret)
              this.pageIndex = this.pageIndex+1
            }
          }catch(e) {
            logInfo("Error"+e.message)
          }
          logInfo('请求成功')
        }else{
          logInfo('请求失败')
        }
      })
    }
  }

  async getMusicUrl(pageUrl):Promise<string>{
    if(this.remote != null && !this.remote.isObjectDead() && !this.loading){
      this.loading = true
      let html = await getInfo(pageUrl,{'pageIndex':0},'')

      let data = rpc.MessageParcel.create()
      //设置大小避免超出存储容量报错
      data.setCapacity((html.length+100)*8)
      let htmlArray:string[] = subHtml(html)
      data.writeInt(htmlArray.length)
      data.writeStringArray(htmlArray)
      let reply = new rpc.MessageParcel()
      let options = new rpc.MessageOption()
      // @ts-ignore
      return await this.remote.sendRequest(1, data, reply, options).then((result:rpc.SendRequestResult)=>{
        if(result.errCode == 0){
          //对称式序列化否者会报错
          try{
            return reply.readString()
          }catch(e) {
            logInfo("Error"+e.message)
          }
          logInfo('请求成功')
        }else{
          logInfo('请求失败')
        }
        return ''
      })
    }
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
              this.getMusicUrl(data.pageUrl).then(musicUrl=>{
                data.musicUrl = musicUrl
                logInfo(musicUrl)
                this.itemClick(data)
              })

            })
          })
        }

      }
      .scrollBarColor('red')
      .onScrollEdge((event) => {
        if(Edge.Center==event){
          logInfo("Center")
          this.getPage()
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
        //dataability
//        let valuesBuckets =new Array()
//        this.data.forEach((data) => {
//          valuesBuckets.push(data.valuesBucket())
//        })
//        let predicates = new dataAbility.DataAbilityPredicates()
//        predicates.equalTo('id',1)
//        DATA_HElPER.query(BASE_URI,COLUMNS,predicates,(error,resultSet)=>{
//          logInfo(error.code+"")
//          while(resultSet.goToNextRow()){
//            logInfo(resultSet.getString(resultSet.getColumnIndex('title')))
//          }
//        } )
//        DATA_HElPER.batchInsert(BASE_URI, valuesBuckets,(error,id)=> {
//          let e=error
//          logInfo('插入:' + id)
//        })

      })
    }
  }
}
