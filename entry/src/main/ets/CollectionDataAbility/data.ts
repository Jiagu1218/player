import dataRdb from '@ohos.data.rdb'
import dataAbility from '@ohos.data.dataAbility'
import featureAbility from '@ohos.ability.featureAbility'
import { logInfo } from '../Util/LogUtil'


const TABLE_NAME = 'hentai_asmr'
//数据库文件名
const STORE_CONFIG = { name: 'asmr.db' }
const SQL_CREATE_TABLE = `
    CREATE TABLE
    IF NOT EXISTS hentai_asmr (
        id INT PRIMARY KEY,
        articleId INT,
        title TEXT NOT NULL,
        musicUrl TEXT,
        pageUrl TEXT,
        imgUrl TEXT,
        views INT,
        duration INT,
        heart INT
    )`
let rdbStore: dataRdb.RdbStore = undefined

/**
 * 收藏
 * */
export default {
    onInitialized(abilityInfo) {
        console.info('DataAbility onInitialized');
        //初始化数据库
        dataRdb.getRdbStore(featureAbility.getContext(),STORE_CONFIG, 1, (err, store) => {
            logInfo(err.code+'    '+err.message)
            //创建表单
            store.executeSql(SQL_CREATE_TABLE)
            rdbStore = store
        })
    },
    insert(uri, valueBucket, callback){
        rdbStore.insert(TABLE_NAME,valueBucket,callback)
    },
    update(uri, valueBucket,predicates, callback){
        console.info('DataAbilityupdate start')
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.update(valueBucket, rdbPredicates, callback)
    },
    query(uri, columns, predicates, callback){
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.query(rdbPredicates,columns, callback)
    },
    /**
     * @param callback 回调函数
     * @return Returns 返回操作信息
     */
    batchInsert(uri: string, valueBuckets: Array<dataRdb.ValuesBucket>, callback: (successful:boolean,errMsg:string) => void){
        let successful:boolean = true
        let errMsg:string
        rdbStore.beginTransaction()
        try{
            valueBuckets.forEach((valueBucket,index) => {
                rdbStore.insert(TABLE_NAME,valueBucket,(err,id)=>{
                    if (id==-1){
                        throw err
                    }
                })
            })
        }catch(err){
            rdbStore.rollBack()
            successful=false
            errMsg = err.message
        }finally{
            rdbStore.commit()
        }
        callback(successful,errMsg)
    },
    delete(uri: string, predicates: dataAbility.DataAbilityPredicates, callback:(err,rows:number)=>void){
        let rdbPredicates = dataAbility.createRdbPredicates(TABLE_NAME, predicates)
        rdbStore.delete(rdbPredicates, callback)
    }
};