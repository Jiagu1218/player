import * as cheerio from "cheerio"
import * as dayjs from 'dayjs'
import {getInfo} from '../Util/HttpUtil'
import { ASMRData } from '../entity/ASMRData'
import { logInfo } from '../Util/LogUtil'

/*
 *获取列表信息
  */
function getListInfo (html:String){
    const $ = cheerio.load(html)
    dayjs.locale('zh-cn')
    $('.videos-list>article').map((index,item)=>{
        let article = $(item)
        //id
        let articleId = Number.parseInt(article.attr('data-post-id'))
        logInfo(articleId.toString())

        //页面链接
        let pageUrl = article.find('a').attr('href')
        //标题
        let title = article.find('a').attr('title')
        logInfo(pageUrl)
        //图片链接
        let imgUrl = article.find('img').attr('data-src')
        logInfo(imgUrl)
        //时长
        let durationStr = article.find('.duration').text().trim()
        let duration = 0
        durationStr.split(':').reverse().forEach((item,index) => {
            //转换成秒
            duration = Math.pow(60,index) * Number.parseInt(item) + duration
        });
        duration = duration * 1000
        logInfo(duration.toString())

        //观看数
        let views = 0
        let viewStr = article.find('.views').text()
        if(viewStr.endsWith('K')){
            views = Number.parseInt(viewStr.replace('K','')) * 1000
        }else{
            views = Number.parseInt(viewStr)
        }

        let heart = Number.parseInt(article.find('.fa.fa-heart').text())
        logInfo(heart.toString())
        logInfo(views.toString())

        //todo 音频文件链接问题 异步
        let musicUrl
        getInfo(pageUrl,{},(err,data)=>{
            musicUrl = getMusicUrl(data.result.toString())
            let asmrData = new ASMRData(0,articleId,title,musicUrl,pageUrl,imgUrl,views,duration,heart)
            saveDate(asmrData)
            logInfo(musicUrl)
        },'get')


        logInfo($(item).html())
    })

}


/**
 * 获取音乐链接
 * **/
function getMusicUrl(html) {
    const $ = cheerio.load(html)
    return $("meta[property='og:audio']").attr('content')
}

/**
 * 存储数据
 * */
function saveDate(data:ASMRData) {
    //todo 入库
}

export default {
    onStart() {
        logInfo("ServiceAbility onStart");
        console.log('ServiceAbility onStart');

    },
    onCommand(want, startId) {
        console.log('ServiceAbility onCommand');
        getInfo('https://www.hentaiasmr.moe/',{pageNum:1},(err,data)=>{
            getListInfo(data.result.toString())
        },'post')
    },
    onConnect(want) {
        console.log('ServiceAbility OnConnect');
        return null;
    },
    onDisconnect(want) {
        console.log('ServiceAbility OnDisConnect');
    },
    onStop() {
        console.log('ServiceAbility onStop');
    },
}