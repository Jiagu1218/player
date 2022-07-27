import rpc from "@ohos.rpc"

export class ASMRData implements rpc.Sequenceable{
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
    //序列化以满足rpc传输
    marshalling(dataOut: rpc.MessageParcel){
        dataOut.writeInt(this.id)
        dataOut.writeInt(this.articleId)
        dataOut.writeString(this.title)
        dataOut.writeString(this.musicUrl)
        dataOut.writeString(this.pageUrl)
        dataOut.writeString(this.imgUrl)
        dataOut.writeInt(this.views)
        dataOut.writeInt(this.duration)
        dataOut.writeInt(this.heart)
        return true
    }

    //反序化以满足rpc传输
    unmarshalling(dataIn: rpc.MessageParcel){
        this.id = dataIn.readInt()
        this.articleId = dataIn.readInt()
        this.title = dataIn.readString()
        this.musicUrl = dataIn.readString()
        this.pageUrl = dataIn.readString()
        this.imgUrl = dataIn.readString()
        this.views = dataIn.readInt()
        this.duration = dataIn.readInt()
        this.heart = dataIn.readInt()
        return true
    }

    valuesBucket(){
        return {
          'articleId':this.articleId,
          'title':this.title,
          'musicUrl':this.musicUrl,
          'pageUrl':this.pageUrl,
          'imgUrl':this.imgUrl,
          'views':this.views,
          'duration':this.duration,
          'heart':this.heart
        }
    }



}