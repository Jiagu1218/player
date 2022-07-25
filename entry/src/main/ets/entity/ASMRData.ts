
export class ASMRData{
    id:number
    articleId:number
    title:string
    musicUrl:string
    pageUrl:string
    imgUrl:string
    views:number
    duration:number
    heart:number

    /**
     * @param id 本地id
     * @param articleId 网页id
     * @param title 标题
     * @param musicUrl 音频url
     * @param pageUrl 页面url
     * @param imgUrl 图片url
     * @param views 观看数
     * @param duration 时长
     * */
    constructor(id:number,articleId:number,title:string,musicUrl:string,pageUrl:string,imgUrl:string,views:number,duration:number,heart:number){
        this.id = id
        this.articleId = articleId
        this.title = title
        this.musicUrl = musicUrl
        this.pageUrl = pageUrl
        this.imgUrl = imgUrl
        this.views = views
        this.duration = duration
        this.heart = heart
    }

    valuesBucket(){
        return {
          articleId:this.articleId,
          title:this.title,
          musicUrl:this.musicUrl,
          pageUrl:this.pageUrl,
          imgUrl:this.imgUrl,
          views:this.views,
          duration:this.duration,
          heart:this.heart
        }
    }



}