import cheerio from "cheerio"
import { ASMRData } from '../entity/ASMRData'
import { logInfo } from '../Util/LogUtil'

/**
 * 获取音乐链接
 * **/
function getMusicUrl(html):string {
    const $ = cheerio.load(html)
    return $("meta[property='og:audio']").attr('content')
};

/*
 *获取列表信息
  */
function getListInfo(html:String):Array<ASMRData> {
    const $ = cheerio.load(html)
    let data = new Array<ASMRData>();
    $('.videos-list>article').each((index,item)=>{
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
        //        let musicUrl = getMusicUrl(getInfo(pageUrl,{},'get'))
        //        logInfo(musicUrl)
        data.push(new ASMRData(0,articleId,title,'',pageUrl,imgUrl,views,duration,heart))
        //        logInfo($(item).html())
    })
    return data
};

export {getListInfo,getMusicUrl}