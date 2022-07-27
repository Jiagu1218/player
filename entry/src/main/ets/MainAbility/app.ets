import rpc from '@ohos.rpc';
import featureAbility from '@ohos.ability.featureAbility'
import prompt from '@system.prompt'
import hilog from '@ohos.hilog'
import { logInfo } from '../Util/LogUtil'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'

export default {
  onCreate() {
    console.info('Application onCreate')
    //启动serviceAbility
    featureAbility.startAbility(
      {
        want:
        {
          bundleName: "com.xjg.player",
          //PS:module - package + abilityName
          abilityName: "com.example.entry.ASMRServiceAbility"
        },
      }
    )
    //todo 权限校验获取
    let AtManager = abilityAccessCtrl.createAtManager();
    let tokenID = 0;
    let promise = AtManager.verifyAccessToken(tokenID, "ohos.permission.INTERNET");
    promise.then(data => {
      if(data==-1){
      }else{
        logInfo(`promise: data->${JSON.stringify(data)}`);
      }

    });
  },
  onDestroy() {
    console.info('Application onDestroy')
  },

}