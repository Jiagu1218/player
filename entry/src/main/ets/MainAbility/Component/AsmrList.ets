import { ASMRData } from '../../entity/ASMRData';
import { logInfo } from '../../Util/LogUtil'
import {AsmrCard} from '../Component/AsmrCard'
import { getInfo , subHtml} from '../../Util/HttpUtil'
import featureAbility from '@ohos.ability.featureAbility'
import rpc from "@ohos.rpc"
import Url from '@ohos.url'
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
  //当前页
  private pageIndex:number=1
  //与ASMRServiceAbility建立链接返回的对象，用于通信
  private remote:rpc.IRemoteObject = null
  //ListItem 点击事件
  private itemClick:(item:ASMRData)=>void
  //滚动页面控制器
  private scroller: Scroller = new Scroller()
  //菜单（下拉框选项）
  private menus = [{value: '时间'}, {value: '观看数'}, {value: '时长'}, {value: '热门'},{value: '随机'}]
  //排序
  private filter:string = 'latest'
  //网站
  private urlBase:string = 'https://www.hentaiasmr.moe'
  //数据来源url
  private url:string = this.urlBase+'/page/'+this.pageIndex+'/?filter='+this.filter

  @State searchText:string = ''
  private imgLongPressCallback = (event: GestureEvent)=>{
    logInfo(event.repeat.toString())
    //todo 长按保存图片
    if(event.repeat){
      console.log(event.repeat.toString())
    }
  }

  aboutToAppear(){
    //用bind绑定防止this指向改变
    this.connectASMRService(this.getPage.bind(this))
  }
  //链接服务
  connectASMRService(callback?:Function){
    //与ASMRServiceAbility 建立通信
    featureAbility.connectAbility(
      {
        bundleName: "com.xjg.player",
        abilityName: "com.example.entry.ASMRServiceAbility"
      },
      {
        onConnect:(element, remote)=>{
          this.remote = remote
          logInfo("Connect")
          //链接成功调用回调
          if (callback != null){
            callback()
          }
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
    let base = new Url.URL(this.url)
    let paramsObject = new Url.URLSearchParams(base.search.slice(1))
    if(this.searchText != null && this.searchText.length>0){
      paramsObject.set('s',this.searchText)
      logInfo(paramsObject.toString())
    }else{
      paramsObject.delete('s')
    }
    this.url =  this.urlBase+'/page/'+this.pageIndex+'/?'+paramsObject.toString()
  }

  //获取列表
  async getPage(){
    if(this.remote != null && !this.remote.isObjectDead() && !this.loading){
      this.loading = true
//      let url = 'https://www.hentaiasmr.moe/page/'+this.pageIndex+'/?filter=latest'
      let html = await getInfo(this.url,{'pageIndex':0},'')

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
              if(this.pageIndex === 1){
                this.data.length = 0
                setTimeout(()=>{
                  this.data.push(...ret)
                  this.pageIndex = this.pageIndex+1
                  this.loading = false
                },500)
              }else{
                this.data.push(...ret)
                this.pageIndex = this.pageIndex+1
                this.loading = false
              }
            }
          }catch(e) {
            logInfo("Error"+e.message)
            return false
          }
          logInfo('请求成功')
        }else{
          return false
          logInfo('请求失败')
        }
      })
    }else{
      //从新建立链接
      if(this.remote == null || this.remote.isObjectDead()){
        this.connectASMRService()
      }
      logInfo('请求失败')
    }

  }

  //搜索
  search(value:string){
    //先设值在改变index 避免index监听事件先执行读取不到
    this.searchText = value
    this.pageIndex = 1
    this.dataChange()
    this.getPage()

  }

//  transitionFilter(index:number){
//
//    switch (index) {
//      case 0:this.filter = 'latest'
//      break
//      case 1:this.filter = 'most-viewed'
//      break
//      case 2:this.filter = 'longest'
//      break
//      case 3:this.filter = 'popular'
//      break
//      case 4:this.filter = 'random'
//      break
//      default:this.filter = 'latest'
//    }
//
////    if(index == 0){
////      this.filter = 'latest'
////    }else if(index == 1){
////      this.filter = 'most-viewed'
////    }else if(index == 2){
////      this.filter = 'longest'
////    }else if(index == 3){
////      this.filter = 'popular'
////    }else if(index == 4){
////      this.filter = 'random'
////    }else{
////      this.filter = 'latest'
////    }
//    this.data.length = 0
//    this.pageIndex = 1
//    this.getPage()
//  }

  async getMusicUrl(pageUrl):Promise<string>{
    if(this.remote != null && !this.remote.isObjectDead()){
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
      let result:rpc.SendRequestResult = await this.remote.sendRequest(1, data, reply, options)

      if(result.errCode == 0){
        //对称式序列化否者会报错
        try{
          return result.reply.readString()
        }catch(e) {
          logInfo("Error"+e.message)
        }
        logInfo('请求成功')
      }else{
        logInfo('请求失败')
      }
      return ''
    }
  }

  //导航栏标题渲染
  @Builder NavigationTitle(value:string){
    Column(){
      Search({
        value:value,
        placeholder:'搜索'
      })
        //    .width('450lpx')
        .textFont({size:50,weight: 'bold'})
        .onSubmit((value)=>{
          this.search(value)
        })
    }
  }

//  @Builder NavigationMenu(options:Array<SelectOption>,callback:(index:number) =>void){
//    Column(){
//      Select(options)
//        .selected(0)
//        .value('排序')
//        .selectedOptionFont({size: '24',  family: 'serif', style: FontStyle.Normal })
//        .optionFont({size: '20', family: 'serif', style: FontStyle.Normal })
//        .selectedOptionBgColor('red')
//        .onSelect(callback)
//    }
//
//  }

  build(){
    Navigation(){
        Stack({alignContent:Alignment.BottomEnd}){
          Column(){
            Scroll(this.scroller){
              List({space:5}){
                ForEach(this.data,(data:ASMRData,index:number)=>{
                  ListItem(){
                    AsmrCard({
                      data:data,
                      imgLongPressCallback:this.imgLongPressCallback
                    })
                  }
                  .width('100%')
//                  .height('20%')
                  .onClick(event=>{
                    //todo 列表点击事件
                    if(data.musicUrl != null && data.musicUrl.length >0){
                      this.itemClick(data)
                    }else{
                      this.getMusicUrl(data.pageUrl).then(musicUrl=>{
                        if(musicUrl.length > 0){
                          data.musicUrl = musicUrl
                          this.data[index].musicUrl = musicUrl
                          logInfo('musicUrl'+musicUrl)
                          this.itemClick(data)
                        }else{
                          //todo 提示无法获取链接
                        }

                      })
                    }
                  })
                })
                ListItem(){
                  Column(){
                    //todo 加载动画
                    Text("加载中。。。").fontSize('20')
                  }
                  .alignItems(HorizontalAlign.Center)
                  .justifyContent(FlexAlign.Center)
                  .height('100lpx')
                  .width('100%')
                }.visibility(this.loading?Visibility.None:Visibility.Visible)
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
              }
            })

          }
          .height('100%')
          .width('100%')

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
        .height('100%')
        .width('100%')

    }
    .hideBackButton(true)
//    .menus(this.NavigationMenu(this.menus,this.transitionFilter))
    .hideToolBar(true)
    .title(this.NavigationTitle(this.searchText))
//    .toolBar(this.NavigationMenu(this.menus,this.transitionFilter.bind(this)))

  }
}
