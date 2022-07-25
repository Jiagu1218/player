import { ASMRData } from '../../entity/ASMRData';
import mediaQuery_WFRd from '@ohos.mediaquery'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'
import { logInfo } from '../../Util/LogUtil'
import {AsmrList} from '../Component/AsmrList'
import {Player} from '../Component/Player'

@Entry
@Component
struct Index {
  //播放列表
  @State playerList:Array<ASMRData> = []

  private controller: TabsController = new TabsController()

  private addPlayListItem=(item:ASMRData)=>{
    console.log(item.title)
    console.log('',this)

    console.log(this.playerList == undefined?'111':'222')
    this.playerList.push(item)
  }

  build() {
    Column() {
      Tabs({barPosition:BarPosition.End,controller:this.controller}){
        TabContent(){
          AsmrList({itemClick:this.addPlayListItem})
        }
        .tabBar({text:'列表'})
        .width('100%')
        .height('100%')

        TabContent(){
          Player({musicList:$playerList})
//          Text(`${this.message}`)
//            .width("300vp")
//            .height("60vp")
//            .fontSize("50fp")
//            .fontWeight(FontWeight.Bold)
//            .textAlign(TextAlign.Center)
//            .onClick(()=>{
//              hilog.info(0x0001, "testTag", "%{public}s", "onClick");
//              //连接本地Service
//              let promise = featureAbility.startAbility(
//                {
//                  want:
//                  {
//                    bundleName: "com.xjg.player",
//                    //PS:module - package + abilityName
//                    abilityName: "com.example.entry.ASMRServiceAbility",
//                  },
//
//                }
//              ).catch(error=>{
//                hilog.error(0x0001, "testTag", "%{public}s", error.toString());
//              })
//            })
        }
        .tabBar({text: '播放'})
        .width('100%')
        .height('100%')
      }
      .scrollable(false)
      .barHeight('200px')

    }
    .width("100%")
    .height("100%")
  }
}