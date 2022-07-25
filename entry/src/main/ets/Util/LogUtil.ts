import hiLog from '@ohos.hilog'

export function logInfo(message: string){
    hiLog.info(0x0001, "asmrInfo", "%{public}s", message);
}