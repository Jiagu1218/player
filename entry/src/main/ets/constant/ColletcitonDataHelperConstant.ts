import featureAbility from '@ohos.ability.featureAbility'

export const COLUMNS =['id','articleId','title','musicUrl','pageUrl','imgUrl','views','duration','heart']
export const BASE_URI = 'dataability:///com.xjg.player.CollectionDataAbility'
export const DATA_HElPER = featureAbility.acquireDataAbilityHelper(BASE_URI)