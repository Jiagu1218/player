import http from '@ohos.net.http'

import { logInfo } from '../Util/LogUtil'


async function getInfo(url:string,data,method):Promise<string> {
    // 每一个httpRequest对应一个http请求任务，不可复用
    let httpRequest = http.createHttp();
    // 用于订阅http响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
    // 从API 8开始，使用on('headersReceive', Callback)替代on('headerReceive', AsyncCallback)。 8+
    httpRequest.on('headersReceive', (header) => {
        logInfo('header: ' + JSON.stringify(header));
    });
    let response = await  httpRequest.request(
        // 填写http请求的url地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
        url,
        {
            method: method==undefined?http.RequestMethod.GET:'post'==method.toLowerCase()?http.RequestMethod.POST:http.RequestMethod.GET, // 可选，默认为http.RequestMethod.GET
            // 开发者根据自身业务需要添加header字段
            header: {
                'Content-Type': 'application/json'
            },
            // 当使用POST请求时此字段用于传递内容
            extraData: {
                "data": data,
            },
            connectTimeout: 60000, // 可选，默认为60s
            readTimeout: 60000, // 可选，默认为60s
        }

//        ,
//        (err, data) => {
////            callback(err, data)
//            if (!err) {
//
//                /*// data.result为http响应内容，可根据业务需要进行解析
//                logInfo('Result:' + data.result);
//                logInfo('code:' + data.responseCode);
//                // data.header为http响应头，可根据业务需要进行解析
//                logInfo('header:' + JSON.stringify(data.header));
//                logInfo('cookies:' + data.cookies); // 8+*/
//            } else {
//                logInfo('error:' + JSON.stringify(err));
//                // 当该请求使用完毕时，调用destroy方法主动销毁。
//                httpRequest.destroy();
//            }
//        }
    )
    httpRequest.destroy();
    return response.result.toString()
};

function subHtml(html: string): string[] {
    let size = 10240
    let htmlLength = html.length


    let arr= ['']
    if(htmlLength>size) {
        let length = Math.ceil(htmlLength/size)
        for(let i=0; i<length; i++){
            if(i==length){
                arr.push(html.substring(size*(i-1)))
            }else{
                arr.push(html.substring(size*i, size*(i+1)))
            }
        }
    }else {
        arr.push(html)
    }

    return arr
}

export {getInfo,subHtml}

