import { ASMRData } from '../../entity/ASMRData';
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
    if(this.playerList.findIndex((music)=>{return music.articleId == item.articleId})<0){
      this.playerList.push(item)
    }
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