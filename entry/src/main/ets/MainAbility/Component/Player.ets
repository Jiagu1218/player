import { ASMRData } from '../../entity/ASMRData';
import featureAbility from '@ohos.ability.featureAbility'
import dataAbility  from '@ohos.data.dataAbility'
import media from '@ohos.multimedia.media'
import {logInfo} from '../../Util/LogUtil'
import {AsmrCard} from '../Component/AsmrCard'

@Component
export struct Player{
  //双向绑定
  @Link musicList:Array<ASMRData>
  @State @Watch('currentMusicChange') currentMusic:ASMRData = new ASMRData(0,0
    ,'[RJ398341] 【背徳交尾】一緒にお仕事、サボりませんか?～優等生JKの誘惑に負けて快感を貪る～'
    ,'https://cdn.hentaiasmr.moe/asmr4/RJ395660.mp3'
    ,''
    ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/07/rj398341_img_main.jpg'
    ,24000,0,0)
  @State @Watch('watchPlaying') playing:boolean = false
  @State intervalId:number = 0
  @State showList:boolean = false
  //进度条最大值
  @State max:number = 0
  //当前进度条位置
  @State currentTime:number = 0
  @State love:boolean = false
  audioPlayer:media.AudioPlayer = media.createAudioPlayer()

  //当前音乐发生变化时回调
  currentMusicChange(){
    this.currentTime = 0
    this.playing = false
    //todo 更新 收藏、进度条最大值状态
    //查询收藏情况
  }
  //监听播放状态更新当前位置
  watchPlaying(){
    if(this.playing){
      this.max = this.audioPlayer.duration
      this.intervalId=setInterval(()=>{
        this.currentTime = this.audioPlayer.currentTime
        logInfo(this.audioPlayer.duration+"")
        logInfo(this.audioPlayer.currentTime+"")
      },1000)
    }else{
      clearInterval(this.intervalId)
    }
  }

  //收藏或取消收藏
  collection(data:ASMRData){
    let uri = 'dataability://com.xjg.player.CollectionDataAbility'
    let valuesBucket= data.valuesBucket()
    let dataHelper = featureAbility.acquireDataAbilityHelper(uri)
    if(this.love){
      //移除收藏
      let predicates =new dataAbility.DataAbilityPredicates()
      predicates.equalTo('articleId',this.currentMusic.articleId)
      dataHelper.delete(uri, predicates,(error,rows)=>{
        if(rows>0){
          this.love = false
        }
      })
    }else{
      //添加收藏
      dataHelper.insert(uri,valuesBucket,(error,id)=>{
        if(id>0){
          this.love = true
        }
      })
    }
  }

  nextMusic(){
    this.musicList.push(new ASMRData(0,0
      ,'[RJ382541] 獣も触手もおっきすぎ!こんな苦しいのになんで気持ちいいの…【CV:篠ノ井凛】'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ382541.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/06/rj382541_img_main.jpg'
      ,135,0,0))
    console.log('nextMusic')
    let index = this.musicList.indexOf(new ASMRData(0,0
      ,'[RJ398341] 【背徳交尾】一緒にお仕事、サボりませんか?～優等生JKの誘惑に負けて快感を貪る～'
      ,'https://cdn.hentaiasmr.moe/asmr4/RJ395660.mp3'
      ,''
      ,'https://www.hentaiasmr.moe/wp-content/uploads/2022/07/rj398341_img_main.jpg'
      ,24000,0,0))
    console.log("位置"+index)
  }

  aboutToAppear(){
    if(this.audioPlayer==null){
      this.audioPlayer = media.createAudioPlayer()
    }
    //加载完成时
    this.audioPlayer.on('dataLoad',()=>{
      this.audioPlayer.play()
    })
    this.audioPlayer.on('play',()=>{
      logInfo("播放")

      this.playing=true
    })
    this.audioPlayer.on('pause',()=>{
      this.playing=false
    })
    this.audioPlayer.on('stop',()=>{
      clearInterval(this.intervalId)
      this.playing=false
      this.audioPlayer.release()
    })
    this.audioPlayer.on('reset',()=>{
      //todo 切换音频
    })
    this.audioPlayer.on('finish',()=>{
      this.playing=false
    })
    this.audioPlayer.on('error',(error)=>{
      logInfo(error.message)
    })


  }

  //todo 处理横屏下的布局
  build(){
    Flex({direction:FlexDirection.Column}){
      Flex({justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center,direction:FlexDirection.Column}){
        Image(this.currentMusic.imgUrl)
        .height('800px')
        .width('800px')
        .clip(new Circle({width:'800px', height:'800px'}))
        Row(){
          Slider({step:1000,min:0,max:this.max,value:this.currentTime,style: SliderStyle.InSet})
          .onChange((value,mode) => {
            if(mode==SliderChangeMode.Moving){
              //todo 滑动中显示时间
            }else if(mode==SliderChangeMode.End){
              //todo 滑动结束调整进度条
            }
          })
        }
        .margin({top:'50px'})
        //控制按钮
        Row({space: '40px'}){
          Button('<',{stateEffect:this.musicList.length>0})
          if(this.playing){
            Button('||').onClick(()=>{
              this.audioPlayer.stop()
            })
          }else{
            Button(
              '▷'
//              ,{stateEffect:this.audioPlayer.src.length>0}
            ).onClick(()=>{

              let state = this.audioPlayer.state
              if(state=='playing'){
                //播放中
                this.audioPlayer.pause()
                return
              }else if(state == 'idle'){
                //空闲
                this.audioPlayer.src = this.currentMusic.musicUrl
              }
              this.audioPlayer.play()
            })
          }

          Button('>',{stateEffect:this.musicList.length>0}).onClick(()=>{this.nextMusic()})
          Button(this.love?'🤍':'🖤').onClick(()=>{
            this.collection(this.currentMusic)
          })
          Button(this.audioPlayer.loop?'⇆':'⇉').onClick(()=>{this.audioPlayer.loop = !this.audioPlayer.loop})

        }
        .justifyContent(FlexAlign.Center)
        .margin({top:'50px'})

      }
      .visibility(this.showList?Visibility.None:Visibility.Visible)
      .width('100%')
      .height('100%')
      //.height(`${this.height-100-400}px`)
      .backgroundColor('red')

      //播放列表
      Flex(){
        //todo 播放列表
        if(this.showList){
          Stack({alignContent:Alignment.BottomEnd}){
            Column(){
              Scroll(){
                List({space:5}){
                  ForEach(this.musicList,(music:ASMRData)=>{
                    ListItem(){
                      AsmrCard({
                        data:music
                      })
                    }
                  })
                }
              }
              .onScrollEdge((event) => {
                if(Edge.Bottom==event){
                  console.log("top")
                }
              })
              .scrollBarColor('red')
            }
            .height('100%')

            Button('back')
              .type(ButtonType.Circle).margin({bottom:'50px',right:'50px'})
            .onClick(()=>{
              this.showList = false
            })
          }
          .height('100%')
          .width('100%')
        }else{
          Flex(){
            Flex(){
              Image('https://www.hentaiasmr.moe/wp-content/uploads/2022/07/rj398341_img_main.jpg')
            }
            .width('30%')
            Flex({direction:FlexDirection.Column}){
              Text('[RJ398341] 【背徳交尾】一緒にお仕事、サボりませんか?～優等生JKの誘惑に負けて快感を貪る～')
                .fontSize('24').maxLines(2).textOverflow({overflow: TextOverflow.Ellipsis})
            }
            .width('70%')
          }
        }

      }
      .onClick(()=>{
        this.showList = true
      })
      .height(this.showList?'100%':'200px')
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}