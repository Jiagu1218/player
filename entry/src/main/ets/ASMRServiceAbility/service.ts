import rpc from "@ohos.rpc"
import { getListInfo , getMusicUrl} from '../Util/CheerioUtil'
import dataAbility from '@ohos.data.dataAbility'

import { ASMRData } from '../entity/ASMRData'
import { logInfo } from '../Util/LogUtil'
import {DATA_HElPER,BASE_URI} from '../constant/ColletcitonDataHelperConstant'



/**
 * 存储数据
 * */
function saveDate(datas:Array<ASMRData>) {
    //todo 入库
    logInfo('入库'+datas.length)
    //作为参数传递的Uri,与config中定义的Uri的区别是多了一个"/",是因为作为参数传递的uri中,在第二个与第三个"/"中间,存在一个DeviceID的参数

    let valuesBuckets =[]
    datas.forEach((data) => {
        valuesBuckets.push(data.valuesBucket())
    })
    DATA_HElPER.batchInsert(BASE_URI, valuesBuckets,(error,id)=> {
        logInfo(error.message)
        logInfo('插入:' + id)
        if (id > 0) {

        }
    })

}
let remoteObject
export default {
    onStart() {
        logInfo("ServiceAbility onStart");
        console.log('ServiceAbility onStart');
        //RPC通信 See https://developer.harmonyos.com/cn/docs/documentation/doc-references/js-apis-rpc-0000001281201050#ZH-CN_TOPIC_0000001281201050__onremoterequest
        class MyRemoteObject extends rpc.RemoteObject{
            //重写
            onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, options: rpc.MessageOption){
                if(code == 1){
                    //获取musicUrl
                    logInfo('获取musicUrl')
                    let size = data.readInt()
                    logInfo('size: ' + size)
                    let strArray = new Array<string>()
                    for (let i = 0; i < size; i++) {
                        strArray.push('')
                    }
                    data.readStringArray(strArray)
                    let html = ''.concat(...strArray)
                    reply.writeString(getMusicUrl(html))
                }else if(code == 2){
                    //获取asmrList
                    logInfo('获取asmrList')
                    let size = data.readInt()
                    logInfo('size: ' + size)
                    let strArray = new Array<string>()
                    for (let i = 0; i < size; i++) {
                        strArray.push('')
                    }
                    data.readStringArray(strArray)
                    let html = ''.concat(...strArray)

                    let list = getListInfo(html)
                    reply.writeInt(list.length)
                    reply.writeSequenceableArray(list)
                }else if(code == 3){
                    reply.writeString('返回')
                }
                return true
            }
        }
        console.log('ServiceAbility OnConnect')


        remoteObject= new MyRemoteObject('asmr')
    },
    onCommand(want, startId) {
        logInfo('ServiceAbility onCommand');

    },
    onConnect(want) {
        logInfo("ServiceAbility onConnect");
        if(want.parameters.stop!=undefined){
            logInfo("停止服务")
            //停止服务
            this.terminateSelf()
            return null
        }else{
            logInfo("remoteObject")
//            getInfo('https://www.hentaiasmr.moe/',{pageNum:1},(err,data)=>{
//                getListInfo(data.result.toString())
//            },'post')
            return remoteObject
        }

    },
    onDisconnect(want) {
        if(want.parameters.stop!=undefined){
            logInfo("停止服务")
            //停止服务
            this.terminateSelf()
            return null
        }
        console.log('ServiceAbility OnDisConnect');
    },
    onStop() {
        console.log('ServiceAbility onStop');
    }
}